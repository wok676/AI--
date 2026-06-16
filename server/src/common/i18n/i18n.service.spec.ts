import { I18nService } from './i18n.service';
import { ERROR_CATALOG } from '../errors/error-codes';

/**
 * 验证:Accept-Language 解析、messageKey 渲染、回退 en、插值;
 * 且错误码目录中每个 messageKey 都能在语言包解析(强耦合点①)。
 */
describe('I18nService', () => {
  let i18n: I18nService;

  beforeAll(() => {
    i18n = new I18nService();
    i18n.onModuleInit(); // 加载 /locales/*.json
  });

  it('resolves Accept-Language to supported locale, else fallback en', () => {
    expect(i18n.resolveLocale('zh-CN,zh;q=0.9')).toBe('zh');
    expect(i18n.resolveLocale('ja')).toBe('ja');
    expect(i18n.resolveLocale('de-DE')).toBe('en'); // 不支持 → 回退 en
    expect(i18n.resolveLocale(undefined)).toBe('en');
  });

  it('renders messageKey per locale', () => {
    expect(i18n.translate('auth.error.invalidCredentials', 'en')).toBe(
      'Incorrect email or password',
    );
    expect(i18n.translate('auth.error.invalidCredentials', 'zh')).toBe('邮箱或密码错误');
  });

  it('interpolates {{vars}}', () => {
    expect(i18n.translate('summary.remaining', 'en', { kcal: 770 })).toBe('770 kcal left');
  });

  it('every error-catalog messageKey resolves in en (no missing keys)', () => {
    for (const descriptor of Object.values(ERROR_CATALOG)) {
      const rendered = i18n.translate(descriptor.messageKey, 'en');
      // 渲染结果不应等于 key 本身(等于即未命中)
      expect(rendered).not.toBe(descriptor.messageKey);
    }
  });
});
