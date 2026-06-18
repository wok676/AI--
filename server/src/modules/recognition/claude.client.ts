import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AppException } from '../../common/errors/app.exception';

/**
 * Claude 调用结果:成功返回结构化 items(已由模型按 system prompt 约束输出 JSON)。
 * 本客户端只负责「调用 + 拿到原始文本」,解析/校验交 RecognitionService。
 */
export interface ClaudeRawResult {
  /** 模型返回的纯文本(应为约束后的 JSON 字符串) */
  text: string;
  /** 实际调用的模型标识(落审计) */
  model: string;
}

/** 图片入参:仅在请求处理期临时持有,调用后由上层 finally 清理,绝不落库。 */
export interface ClaudeImageInput {
  /** base64(不含 data: 前缀) */
  base64: string;
  /** image/jpeg | image/png */
  mediaType: string;
}

/**
 * 后端代理 Claude 视觉/文本模型(密钥走 .env,绝不下发客户端 §6)。
 * 用全局 fetch 直连 Anthropic Messages API,避免引入重型 SDK 依赖,且便于测试 mock。
 * system prompt 强约束「只输出结构化 JSON」。超时/网络异常归一为 TIMEOUT/NETWORK_ERROR。
 */
@Injectable()
export class ClaudeClient {
  private readonly logger = new Logger(ClaudeClient.name);

  constructor(private readonly config: ConfigService) {}

  private readonly systemPrompt =
    'You are a nutrition estimation engine. Identify foods from the user input (image and/or text) ' +
    'and estimate nutrition. Respond with ONLY a single minified JSON object, no markdown, no prose, ' +
    'matching exactly this shape: ' +
    '{"items":[{"name":string,"quantity":number,"unit":string,"kcal":number,"protein":number,' +
    '"carbs":number,"fat":number,"confidence":number}]}. ' +
    'Rules: unit is one of serving/g/ml/piece/cup/bowl; kcal/protein/carbs/fat are non-negative numbers ' +
    '(grams for macros); confidence is between 0 and 1. If nothing edible can be identified, return ' +
    '{"items":[]}. Never include any text outside the JSON object.';

  /**
   * 调用 Claude。失败时抛 AppException(TIMEOUT/NETWORK_ERROR/RECOGNIZE_FAILED),
   * 由上层落审计 + 转 i18n。日志绝不打印图片/原文/密钥(§6 脱敏)。
   */
  async analyze(input: {
    text?: string;
    image?: ClaudeImageInput;
    /** 用户 locale(BCP-47,如 zh / en / ja);指示模型用该语言输出食物名,其余字段不变 */
    locale?: string;
  }): Promise<ClaudeRawResult> {
    const apiKey = this.config.get<string>('anthropic.apiKey') ?? '';
    const model = this.config.get<string>('anthropic.model') ?? '';
    const baseUrl = this.config.get<string>('anthropic.baseUrl') ?? 'https://api.anthropic.com';
    const timeoutMs = this.config.get<number>('anthropic.timeoutMs') ?? 20000;

    // 本地化:非英文 locale 时,要求 name 字段用用户语言输出(其余字段/数值/结构不变)。
    const lang = (input.locale ?? '').trim().toLowerCase();
    const system =
      lang && !lang.startsWith('en')
        ? `${this.systemPrompt} Write the "name" field of every item in the user's language ` +
          `(BCP-47 code "${lang}"); keep all other fields, numeric values, units, and the exact ` +
          `JSON structure unchanged.`
        : this.systemPrompt;

    if (!apiKey) {
      // 未配置密钥:视为上游不可用,归一为可识别的失败(不泄露内部配置细节)
      this.logger.error('ANTHROPIC_API_KEY not configured');
      throw new AppException('NETWORK_ERROR');
    }

    const content: unknown[] = [];
    if (input.image) {
      content.push({
        type: 'image',
        source: {
          type: 'base64',
          media_type: input.image.mediaType,
          data: input.image.base64,
        },
      });
    }
    content.push({
      type: 'text',
      text: input.text
        ? `Analyze this meal description: ${input.text}`
        : 'Analyze the food in the image.',
    });

    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), timeoutMs);
    try {
      const res = await fetch(`${baseUrl}/v1/messages`, {
        method: 'POST',
        headers: {
          'content-type': 'application/json',
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: JSON.stringify({
          model,
          max_tokens: 1024,
          system,
          messages: [{ role: 'user', content }],
        }),
        signal: controller.signal,
      });

      if (!res.ok) {
        // 上游非 2xx:不回显其响应体(可能含敏感),仅记录状态码
        this.logger.warn(`anthropic upstream status=${res.status}`);
        throw new AppException(res.status >= 500 ? 'NETWORK_ERROR' : 'RECOGNIZE_FAILED');
      }

      const body = (await res.json()) as { content?: { type: string; text?: string }[] };
      const text = (body.content ?? [])
        .filter((b) => b.type === 'text' && typeof b.text === 'string')
        .map((b) => b.text as string)
        .join('')
        .trim();
      return { text, model };
    } catch (err) {
      if (err instanceof AppException) throw err;
      if (err instanceof Error && err.name === 'AbortError') {
        throw new AppException('TIMEOUT');
      }
      // fetch 抛错(DNS/连接)→ 上游不可用
      throw new AppException('NETWORK_ERROR');
    } finally {
      clearTimeout(timer);
    }
  }
}
