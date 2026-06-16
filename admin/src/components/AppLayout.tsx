import { Layout, Menu, Button, Typography, Space } from 'antd';
import { DashboardOutlined, TeamOutlined, LogoutOutlined } from '@ant-design/icons';
import { useTranslation } from 'react-i18next';
import { Outlet, useLocation, useNavigate } from 'react-router-dom';
import { useAuth } from '../auth/use-auth';
import { LanguageSwitcher } from './LanguageSwitcher';

const { Header, Sider, Content } = Layout;

export function AppLayout(): React.JSX.Element {
  const { t } = useTranslation();
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();

  const selectedKey = location.pathname.startsWith('/users') ? '/users' : '/';

  const onLogout = async (): Promise<void> => {
    await logout();
    navigate('/login', { replace: true });
  };

  return (
    <Layout style={{ minHeight: '100vh' }}>
      <Sider breakpoint="lg" collapsedWidth="0">
        <div style={{ color: '#fff', padding: 16, fontWeight: 600 }}>{t('common.appName')}</div>
        <Menu
          theme="dark"
          mode="inline"
          selectedKeys={[selectedKey]}
          onClick={({ key }) => navigate(key)}
          items={[
            { key: '/', icon: <DashboardOutlined />, label: t('admin.nav.dashboard') },
            { key: '/users', icon: <TeamOutlined />, label: t('admin.nav.users') },
          ]}
        />
      </Sider>
      <Layout>
        <Header
          style={{
            background: '#fff',
            display: 'flex',
            justifyContent: 'flex-end',
            alignItems: 'center',
            paddingInline: 16,
          }}
        >
          <Space size="middle">
            <LanguageSwitcher />
            <Typography.Text type="secondary">{user?.username}</Typography.Text>
            <Button icon={<LogoutOutlined />} onClick={onLogout}>
              {t('admin.nav.logout')}
            </Button>
          </Space>
        </Header>
        <Content style={{ margin: 16 }}>
          <Outlet />
        </Content>
      </Layout>
    </Layout>
  );
}
