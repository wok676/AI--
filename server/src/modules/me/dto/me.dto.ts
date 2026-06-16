import { Type } from 'class-transformer';
import {
  IsBoolean,
  IsEnum,
  IsIn,
  IsInt,
  IsNumber,
  IsOptional,
  IsString,
  Max,
  MaxLength,
  Min,
  MinLength,
  ValidateNested,
} from 'class-validator';
import { ActivityLevel, GoalType, Sex } from '../../../common/domain/enums';

/**
 * 个人资料子集(API.md §4.9 PATCH /me · profile)。
 * 仅本人热量估算所需字段(PRD §4.6);不收集疾病史等特殊健康数据。
 */
export class UpdateProfileDto {
  @IsOptional()
  @IsEnum(Sex)
  sex?: Sex;

  @IsOptional()
  @IsInt()
  @Min(1900)
  @Max(new Date().getFullYear())
  birthYear?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Max(300)
  heightCm?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Max(600)
  weightKg?: number;

  @IsOptional()
  @IsEnum(ActivityLevel)
  activityLevel?: ActivityLevel;

  @IsOptional()
  @IsEnum(GoalType)
  goalType?: GoalType;
}

/**
 * 更新当前用户(API.md §4.9 PATCH /me)。任意子集。
 *
 * 安全(§6 防 mass-assignment 纵向提权):
 *   本 DTO **刻意不包含** id / role / plan / status / email / passwordHash 等字段;
 *   配合全局 ValidationPipe(whitelist + forbidNonWhitelisted),
 *   客户端若尝试传 role/plan 等 → 直接 VALIDATION_FAILED(400),无法越权改角色/套餐。
 */
export class UpdateMeDto {
  @IsOptional()
  @IsString()
  @MinLength(1)
  @MaxLength(40)
  username?: string;

  @IsOptional()
  @IsString()
  @MaxLength(2048)
  avatarUrl?: string;

  @IsOptional()
  @IsString()
  @IsIn(['en', 'zh', 'hi', 'es', 'fr', 'ar', 'bn', 'pt', 'ru', 'ur', 'ja', 'ko'])
  locale?: string;

  @IsOptional()
  @IsString()
  @IsIn(['kcal', 'kj'])
  unitEnergy?: string;

  @IsOptional()
  @IsString()
  @IsIn(['g', 'oz'])
  unitMass?: string;

  @IsOptional()
  @IsBoolean()
  notifyEnabled?: boolean;

  @IsOptional()
  @ValidateNested()
  @Type(() => UpdateProfileDto)
  profile?: UpdateProfileDto;
}
