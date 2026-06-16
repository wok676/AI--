/**
 * 错误码 ↔ messageKey ↔ HTTP 对照(API.md §0.3 强耦合点①)。
 * messageKey 必须存在于 locales/*.json(12 个 locale,en 基准)。
 * 全局异常过滤器据此渲染统一错误响应 { statusCode, code, messageKey, traceId }。
 */
import { HttpStatus } from '@nestjs/common';

export const SUPPORTED_LOCALES = [
  'en',
  'zh',
  'hi',
  'es',
  'fr',
  'ar',
  'bn',
  'pt',
  'ru',
  'ur',
  'ja',
  'ko',
] as const;
export type SupportedLocale = (typeof SUPPORTED_LOCALES)[number];

export interface ErrorDescriptor {
  code: string;
  messageKey: string;
  status: HttpStatus;
}

export const ERROR_CATALOG = {
  VALIDATION_FAILED: {
    code: 'VALIDATION_FAILED',
    messageKey: 'common.error.generic',
    status: HttpStatus.BAD_REQUEST,
  },
  AUTH_INVALID_CREDENTIALS: {
    code: 'AUTH_INVALID_CREDENTIALS',
    messageKey: 'auth.error.invalidCredentials',
    status: HttpStatus.UNAUTHORIZED,
  },
  AUTH_UNAUTHORIZED: {
    code: 'AUTH_UNAUTHORIZED',
    messageKey: 'errors.unauthorized',
    status: HttpStatus.UNAUTHORIZED,
  },
  AUTH_FORBIDDEN: {
    code: 'AUTH_FORBIDDEN',
    messageKey: 'errors.forbidden',
    status: HttpStatus.FORBIDDEN,
  },
  AUTH_CONSENT_REQUIRED: {
    code: 'AUTH_CONSENT_REQUIRED',
    messageKey: 'auth.consent.required',
    status: HttpStatus.BAD_REQUEST,
  },
  AUTH_EMAIL_TAKEN: {
    // 措辞归一为「邮箱无效」,不暴露已注册存在性(API.md §0.3)
    code: 'AUTH_EMAIL_TAKEN',
    messageKey: 'auth.email.invalid',
    status: HttpStatus.CONFLICT,
  },
  AUTH_WEAK_PASSWORD: {
    code: 'AUTH_WEAK_PASSWORD',
    messageKey: 'auth.password.weak',
    status: HttpStatus.BAD_REQUEST,
  },
  AUTH_EMAIL_INVALID: {
    code: 'AUTH_EMAIL_INVALID',
    messageKey: 'auth.email.invalid',
    status: HttpStatus.BAD_REQUEST,
  },
  RECOGNIZE_FAILED: {
    code: 'RECOGNIZE_FAILED',
    messageKey: 'recognize.error.failed',
    status: HttpStatus.UNPROCESSABLE_ENTITY,
  },
  RECOGNIZE_LIMIT_REACHED: {
    code: 'RECOGNIZE_LIMIT_REACHED',
    messageKey: 'recognize.limit.reached',
    status: HttpStatus.TOO_MANY_REQUESTS,
  },
  RESOURCE_NOT_FOUND: {
    // 横向越权归一为 404,不暴露资源是否存在(§6)
    code: 'RESOURCE_NOT_FOUND',
    messageKey: 'errors.notFound',
    status: HttpStatus.NOT_FOUND,
  },
  TIMEOUT: {
    code: 'TIMEOUT',
    messageKey: 'common.error.timeout',
    status: HttpStatus.GATEWAY_TIMEOUT,
  },
  NETWORK_ERROR: {
    code: 'NETWORK_ERROR',
    messageKey: 'common.error.network',
    status: HttpStatus.SERVICE_UNAVAILABLE,
  },
  INTERNAL_ERROR: {
    code: 'INTERNAL_ERROR',
    messageKey: 'common.error.generic',
    status: HttpStatus.INTERNAL_SERVER_ERROR,
  },
} as const satisfies Record<string, ErrorDescriptor>;

export type ErrorKey = keyof typeof ERROR_CATALOG;
