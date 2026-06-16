import i18n from '../i18n';
import { sessionStore } from '../auth/session-store';
import type {
  AdminStatsDto,
  AdminUserDetailDto,
  AdminUserListDto,
  ApiError,
  AuthSession,
  ListUsersParams,
  AccountStatus,
} from './types';

// 基址:生产用 VITE_API_BASE_URL(公网 HTTPS);开发留空走 vite 代理 /api/v1。
const BASE = (import.meta.env.VITE_API_BASE_URL ?? '').replace(/\/$/, '') || '/api/v1';

/** 客户端侧错误:携带后端 messageKey 供 i18n 渲染(API.md §0.2)。 */
export class ApiClientError extends Error {
  constructor(
    readonly messageKey: string,
    readonly code: string,
    readonly statusCode: number,
  ) {
    super(messageKey);
    this.name = 'ApiClientError';
  }
}

function toClientError(status: number, body: unknown): ApiClientError {
  const e = body as Partial<ApiError> | null;
  // 后端统一错误结构;缺失则回退通用文案 key
  return new ApiClientError(
    e?.messageKey ?? 'common.error.generic',
    e?.code ?? 'INTERNAL_ERROR',
    e?.statusCode ?? status,
  );
}

let refreshing: Promise<boolean> | null = null;

/** 用 refreshToken 静默换新 accessToken(API.md §4.4);失败返回 false(需重新登录)。 */
async function tryRefresh(): Promise<boolean> {
  const refreshToken = sessionStore.getRefreshToken();
  if (!refreshToken) return false;
  if (!refreshing) {
    refreshing = (async () => {
      try {
        const res = await fetch(`${BASE}/auth/refresh`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ refreshToken }),
        });
        if (!res.ok) return false;
        const session = (await res.json()) as AuthSession;
        sessionStore.save(session);
        return true;
      } catch {
        return false;
      } finally {
        refreshing = null;
      }
    })();
  }
  return refreshing;
}

interface RequestOptions {
  method?: string;
  body?: unknown;
  query?: Record<string, string | number | undefined>;
  // 内部重试标记,避免无限循环
  _retried?: boolean;
}

async function request<T>(path: string, opts: RequestOptions = {}): Promise<T> {
  const { method = 'GET', body, query } = opts;

  const url = new URL(`${BASE}${path}`, window.location.origin);
  if (query) {
    for (const [k, v] of Object.entries(query)) {
      if (v !== undefined && v !== '') url.searchParams.set(k, String(v));
    }
  }

  const headers: Record<string, string> = {
    'Accept-Language': i18n.language || 'en', // 后端按此渲染 messageKey(API.md §0)
  };
  const token = sessionStore.getAccessToken();
  if (token) headers.Authorization = `Bearer ${token}`;
  if (body !== undefined) headers['Content-Type'] = 'application/json';

  let res: Response;
  try {
    res = await fetch(url.toString().replace(window.location.origin, ''), {
      method,
      headers,
      body: body !== undefined ? JSON.stringify(body) : undefined,
    });
  } catch {
    // 断网/超时 → 转通用 i18n 文案,绝不抛裸异常(三态错误)
    throw new ApiClientError('common.error.network', 'NETWORK_ERROR', 0);
  }

  // 401:尝试刷新一次,成功则重放原请求
  if (res.status === 401 && !opts._retried) {
    const ok = await tryRefresh();
    if (ok) return request<T>(path, { ...opts, _retried: true });
    sessionStore.clear();
  }

  if (!res.ok) {
    let parsed: unknown = null;
    try {
      parsed = await res.json();
    } catch {
      /* 非 JSON 错误体,忽略 */
    }
    throw toClientError(res.status, parsed);
  }

  if (res.status === 204) return undefined as T;
  return (await res.json()) as T;
}

// ---------------- 端点封装(对接 docs/API.md)----------------

export const api = {
  /** 登录(API.md §4.2)。返回 JWT 结构;角色校验在调用方(仅 ADMIN 可进后台)。 */
  login(email: string, password: string): Promise<AuthSession> {
    return request<AuthSession>('/auth/login', { method: 'POST', body: { email, password } });
  },

  /** 登出(API.md §4.5):吊销 refreshToken。 */
  async logout(): Promise<void> {
    const refreshToken = sessionStore.getRefreshToken();
    if (refreshToken) {
      try {
        await request('/auth/logout', { method: 'POST', body: { refreshToken } });
      } catch {
        /* 登出失败也照常清本地凭证 */
      }
    }
    sessionStore.clear();
  },

  listUsers(params: ListUsersParams): Promise<AdminUserListDto> {
    return request<AdminUserListDto>('/admin/users', { query: { ...params } });
  },

  getUser(id: string): Promise<AdminUserDetailDto> {
    return request<AdminUserDetailDto>(`/admin/users/${encodeURIComponent(id)}`);
  },

  updateUserStatus(id: string, status: AccountStatus): Promise<AdminUserDetailDto> {
    return request<AdminUserDetailDto>(`/admin/users/${encodeURIComponent(id)}`, {
      method: 'PATCH',
      body: { status },
    });
  },

  getStats(days = 7): Promise<AdminStatsDto> {
    return request<AdminStatsDto>('/admin/stats', { query: { days } });
  },
};
