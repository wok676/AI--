import { IsEnum, IsInt, IsOptional, IsString, MaxLength, Min, Max } from 'class-validator';
import { Type } from 'class-transformer';
import { AccountStatus } from '../../../common/domain/enums';

/**
 * 管理后台 · 用户列表查询入参(API.md §3 A · GET /admin/users)。
 * 仅分页 + 搜索 + 状态筛选;whitelist + forbidNonWhitelisted 拒绝多余字段(§6)。
 */
export class ListUsersQueryDto {
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(10000)
  page?: number;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  pageSize?: number;

  /** 模糊搜索:仅匹配用户名/邮箱前缀(脱敏比对,不暴露明细)。 */
  @IsOptional()
  @IsString()
  @MaxLength(120)
  search?: string;

  @IsOptional()
  @IsEnum(AccountStatus)
  status?: AccountStatus;
}

/**
 * 管理后台 · 封禁/解封用户(API.md §3 A · PATCH /admin/users/:id)。
 * 仅允许切换 status,且仅 ACTIVE/BANNED 两态(注销是物理删除,不在此列,DB §1)。
 */
export class UpdateUserStatusDto {
  @IsEnum(AccountStatus)
  status!: AccountStatus;
}

/**
 * 脱敏聚合统计查询(GET /admin/stats)。趋势天数受控,默认 7,最多 30。
 */
export class StatsQueryDto {
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(30)
  days?: number;
}
