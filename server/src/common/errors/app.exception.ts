import { HttpException } from '@nestjs/common';
import { ERROR_CATALOG, ErrorKey } from './error-codes';

/**
 * 业务异常:以错误码 key 抛出,由全局过滤器统一渲染 { statusCode, code, messageKey, traceId }。
 * 绝不携带堆栈或敏感信息(§5)。details 仅用于字段级校验信息,须脱敏。
 */
export class AppException extends HttpException {
  readonly errorKey: ErrorKey;
  readonly details: unknown;

  constructor(errorKey: ErrorKey, details: unknown = null) {
    const descriptor = ERROR_CATALOG[errorKey];
    super(descriptor.messageKey, descriptor.status);
    this.errorKey = errorKey;
    this.details = details;
  }
}
