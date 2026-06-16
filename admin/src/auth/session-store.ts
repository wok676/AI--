import type { AuthSession, AuthUser } from '../api/types';

/**
 * 凭证存储策略(合规:不把长期凭证明文久存 localStorage)。
 *
 * - accessToken(15min JWT):仅内存,刷新页面即丢失 → 重新登录;最敏感、最短暴露窗口。
 * - refreshToken(30d 不透明):存 sessionStorage(随标签页关闭即清),不进 localStorage。
 *   sessionStorage 不跨标签页/不持久化磁盘会话,降低长期凭证泄露面;管理后台为内部工具,
 *   牺牲少量便利换安全(每次重开浏览器需重新登录)。
 * - user(非敏感展示信息):随 refreshToken 存 sessionStorage,便于刷新后恢复 UI 角色判断。
 *
 * 注:浏览器端无真正的安全飞地;此为 Web 管理后台的合理折中(对比 RN 端用 secure-store)。
 */

const REFRESH_KEY = 'testai_admin_rt';
const USER_KEY = 'testai_admin_user';

let accessToken: string | null = null;

export const sessionStore = {
  getAccessToken(): string | null {
    return accessToken;
  },

  getRefreshToken(): string | null {
    return sessionStorage.getItem(REFRESH_KEY);
  },

  getUser(): AuthUser | null {
    const raw = sessionStorage.getItem(USER_KEY);
    if (!raw) return null;
    try {
      return JSON.parse(raw) as AuthUser;
    } catch {
      return null;
    }
  },

  save(session: AuthSession): void {
    accessToken = session.accessToken;
    sessionStorage.setItem(REFRESH_KEY, session.refreshToken);
    sessionStorage.setItem(USER_KEY, JSON.stringify(session.user));
  },

  setAccessToken(token: string): void {
    accessToken = token;
  },

  clear(): void {
    accessToken = null;
    sessionStorage.removeItem(REFRESH_KEY);
    sessionStorage.removeItem(USER_KEY);
  },
};
