import type { TFunction } from 'i18next';
import { ApiClientError } from './client';

/**
 * 把任意抛出物转为可展示的 i18n 文案。
 * 后端错误带 messageKey → 直接 t(messageKey);其它一律回退通用文案(不泄露内部细节)。
 */
export function toMessage(t: TFunction, err: unknown): string {
  if (err instanceof ApiClientError) {
    return t(err.messageKey, { defaultValue: t('common.error.generic') });
  }
  return t('common.error.generic');
}
