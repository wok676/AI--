import { RecognitionService } from './recognition.service';
import { ClaudeClient } from './claude.client';
import { AppException } from '../../common/errors/app.exception';
import { RecognitionSource, Role } from '../../common/domain/enums';
import { CurrentUserContext } from '../../common/auth/auth.types';

/**
 * 单元测试:识别解析/降级 + 限流 + 原图最小化 + 审计(Claude 全程 mock,不打真实 API)。
 * 对照 API.md §4.10 + PRD §4.7(原图不落库)+ F10(限流)。
 */
describe('RecognitionService (parse / limit / image-minimization, Claude mocked)', () => {
  const user: CurrentUserContext = { id: 'u1', role: Role.USER };

  // 可控的内存 usage 计数(模拟 RecognitionUsage @@unique(ownerId,localDate) 原子计数)
  let usageCount: number;
  let auditWrites: Array<Record<string, unknown>>;

  const makeService = (
    claudeBehavior: () => Promise<{ text: string; model: string }>,
    limit = 30,
  ): RecognitionService => {
    usageCount = 0;
    auditWrites = [];

    // 极简事务/prisma 桩:仅实现 service 用到的方法
    const tx = {
      recognitionUsage: {
        findUnique: async () => (usageCount > 0 ? { count: usageCount } : null),
        create: async () => {
          usageCount = 1;
          return {};
        },
        updateMany: async () => {
          if (usageCount < limit) {
            usageCount += 1;
            return { count: 1 };
          }
          return { count: 0 };
        },
      },
    };
    const prisma = {
      $transaction: async (fn: (t: typeof tx) => Promise<void>) => fn(tx),
      recognitionAudit: {
        create: async ({ data }: { data: Record<string, unknown> }) => {
          auditWrites.push(data);
          return {};
        },
      },
    };
    const config = {
      get: (key: string): unknown =>
        ({ recognitionDailyLimit: limit, 'anthropic.maxImageBytes': 8 * 1024 * 1024 })[key],
    };
    const claude = { analyze: claudeBehavior } as unknown as ClaudeClient;
    return new RecognitionService(prisma as never, config as never, claude);
  };

  const okClaude = (items: unknown) => async () => ({
    text: JSON.stringify({ items }),
    model: 'claude-test',
  });

  it('parses valid JSON into normalized items (protein→proteinG mapping, clamps)', async () => {
    const svc = makeService(
      okClaude([
        {
          name: 'Beef noodles',
          quantity: 1,
          unit: 'serving',
          kcal: 520,
          protein: 22,
          carbs: 68,
          fat: 16,
          confidence: 0.82,
        },
      ]),
    );
    const res = await svc.recognize(user, { source: RecognitionSource.TEXT, text: 'beef noodles' });
    expect(res.items).toHaveLength(1);
    expect(res.items[0]).toMatchObject({
      name: 'Beef noodles',
      proteinG: 22,
      carbsG: 68,
      fatG: 16,
      kcal: 520,
      confidence: 0.82,
    });
    expect(res.disclaimerKey).toBe('recognize.disclaimer');
    // 审计成功落库(脱敏:无原图/原文)
    expect(auditWrites).toHaveLength(1);
    expect(auditWrites[0]).toMatchObject({ success: true, source: RecognitionSource.TEXT });
    expect(JSON.stringify(auditWrites[0])).not.toContain('beef noodles');
  });

  it('tolerates code-fenced JSON and strips surrounding prose', async () => {
    const svc = makeService(async () => ({
      text: 'Here you go:\n```json\n{"items":[{"name":"Apple","kcal":95}]}\n```',
      model: 'claude-test',
    }));
    const res = await svc.recognize(user, { source: RecognitionSource.TEXT, text: 'apple' });
    expect(res.items[0].name).toBe('Apple');
    expect(res.items[0].unit).toBe('serving'); // default
  });

  it('empty items → RECOGNIZE_FAILED (degrade, no crash) + audit failure', async () => {
    const svc = makeService(okClaude([]));
    await expect(
      svc.recognize(user, { source: RecognitionSource.TEXT, text: '???' }),
    ).rejects.toMatchObject({ errorKey: 'RECOGNIZE_FAILED' });
    expect(auditWrites[0]).toMatchObject({ success: false, errorCode: 'RECOGNIZE_FAILED' });
  });

  it('malformed (non-JSON) model output → RECOGNIZE_FAILED', async () => {
    const svc = makeService(async () => ({ text: 'sorry I cannot help', model: 'claude-test' }));
    await expect(
      svc.recognize(user, { source: RecognitionSource.TEXT, text: 'x' }),
    ).rejects.toMatchObject({ errorKey: 'RECOGNIZE_FAILED' });
  });

  it('upstream TIMEOUT propagates (not swallowed) + audit records errorCode', async () => {
    const svc = makeService(async () => {
      throw new AppException('TIMEOUT');
    });
    await expect(
      svc.recognize(user, { source: RecognitionSource.PHOTO, text: undefined }),
    ).rejects.toMatchObject({ errorKey: 'TIMEOUT' });
    expect(auditWrites[0]).toMatchObject({ success: false, errorCode: 'TIMEOUT' });
  });

  it('daily limit: 31st call within same localDate → RECOGNIZE_LIMIT_REACHED (429)', async () => {
    const svc = makeService(okClaude([{ name: 'Egg', kcal: 90 }]), 30);
    for (let i = 0; i < 30; i++) {
      await svc.recognize(user, {
        source: RecognitionSource.TEXT,
        text: 'egg',
        localDate: '2026-06-16',
      });
    }
    await expect(
      svc.recognize(user, { source: RecognitionSource.TEXT, text: 'egg', localDate: '2026-06-16' }),
    ).rejects.toMatchObject({ errorKey: 'RECOGNIZE_LIMIT_REACHED' });
  });

  it('image minimization: original buffer is zeroed after processing (not retained)', async () => {
    const svc = makeService(okClaude([{ name: 'Pizza', kcal: 800 }]));
    const buffer = Buffer.from('FAKE_IMAGE_BYTES');
    const input = {
      source: RecognitionSource.PHOTO,
      image: { buffer, mediaType: 'image/jpeg' },
      localDate: '2026-06-16',
    };
    await svc.recognize(user, input);
    // 处理后原图 buffer 被清空(最小化留存 §4.7);响应不含任何原图字段
    expect(input.image.buffer.length).toBe(0);
  });

  it('oversized image → RECOGNIZE_FAILED and buffer zeroed (never sent / stored)', async () => {
    const svc = makeService(okClaude([{ name: 'X', kcal: 1 }]));
    const big = Buffer.alloc(9 * 1024 * 1024, 1); // > 8MB
    const input = {
      source: RecognitionSource.PHOTO,
      image: { buffer: big, mediaType: 'image/jpeg' },
      localDate: '2026-06-16',
    };
    await expect(svc.recognize(user, input)).rejects.toMatchObject({
      errorKey: 'RECOGNIZE_FAILED',
    });
    expect(input.image.buffer.length).toBe(0);
  });
});
