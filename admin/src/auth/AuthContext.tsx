import { useCallback, useMemo, useState, type ReactNode } from 'react';
import { api, ApiClientError } from '../api/client';
import { sessionStore } from './session-store';
import type { AuthUser } from '../api/types';
import { AuthContext, type AuthContextValue } from './auth-context';

export function AuthProvider({ children }: { children: ReactNode }): React.JSX.Element {
  // 初始 user 取自 sessionStore(刷新页面后恢复角色判断);accessToken 在内存,需靠 refresh 重建。
  const [user, setUser] = useState<AuthUser | null>(() => sessionStore.getUser());

  const login = useCallback(async (email: string, password: string) => {
    const session = await api.login(email, password);
    // 前端纵向校验:仅 ADMIN 可进管理后台(后端端点亦 @Roles(ADMIN) 双保险)
    if (session.user.role !== 'ADMIN') {
      sessionStore.clear();
      throw new ApiClientError('admin.login.notAdmin', 'AUTH_FORBIDDEN', 403);
    }
    sessionStore.save(session);
    setUser(session.user);
  }, []);

  const logout = useCallback(async () => {
    await api.logout();
    setUser(null);
  }, []);

  const value = useMemo<AuthContextValue>(() => ({ user, login, logout }), [user, login, logout]);

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}
