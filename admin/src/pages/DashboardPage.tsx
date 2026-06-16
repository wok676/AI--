import { useCallback, useEffect, useState } from 'react';
import { Alert, Card, Col, Result, Row, Spin, Statistic, Table, Typography, Button } from 'antd';
import { useTranslation } from 'react-i18next';
import { api } from '../api/client';
import { toMessage } from '../api/error-message';
import type { AdminStatsDto, RecognitionTrendPoint } from '../api/types';

const TREND_DAYS = 7;

export function DashboardPage(): React.JSX.Element {
  const { t } = useTranslation();
  const [data, setData] = useState<AdminStatsDto | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(async (): Promise<void> => {
    setLoading(true);
    setError(null);
    try {
      setData(await api.getStats(TREND_DAYS));
    } catch (err) {
      setError(toMessage(t, err));
    } finally {
      setLoading(false);
    }
  }, [t]);

  useEffect(() => {
    void load();
  }, [load]);

  // 三态:加载
  if (loading) {
    return (
      <div style={{ textAlign: 'center', padding: 64 }}>
        <Spin tip={t('common.loading')} />
      </div>
    );
  }
  // 三态:错误
  if (error) {
    return (
      <Result
        status="warning"
        title={error}
        extra={
          <Button type="primary" onClick={() => void load()}>
            {t('common.retry')}
          </Button>
        }
      />
    );
  }
  // 三态:空(理论上 stats 恒有结构,这里兜底)
  if (!data) return <Alert type="info" message={t('common.empty')} />;

  const trendColumns = [
    { title: t('admin.dashboard.trendDate'), dataIndex: 'date', key: 'date' },
    { title: t('admin.dashboard.trendTotal'), dataIndex: 'total', key: 'total' },
    { title: t('admin.dashboard.trendSuccess'), dataIndex: 'success', key: 'success' },
    { title: t('admin.dashboard.trendFailed'), dataIndex: 'failed', key: 'failed' },
  ];

  return (
    <div>
      <Typography.Title level={4}>{t('admin.dashboard.title')}</Typography.Title>
      <Alert
        type="info"
        showIcon
        style={{ marginBottom: 16 }}
        message={t('admin.dashboard.privacyNote')}
      />
      <Row gutter={[16, 16]}>
        <Col xs={12} md={6}>
          <Card>
            <Statistic title={t('admin.dashboard.totalUsers')} value={data.totalUsers} />
          </Card>
        </Col>
        <Col xs={12} md={6}>
          <Card>
            <Statistic title={t('admin.dashboard.activeUsers')} value={data.activeUsers} />
          </Card>
        </Col>
        <Col xs={12} md={6}>
          <Card>
            <Statistic title={t('admin.dashboard.bannedUsers')} value={data.bannedUsers} />
          </Card>
        </Col>
        <Col xs={12} md={6}>
          <Card>
            <Statistic title={t('admin.dashboard.newUsersToday')} value={data.newUsersToday} />
          </Card>
        </Col>
        <Col xs={12} md={6}>
          <Card>
            <Statistic
              title={t('admin.dashboard.recognitionTotal')}
              value={data.recognitionTotal}
            />
          </Card>
        </Col>
        <Col xs={12} md={6}>
          <Card>
            <Statistic
              title={t('admin.dashboard.recognitionSuccess')}
              value={data.recognitionSuccess}
            />
          </Card>
        </Col>
        <Col xs={12} md={6}>
          <Card>
            <Statistic
              title={t('admin.dashboard.failureRate')}
              value={Math.round(data.recognitionFailureRate * 100)}
              suffix="%"
            />
          </Card>
        </Col>
      </Row>

      <Card style={{ marginTop: 16 }} title={t('admin.dashboard.trendTitle', { days: TREND_DAYS })}>
        <Table<RecognitionTrendPoint>
          rowKey="date"
          size="small"
          pagination={false}
          columns={trendColumns}
          dataSource={data.recognitionTrend}
          locale={{ emptyText: t('common.empty') }}
        />
      </Card>
    </div>
  );
}
