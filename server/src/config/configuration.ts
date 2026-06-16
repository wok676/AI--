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
});
