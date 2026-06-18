/**
 * 集中读取环境变量(零硬编码密钥 §1.4 / §6)。所有密钥走 .env,仓库只提交 .env.example。
 */
export interface AppConfig {
  nodeEnv: string;
  port: number;
  databaseUrl: string;
  jwt: {
    accessSecret: string;
    accessTtl: string;
  };
  refreshTokenTtlDays: number;
  corsOrigins: string[];
  throttle: {
    ttlSeconds: number;
    limit: number;
  };
  defaultLocale: string;
  apple: {
    audience: string;
    issuer: string;
  };
  recognitionDailyLimit: number;
  anthropic: {
    apiKey: string;
    model: string;
    baseUrl: string;
    timeoutMs: number;
    maxImageBytes: number;
  };
}

const parseList = (value: string | undefined): string[] =>
  (value ?? '')
    .split(',')
    .map((s) => s.trim())
    .filter(Boolean);

export default (): AppConfig => ({
  nodeEnv: process.env.NODE_ENV ?? 'development',
  port: parseInt(process.env.PORT ?? '3000', 10),
  databaseUrl: process.env.DATABASE_URL ?? '',
  jwt: {
    // 开发兜底密钥仅用于本地;生产必须经 .env 注入强随机值,启动校验见 main.ts
    accessSecret: process.env.JWT_ACCESS_SECRET ?? 'dev-only-insecure-secret-change-me',
    accessTtl: process.env.JWT_ACCESS_TTL ?? '15m',
  },
  refreshTokenTtlDays: parseInt(process.env.REFRESH_TOKEN_TTL_DAYS ?? '30', 10),
  corsOrigins: parseList(process.env.CORS_ORIGINS),
  throttle: {
    ttlSeconds: parseInt(process.env.THROTTLE_TTL_SECONDS ?? '60', 10),
    limit: parseInt(process.env.THROTTLE_LIMIT ?? '120', 10),
  },
  defaultLocale: process.env.DEFAULT_LOCALE ?? 'en',
  apple: {
    audience: process.env.APPLE_AUDIENCE ?? '',
    issuer: process.env.APPLE_ISSUER ?? 'https://appleid.apple.com',
  },
  recognitionDailyLimit: parseInt(process.env.RECOGNITION_DAILY_LIMIT ?? '30', 10),
  anthropic: {
    // 密钥仅在服务端读取,绝不下发客户端;零硬编码(§1.4 / §6),走 .env
    apiKey: process.env.ANTHROPIC_API_KEY ?? '',
    // 默认用最新 Claude 模型(claude-opus-4-8,最强且现役);可经 .env 覆盖。
    // 注意:初代 claude-opus-4-20250514 已于 2026-06-15 退役,勿再使用。
    model: process.env.ANTHROPIC_MODEL ?? 'claude-opus-4-8',
    baseUrl: process.env.ANTHROPIC_BASE_URL ?? 'https://api.anthropic.com',
    timeoutMs: parseInt(process.env.ANTHROPIC_TIMEOUT_MS ?? '20000', 10),
    // 原图大小上限(API.md §4.10 ≤8MB)
    maxImageBytes: parseInt(process.env.RECOGNITION_MAX_IMAGE_BYTES ?? '8388608', 10),
  },
});
