import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import { AppException } from '../../common/errors/app.exception';
import { CurrentUserContext } from '../../common/auth/auth.types';
import { MealType, RecognitionSource } from '../../common/domain/enums';
import { toLocalDateUTC } from '../../common/util/local-date';
import { ClaudeClient, ClaudeImageInput } from './claude.client';
import { RecognitionResultDto, RecognizedItemDto } from './dto/recognition-response.dto';

interface RecognizeInput {
  source: RecognitionSource;
  text?: string;
  /** 原图(临时 buffer);仅本方法生命周期内存在,处理后即丢弃,绝不落库(§4.7) */
  image?: { buffer: Buffer; mediaType: string };
  /** 客户端时区下的本地日期 YYYY-MM-DD(限流自然日键);缺省用服务端 UTC 兜底 */
  localDate?: string;
}

/**
 * AI 食物识别(API.md §4.10 · 核心)。流程:
 *  1) 每日限流:RecognitionUsage @@unique(ownerId,localDate) 事务内原子计数,超 30 次→429;
 *  2) 调用 Claude(后端代理,密钥不下发);
 *  3) 解析 + 校验结构化 JSON,异常降级为 RECOGNIZE_FAILED(不崩);
 *  4) 原图最小化:仅在内存临时持有,处理后即弃(finally 清引用),DB 不存原图/URL,响应不含原图 URL;
 *  5) 落 RecognitionAudit 脱敏记录(不含原图/PII)。
 * 结果不自动入库,返回前端编辑确认。
 */
@Injectable()
export class RecognitionService {
  private readonly logger = new Logger(RecognitionService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly config: ConfigService,
    private readonly claude: ClaudeClient,
  ) {}

  async recognize(user: CurrentUserContext, input: RecognizeInput): Promise<RecognitionResultDto> {
    const localDate = input.localDate ?? toLocalDateUTC();
    const limit = this.config.get<number>('recognitionDailyLimit') ?? 30;

    // 原图大小上限(API.md §4.10 ≤8MB);超限归一为无法识别,不落库
    const maxBytes = this.config.get<number>('anthropic.maxImageBytes') ?? 8 * 1024 * 1024;
    if (input.image && input.image.buffer.length > maxBytes) {
      input.image.buffer = Buffer.alloc(0); // 立即弃图
      throw new AppException('RECOGNIZE_FAILED');
    }

    // 1) 限流:事务内原子 upsert + 读回 count,超上限回滚并 429(成本控制 F10)
    await this.consumeQuota(user.id, localDate, limit);

    const startedAt = Date.now();
    // 原图临时 buffer:用 let 持有,finally 主动清引用(最小化留存,§4.7)
    let image: ClaudeImageInput | null = input.image
      ? { base64: input.image.buffer.toString('base64'), mediaType: input.image.mediaType }
      : null;

    let success = false;
    let model: string | null = null;
    let errorCode: string | null = null;

    try {
      const raw = await this.claude.analyze({
        text: input.text,
        image: image ?? undefined,
      });
      model = raw.model;
      const items = this.parseAndValidate(raw.text);
      success = true;
      return {
        items,
        suggestedMealType: this.suggestMealType(),
        disclaimerKey: 'recognize.disclaimer',
      };
    } catch (err) {
      // 已知 AppException(TIMEOUT/NETWORK_ERROR/RECOGNIZE_FAILED)原样抛;
      // 其余一律降级为 RECOGNIZE_FAILED(绝不崩、不泄露细节)
      if (err instanceof AppException) {
        errorCode = err.errorKey;
        throw err;
      }
      errorCode = 'RECOGNIZE_FAILED';
      throw new AppException('RECOGNIZE_FAILED');
    } finally {
      // 原图最小化:无论成功失败,处理结束立即丢弃内存中的原图引用
      image = null;
      if (input.image) input.image.buffer = Buffer.alloc(0);
      // 落脱敏审计(不含原图/原文/PII);失败不影响主流程
      await this.writeAudit({
        ownerId: user.id,
        source: input.source,
        success,
        latencyMs: Date.now() - startedAt,
        model,
        errorCode,
      });
    }
  }

  /**
   * 事务内原子消费配额。先 upsert 保证行存在,再 updateMany(count<limit)increment;
   * 若未命中(已达上限)→ 抛 429。@@unique(ownerId,localDate) 保证并发安全。
   */
  private async consumeQuota(ownerId: string, localDate: string, limit: number): Promise<void> {
    await this.prisma.$transaction(async (tx: Prisma.TransactionClient) => {
      const existing = await tx.recognitionUsage.findUnique({
        where: { ownerId_localDate: { ownerId, localDate } },
      });
      if (!existing) {
        await tx.recognitionUsage.create({ data: { ownerId, localDate, count: 1 } });
        return;
      }
      if (existing.count >= limit) {
        throw new AppException('RECOGNIZE_LIMIT_REACHED');
      }
      // 条件更新防并发越界:仅当 count 仍 < limit 时 +1
      const updated = await tx.recognitionUsage.updateMany({
        where: { ownerId, localDate, count: { lt: limit } },
        data: { count: { increment: 1 } },
      });
      if (updated.count === 0) {
        throw new AppException('RECOGNIZE_LIMIT_REACHED');
      }
    });
  }

  /**
   * 解析 Claude 文本为结构化 items。容错:剥离可能的代码块包裹;
   * 解析/结构非法 → RECOGNIZE_FAILED;空 items 也视为无法识别(走前端兜底手动添加)。
   */
  private parseAndValidate(text: string): RecognizedItemDto[] {
    const json = this.extractJson(text);
    let parsed: unknown;
    try {
      parsed = JSON.parse(json);
    } catch {
      throw new AppException('RECOGNIZE_FAILED');
    }
    const rawItems = (parsed as { items?: unknown })?.items;
    if (!Array.isArray(rawItems) || rawItems.length === 0) {
      throw new AppException('RECOGNIZE_FAILED');
    }
    const items = rawItems
      .map((it) => this.normalizeItem(it))
      .filter((it): it is RecognizedItemDto => it !== null);
    if (items.length === 0) {
      throw new AppException('RECOGNIZE_FAILED');
    }
    return items;
  }

  private extractJson(text: string): string {
    const trimmed = text.trim();
    // 容错:模型偶尔用 ```json ... ``` 包裹,或前后带杂字;截取首个 { 到末个 }
    const start = trimmed.indexOf('{');
    const end = trimmed.lastIndexOf('}');
    if (start === -1 || end === -1 || end <= start) {
      throw new AppException('RECOGNIZE_FAILED');
    }
    return trimmed.slice(start, end + 1);
  }

  /** 单条归一 + 数值清洗(非负、置信度 0..1);字段缺失或类型非法则丢弃该条。 */
  private normalizeItem(raw: unknown): RecognizedItemDto | null {
    if (typeof raw !== 'object' || raw === null) return null;
    const r = raw as Record<string, unknown>;
    const name = typeof r.name === 'string' ? r.name.trim().slice(0, 120) : '';
    if (!name) return null;
    const num = (v: unknown, def = 0): number => {
      const n = typeof v === 'number' ? v : typeof v === 'string' ? parseFloat(v) : NaN;
      return Number.isFinite(n) && n >= 0 ? n : def;
    };
    const conf = num(r.confidence, 0);
    return {
      name,
      quantity: num(r.quantity, 1) || 1,
      unit: typeof r.unit === 'string' && r.unit.trim() ? r.unit.trim().slice(0, 24) : 'serving',
      kcal: num(r.kcal),
      proteinG: num(r.protein),
      carbsG: num(r.carbs),
      fatG: num(r.fat),
      confidence: conf > 1 ? 1 : conf,
    };
  }

  /** 按当前服务器时段智能推荐餐次(F7);前端可改。 */
  private suggestMealType(): MealType {
    const h = new Date().getHours();
    if (h < 10) return MealType.BREAKFAST;
    if (h < 15) return MealType.LUNCH;
    if (h < 21) return MealType.DINNER;
    return MealType.SNACK;
  }

  private async writeAudit(data: {
    ownerId: string;
    source: RecognitionSource;
    success: boolean;
    latencyMs: number;
    model: string | null;
    errorCode: string | null;
  }): Promise<void> {
    try {
      await this.prisma.recognitionAudit.create({
        data: {
          ownerId: data.ownerId,
          source: data.source,
          success: data.success,
          latencyMs: data.latencyMs,
          model: data.model,
          errorCode: data.errorCode,
        },
      });
    } catch (err) {
      // 审计失败不影响主流程,仅记录(不含 PII/原图)
      this.logger.warn(`recognition audit write failed: ${String(err)}`);
    }
  }
}
