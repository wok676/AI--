import { Select } from 'antd';
import { useTranslation } from 'react-i18next';

// 语言切换(至少 en/zh)。即时生效;偏好缓存在 localStorage(非敏感)。
export function LanguageSwitcher(): React.JSX.Element {
  const { i18n } = useTranslation();
  const current = i18n.language?.startsWith('zh') ? 'zh' : 'en';
  return (
    <Select
      size="small"
      value={current}
      onChange={(lng) => void i18n.changeLanguage(lng)}
      options={[
        { value: 'en', label: 'English' },
        { value: 'zh', label: '中文' },
      ]}
      style={{ width: 96 }}
    />
  );
}
