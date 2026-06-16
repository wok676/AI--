import { useState } from 'react';
import { Button, Card, Form, Input, Typography, App as AntApp } from 'antd';
import { useTranslation } from 'react-i18next';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../auth/use-auth';
import { toMessage } from '../api/error-message';
import { LanguageSwitcher } from '../components/LanguageSwitcher';

interface LoginForm {
  email: string;
  password: string;
}

export function LoginPage(): React.JSX.Element {
  const { t } = useTranslation();
  const { login } = useAuth();
  const navigate = useNavigate();
  const { message } = AntApp.useApp();
  const [loading, setLoading] = useState(false);

  const onFinish = async (values: LoginForm): Promise<void> => {
    setLoading(true);
    try {
      await login(values.email.trim().toLowerCase(), values.password);
      navigate('/', { replace: true });
    } catch (err) {
      // 三态错误:友好 i18n 提示,绝不暴露后端细节/堆栈
      message.error(toMessage(t, err));
    } finally {
      setLoading(false);
    }
  };

  return (
    <div
      style={{
        minHeight: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        background: '#f0f2f5',
      }}
    >
      <Card style={{ width: 380 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <Typography.Title level={3} style={{ margin: 0 }}>
            {t('admin.login.title')}
          </Typography.Title>
          <LanguageSwitcher />
        </div>
        <Typography.Paragraph type="secondary">{t('admin.login.subtitle')}</Typography.Paragraph>
        <Form<LoginForm> layout="vertical" onFinish={onFinish} disabled={loading}>
          <Form.Item
            name="email"
            label={t('admin.login.email')}
            rules={[{ required: true, type: 'email', message: t('auth.email.invalid') }]}
          >
            <Input autoComplete="username" placeholder="admin@example.com" />
          </Form.Item>
          <Form.Item
            name="password"
            label={t('admin.login.password')}
            rules={[{ required: true, message: t('auth.password.weak') }]}
          >
            <Input.Password autoComplete="current-password" />
          </Form.Item>
          <Button type="primary" htmlType="submit" block loading={loading}>
            {t('admin.login.submit')}
          </Button>
        </Form>
      </Card>
    </div>
  );
}
