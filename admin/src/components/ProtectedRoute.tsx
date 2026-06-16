import type { ReactNode } from 'react';
import { Navigate } from 'react-router-dom';
import { useAuth } from '../auth/use-auth';

/**
 * 路由守卫:未登录(无 user)→ 重定向登录页。
 * 仅 ADMIN 能进登录(AuthContext.login 已校验 role);此处再做最后一道 UI 防线。
 * 真正的鉴权由后端 @Roles(ADMIN) 强制,前端守卫只控制可见性。
 */
export function ProtectedRoute({ children }: { children: ReactNode }): React.JSX.Element {
  const { user } = useAuth();
  if (!user || user.role !== 'ADMIN') {
    return <Navigate to="/login" replace />;
  }
  return <>{children}</>;
}
