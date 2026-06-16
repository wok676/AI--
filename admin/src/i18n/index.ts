import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import LanguageDetector from 'i18next-browser-languagedetector';
import en from './locales/en';
import zh from './locales/zh';

// 管理后台 i18n:至少 en/zh(任务要求),跟随浏览器语言,回退 en。
void i18n
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    resources: {
      en: { translation: en },
      zh: { translation: zh },
    },
    fallbackLng: 'en',
    supportedLngs: ['en', 'zh'],
    nonExplicitSupportedLngs: true, // zh-CN -> zh
    interpolation: { escapeValue: false },
    detection: {
      order: ['localStorage', 'navigator'],
      caches: ['localStorage'], // 仅缓存语言偏好(非敏感)
      lookupLocalStorage: 'testai_admin_lng',
    },
  });

export default i18n;
