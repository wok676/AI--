import { randomBytes } from 'crypto';

/**
 * 生成链路追踪 ID(API.md §0:每响应含 traceId,日志关联,不含 PII)。
 */
export function generateTraceId(): string {
  return `req_${randomBytes(12).toString('hex')}`;
}
