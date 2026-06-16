import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { I18nService } from '../i18n/i18n.service';
import { AppException } from '../errors/app.exception';
import { ERROR_CATALOG, ErrorDescriptor } from '../errors/error-codes';
import { generateTraceId } from '../trace/trace.util';

interface ErrorBody {
  statusCode: number;
  code: string;
  messageKey: string;
  traceId: string;
  details: unknown;
}

/**
 * 全局异常过滤器(§5):统一返回 { statusCode, code, messageKey, traceId, details }。
 * 绝不泄露堆栈;按 Accept-Language 渲染 messageKey、回退 en。
 * 日志只记录脱敏后的错误码 + traceId,不打印 PII/token/请求体。
 */
@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  private readonly logger = new Logger('Exception');

  constructor(private readonly i18n: I18nService) {}

  catch(exception: unknown, host: ArgumentsHost): void {
    const ctx = host.switchToHttp();
    const res = ctx.getResponse<Response>();
    const req = ctx.getRequest<Request>();

    const traceId = (req as Request & { traceId?: string }).traceId ?? generateTraceId();
    const locale = this.i18n.resolveLocale(req.headers['accept-language']);

    const { descriptor, details } = this.classify(exception);
    const messageKey = descriptor.messageKey;

    const body: ErrorBody = {
      statusCode: descriptor.status,
      code: descriptor.code,
      messageKey,
      traceId,
      // i18n 渲染后的可读消息放在 message 字段(便于网页端);前端仍以 messageKey 为准
      details,
    };

    // 5xx 记 error 级,4xx 记 warn 级;只记错误码与 traceId,绝不打印堆栈/请求体/PII
    const logLine = `code=${descriptor.code} status=${descriptor.status} traceId=${traceId} method=${req.method} path=${req.url}`;
    if (descriptor.status >= HttpStatus.INTERNAL_SERVER_ERROR) {
      this.logger.error(logLine);
    } else {
      this.logger.warn(logLine);
    }

    res.status(descriptor.status).json({
      ...body,
      message: this.i18n.translate(messageKey, locale),
    });
  }

  private classify(exception: unknown): { descriptor: ErrorDescriptor; details: unknown } {
    // 1) 业务异常:已携带 errorKey
    if (exception instanceof AppException) {
      return { descriptor: ERROR_CATALOG[exception.errorKey], details: exception.details };
    }

    // 2) NestJS HttpException(含 ValidationPipe 抛出的 400)
    if (exception instanceof HttpException) {
      const status = exception.getStatus();
      const response = exception.getResponse();
      // 校验失败 → VALIDATION_FAILED,字段级信息放 details(脱敏:仅约束名,不回显敏感值)
      if (status === HttpStatus.BAD_REQUEST) {
        const details = this.extractValidationDetails(response);
        return { descriptor: ERROR_CATALOG.VALIDATION_FAILED, details };
      }
      if (status === HttpStatus.UNAUTHORIZED) {
        return { descriptor: ERROR_CATALOG.AUTH_UNAUTHORIZED, details: null };
      }
      if (status === HttpStatus.FORBIDDEN) {
        return { descriptor: ERROR_CATALOG.AUTH_FORBIDDEN, details: null };
      }
      if (status === HttpStatus.NOT_FOUND) {
        return { descriptor: ERROR_CATALOG.RESOURCE_NOT_FOUND, details: null };
      }
      // 其余 HttpException 归一为内部错误,不外泄具体信息
      return { descriptor: ERROR_CATALOG.INTERNAL_ERROR, details: null };
    }

    // 3) 未知异常:一律兜底为 500,绝不外泄堆栈/原始 message(§5)
    return { descriptor: ERROR_CATALOG.INTERNAL_ERROR, details: null };
  }

  private extractValidationDetails(response: string | object): unknown {
    if (typeof response === 'object' && response !== null && 'message' in response) {
      const msg = (response as { message: unknown }).message;
      if (Array.isArray(msg)) {
        // class-validator 的字段约束信息(不含原始输入值)
        return { fields: msg };
      }
    }
    return null;
  }
}
