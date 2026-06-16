import { useCallback, useEffect, useState } from 'react';
import { Alert, Button, Card, Descriptions, Result, Space, Spin, Tag, Typography } from 'antd';
import { useTranslation } from 'react-i18next';
import { useNavigate, useParams } from 'react-router-dom';
import { api } from '../api/client';
import { toMessage } from '../api/error-message';
import type { AdminUserDetailDto } from '../api/types';

export function UserDetailPage(): React.JSX.Element {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const { id = '' } = useParams();

  const [data, setData] = useState<AdminUserDetailDto | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(async (): Promise<void> => {
    setLoading(true);
    setError(null);
    try {
      setData(await api.getUser(id));
    } catch (err) {
      setError(toMessage(t, err));
    } finally {
      setLoading(false);
    }
  }, [id, t]);

  useEffect(() => {
    void load();
  }, [load]);

  if (loading) {
    return (
      <div style={{ textAlign: 'center', padding: 64 }}>
        <Spin tip={t('common.loading')} />
      </div>
    );
  }
  if (error || !data) {
    return (
      <Result
        status="warning"
        title={error ?? t('common.empty')}
        extra={
          <Space>
            <Button onClick={() => navigate('/users')}>{t('admin.detail.back')}</Button>
            <Button type="primary" onClick={() => void load()}>
              {t('common.retry')}
            </Button>
          </Space>
        }
      />
    );
  }

  return (
    <Card
      title={
        <Space>
          <Button onClick={() => navigate('/users')}>{t('admin.detail.back')}</Button>
          <Typography.Text strong>{t('admin.detail.title')}</Typography.Text>
        </Space>
      }
    >
      <Alert
        type="info"
        showIcon
        style={{ marginBottom: 16 }}
        message={t('admin.detail.privacyNote')}
      />

      <Descriptions title={t('admin.detail.account')} bordered column={2} size="small">
        <Descriptions.Item label="ID">{data.id}</Descriptions.Item>
        <Descriptions.Item label={t('admin.users.colUsername')}>{data.username}</Descriptions.Item>
        <Descriptions.Item label={t('admin.users.colEmail')}>
          {data.emailMasked ?? t('admin.users.noEmail')}
        </Descriptions.Item>
        <Descriptions.Item label={t('admin.users.colRole')}>{data.role}</Descriptions.Item>
        <Descriptions.Item label={t('admin.users.colPlan')}>{data.plan}</Descriptions.Item>
        <Descriptions.Item label={t('admin.users.colStatus')}>
          <Tag color={data.status === 'ACTIVE' ? 'green' : 'red'}>
            {t(`admin.status.${data.status}`)}
          </Tag>
        </Descriptions.Item>
        <Descriptions.Item label={t('admin.detail.locale')}>{data.locale}</Descriptions.Item>
        <Descriptions.Item label={t('admin.detail.notifyEnabled')}>
          {String(data.notifyEnabled)}
        </Descriptions.Item>
        <Descriptions.Item label={t('admin.detail.consentVersion')}>
          {data.consentVersion ?? '-'}
        </Descriptions.Item>
        <Descriptions.Item label={t('admin.detail.consentAcceptedAt')}>
          {data.consentAcceptedAt ? new Date(data.consentAcceptedAt).toLocaleString() : '-'}
        </Descriptions.Item>
        <Descriptions.Item label={t('admin.detail.createdAt')}>
          {new Date(data.createdAt).toLocaleString()}
        </Descriptions.Item>
        <Descriptions.Item label={t('admin.detail.updatedAt')}>
          {new Date(data.updatedAt).toLocaleString()}
        </Descriptions.Item>
      </Descriptions>

      <Descriptions
        title={t('admin.detail.activity')}
        bordered
        column={2}
        size="small"
        style={{ marginTop: 16 }}
      >
        <Descriptions.Item label={t('admin.detail.mealEntryCount')}>
          {data.mealEntryCount}
        </Descriptions.Item>
        <Descriptions.Item label={t('admin.detail.recognitionUsageTotal')}>
          {data.recognitionUsageTotal}
        </Descriptions.Item>
        <Descriptions.Item label={t('admin.detail.authProviders')}>
          {data.authProviders.join(', ') || '-'}
        </Descriptions.Item>
      </Descriptions>
    </Card>
  );
}
