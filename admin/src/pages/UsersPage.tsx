import { useCallback, useEffect, useState } from 'react';
import {
  Button,
  Card,
  Input,
  Popconfirm,
  Space,
  Table,
  Tag,
  Typography,
  App as AntApp,
} from 'antd';
import type { ColumnsType } from 'antd/es/table';
import { useTranslation } from 'react-i18next';
import { useNavigate } from 'react-router-dom';
import { api } from '../api/client';
import { toMessage } from '../api/error-message';
import type { AccountStatus, AdminUserRow } from '../api/types';

const PAGE_SIZE = 20;

export function UsersPage(): React.JSX.Element {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const { message } = AntApp.useApp();

  const [rows, setRows] = useState<AdminUserRow[]>([]);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(1);
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(false);

  const load = useCallback(
    async (nextPage: number, term: string): Promise<void> => {
      setLoading(true);
      try {
        const res = await api.listUsers({ page: nextPage, pageSize: PAGE_SIZE, search: term });
        setRows(res.items);
        setTotal(res.total);
        setPage(res.page);
      } catch (err) {
        message.error(toMessage(t, err));
      } finally {
        setLoading(false);
      }
    },
    [t, message],
  );

  useEffect(() => {
    void load(1, '');
  }, [load]);

  const onSearch = (value: string): void => {
    const term = value.trim();
    setSearch(term);
    void load(1, term);
  };

  const setStatus = async (id: string, status: AccountStatus): Promise<void> => {
    try {
      await api.updateUserStatus(id, status);
      message.success(t(status === 'BANNED' ? 'admin.users.banned' : 'admin.users.unbanned'));
      void load(page, search);
    } catch (err) {
      message.error(toMessage(t, err));
    }
  };

  const columns: ColumnsType<AdminUserRow> = [
    { title: t('admin.users.colUsername'), dataIndex: 'username', key: 'username' },
    {
      title: t('admin.users.colEmail'),
      dataIndex: 'emailMasked',
      key: 'emailMasked',
      render: (v: string | null) => v ?? t('admin.users.noEmail'),
    },
    { title: t('admin.users.colRole'), dataIndex: 'role', key: 'role' },
    { title: t('admin.users.colPlan'), dataIndex: 'plan', key: 'plan' },
    {
      title: t('admin.users.colStatus'),
      dataIndex: 'status',
      key: 'status',
      render: (s: AccountStatus) => (
        <Tag color={s === 'ACTIVE' ? 'green' : 'red'}>{t(`admin.status.${s}`)}</Tag>
      ),
    },
    {
      title: t('admin.users.colCreatedAt'),
      dataIndex: 'createdAt',
      key: 'createdAt',
      render: (v: string) => new Date(v).toLocaleString(),
    },
    {
      title: t('admin.users.colActions'),
      key: 'actions',
      render: (_: unknown, row: AdminUserRow) => (
        <Space>
          <Button size="small" onClick={() => navigate(`/users/${row.id}`)}>
            {t('admin.users.view')}
          </Button>
          {/* 不可对 ADMIN 操作封禁(后端亦拒绝);仅对普通用户展示封禁/解封 */}
          {row.role !== 'ADMIN' &&
            (row.status === 'ACTIVE' ? (
              <Popconfirm
                title={t('admin.users.banConfirm')}
                okText={t('common.confirm')}
                cancelText={t('common.cancel')}
                onConfirm={() => void setStatus(row.id, 'BANNED')}
              >
                <Button size="small" danger>
                  {t('admin.users.ban')}
                </Button>
              </Popconfirm>
            ) : (
              <Popconfirm
                title={t('admin.users.unbanConfirm')}
                okText={t('common.confirm')}
                cancelText={t('common.cancel')}
                onConfirm={() => void setStatus(row.id, 'ACTIVE')}
              >
                <Button size="small">{t('admin.users.unban')}</Button>
              </Popconfirm>
            ))}
        </Space>
      ),
    },
  ];

  return (
    <Card>
      <Typography.Title level={4}>{t('admin.users.title')}</Typography.Title>
      <Input.Search
        allowClear
        placeholder={t('admin.users.searchPlaceholder')}
        onSearch={onSearch}
        style={{ maxWidth: 360, marginBottom: 16 }}
      />
      <Table<AdminUserRow>
        rowKey="id"
        loading={loading}
        columns={columns}
        dataSource={rows}
        locale={{ emptyText: t('common.empty') }}
        pagination={{
          current: page,
          pageSize: PAGE_SIZE,
          total,
          showSizeChanger: false,
          onChange: (p) => void load(p, search),
        }}
      />
    </Card>
  );
}
