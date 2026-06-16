import { useContext } from 'react';
import { AuthContext } from './auth-context';

/** 取鉴权上下文(分离自组件文件,满足 react-refresh 仅导出组件约束)。 */
export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth must be used within AuthProvider');
  return ctx;
}
