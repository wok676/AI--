import { ActivityLevel, GoalType, Plan, Role, Sex } from '../../../common/domain/enums';

/**
 * GET/PATCH /me 响应(API.md §4.9)。逐字段对齐前端共享类型 app/lib/api/types.dart MeProfile。
 * 绝不含 passwordHash / refreshToken 等敏感字段(§6)。
 */
export interface MeProfileSubDto {
  sex: Sex;
  birthYear: number | null;
  heightCm: number | null;
  weightKg: number | null;
  activityLevel: ActivityLevel | null;
  goalType: GoalType | null;
}

export interface MeDto {
  id: string;
  email: string | null;
  username: string;
  role: Role;
  plan: Plan;
  avatarUrl: string | null;
  locale: string;
  unitEnergy: string;
  unitMass: string;
  notifyEnabled: boolean;
  profile: MeProfileSubDto;
}
