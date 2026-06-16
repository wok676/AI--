// 共享类型 — 与后端 DTO 逐字段对齐(强耦合点②,API.md §5)。
// 来源:server/src/modules/admin/dto/admin-response.dto.ts 与 auth 响应(API.md §1)。

export type Role = 'USER' | 'ADMIN';
export type Plan = 'FREE' | 'PRO';
export type AccountStatus = 'ACTIVE' | 'BANNED';

/** JWT 登录返回结构(API.md §1,不可改)。 */
export interface AuthUser {
  id: string;
  username: string;
  role: Role;
}

export interface AuthSession {
  accessToken: string;
  refreshToken: string;
  user: AuthUser;
}

/** 统一错误响应(API.md §0.2)。 */
export interface ApiError {
  statusCode: number;
  code: string;
  messageKey: string;
  traceId: string;
  details?: unknown;
}

/** 管理后台 · 用户列表行(脱敏,emailMasked 已打码)。 */
export interface AdminUserRow {
  id: string;
  username: string;
  emailMasked: string | null;
  role: Role;
  plan: Plan;
  status: AccountStatus;
  createdAt: string;
}

export interface AdminUserListDto {
  items: AdminUserRow[];
  total: number;
  page: number;
  pageSize: number;
}

export interface AdminUserDetailDto {
  id: string;
  username: string;
  emailMasked: string | null;
  role: Role;
  plan: Plan;
  status: AccountStatus;
  locale: string;
  notifyEnabled: boolean;
  consentAcceptedAt: string | null;
  consentVersion: string | null;
  createdAt: string;
  updatedAt: string;
  mealEntryCount: number;
  recognitionUsageTotal: number;
  authProviders: string[];
}

export interface RecognitionTrendPoint {
  date: string;
  total: number;
  success: number;
  failed: number;
}

export interface AdminStatsDto {
  totalUsers: number;
  activeUsers: number;
  bannedUsers: number;
  newUsersToday: number;
  recognitionTotal: number;
  recognitionSuccess: number;
  recognitionFailureRate: number;
  recognitionTrend: RecognitionTrendPoint[];
}

export interface ListUsersParams {
  page?: number;
  pageSize?: number;
  search?: string;
  status?: AccountStatus;
}
