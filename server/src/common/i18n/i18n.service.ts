import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { readFileSync } from 'fs';
import { join } from 'path';
import { SUPPORTED_LOCALES, SupportedLocale } from '../errors/error-codes';

type LocaleBundle = Record<string, unknown>;

/**
 * 后端 i18n:加载仓库根 /locales/*.json(前后端共享 key,§7)。
 * 报错 messageKey 按 Accept-Language 渲染,回退 en。支持 {{var}} 插值。
 * 找不到 key 时回退英文,再退回 key 本身(绝不抛错导致崩溃)。
 */
@Injectable()
export class I18nService implements OnModuleInit {
  private readonly logger = new Logger(I18nService.name);
  private readonly bundles = new Map<SupportedLocale, LocaleBundle>();
  private readonly fallback: SupportedLocale = 'en';

  onModuleInit(): void {
    // 从 server/ 往上一级定位仓库根的 locales 目录
    const localesDir = join(__dirname, '..', '..', '..', '..', 'locales');
    for (const locale of SUPPORTED_LOCALES) {
      try {
        const raw = readFileSync(join(localesDir, `${locale}.json`), 'utf8');
        this.bundles.set(locale, JSON.parse(raw) as LocaleBundle);
      } catch (err) {
        // 缺失语言包不致命:记录后跳过,运行时回退 en
        this.logger.warn(`locale bundle missing or invalid: ${locale} (${String(err)})`);
      }
    }
    if (!this.bundles.has(this.fallback)) {
      this.logger.error('fallback locale "en" bundle is missing; messageKeys will not resolve');
    }
  }

  /**
   * 把 Accept-Language 头解析为受支持 locale,否则回退 en。
   */
  resolveLocale(acceptLanguage?: string): SupportedLocale {
    if (!acceptLanguage) return this.fallback;
    const candidates = acceptLanguage
      .split(',')
      .map((part) => part.split(';')[0].trim().toLowerCase())
      .map((tag) => tag.split('-')[0]);
    for (const c of candidates) {
      if ((SUPPORTED_LOCALES as readonly string[]).includes(c)) {
        return c as SupportedLocale;
      }
    }
    return this.fallback;
  }

  /**
   * 渲染 messageKey。命中顺序:目标 locale → en → key 本身。
   */
  translate(
    key: string,
    locale: SupportedLocale = this.fallback,
    vars: Record<string, string | number> = {},
  ): string {
    const fromTarget = this.lookup(key, locale);
    const value = fromTarget ?? this.lookup(key, this.fallback) ?? key;
    return this.interpolate(value, vars);
  }

  private lookup(key: string, locale: SupportedLocale): string | undefined {
    const bundle = this.bundles.get(locale);
    if (!bundle) return undefined;
    const segments = key.split('.');
    let node: unknown = bundle;
    for (const seg of segments) {
      if (typeof node !== 'object' || node === null) return undefined;
      node = (node as Record<string, unknown>)[seg];
    }
    return typeof node === 'string' ? node : undefined;
  }

  private interpolate(template: string, vars: Record<string, string | number>): string {
    return template.replace(/\{\{\s*(\w+)\s*\}\}/g, (match, name: string) =>
      name in vars ? String(vars[name]) : match,
    );
  }
}
