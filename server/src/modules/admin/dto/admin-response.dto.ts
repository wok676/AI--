import { AccountStatus, Plan, Role } from '../../../common/domain/enums';

/**
 * 管理后台响应 DTO(脱敏 · 最小可见原则,PRD §2.5/§2.6)。
 *
 * 严禁出现:passwordHash、餐食明细(MealEntry/FoodItem 内容)、食物原图/原图 URL、
 * 个人健康明细(身高/体重等 Profile 字段)、refreshToken、Apple sub 等可定位个人或越权的字段。
 * 这里只给「账号管理」所必需的最小字段集。
 */

/** 邮箱脱敏后的列表行(a***@b.com 形态;管理员可识别但不暴露完整邮箱)。 */
export interface AdminUserRow {
  id: string;
  username: string;
  emailMasked: string | null; // 脱敏邮箱,纯 Apple 无邮箱用户为 null
  role: Role;
  plan: Plan;
  status: AccountStatus;
  createdAt: string; // ISO 字符串
}

/** 用户列表分页响应(API.md §0.1 分页结构 { items, total, page, pageSize })。 */
export interface AdminUserListDto {
  items: AdminUserRow[];
  total: number;
  page: number;
  pageSize: number;
}

/**
 * 用户详情(脱敏聚合)。仅给计数级聚合,不返回任何餐食/食物明细或原图。
 * mealCount/goalCount 是行数统计,用于客服判断活跃度,不含任何内容。
 */
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
  // —— 脱敏聚合(仅计数,无任何内容明细)——
  mealEntryCount: number;
  recognitionUsageTotal: number; // 累计识别次数(成本/活跃参考)
  authProviders: string[]; // ['EMAIL','APPLE'] 仅渠道名,不含 providerUserId
}

/** 单日识别审计聚合点(去标识,源自 RecognitionAudit,DB §9)。 */
export interface RecognitionTrendPoint {
  date: string; // YYYY-MM-DD
  total: number;
  success: number;
  failed: number;
}

/**
 * 运营看板脱敏聚合(PRD §2.6:DAU/识别调用量/失败率等,均不含个人明细)。
 */
export interface AdminStatsDto {
  totalUsers: number;
  activeUsers: number; // status=ACTIVE
  bannedUsers: number;
  newUsersToday: number;
  // 识别审计聚合(全局,去标识)
  recognitionTotal: number;
  recognitionSuccess: number;
  recognitionFailureRate: number; // 0..1,保留两位
  recognitionTrend: RecognitionTrendPoint[]; // 近 N 天调用量趋势
}
