import { IsEnum, IsIn, IsInt, IsOptional, Matches, Max, Min } from 'class-validator';
import { ActivityLevel, GoalType, Sex } from '../../../common/domain/enums';

/**
 * 设/改每日目标(API.md §4.16,PUT /goal)。upsert by (ownerId, effectiveFrom)。
 */
export class PutGoalDto {
  @IsInt()
  @Min(500)
  @Max(10000)
  targetKcal!: number;

  @Matches(/^\d{4}-\d{2}-\d{2}$/, { message: 'effectiveFrom must be YYYY-MM-DD' })
  effectiveFrom!: string;

  @IsOptional()
  @IsIn(['manual', 'estimated'])
  source?: 'manual' | 'estimated';
}

/**
 * Mifflin-St Jeor 估算入参(API.md §4.17,POST /goal/estimate · 纯计算不落库)。
 */
export class EstimateGoalDto {
  @IsEnum(Sex)
  sex!: Sex;

  @IsInt()
  @Min(1900)
  @Max(new Date().getFullYear())
  birthYear!: number;

  @IsInt()
  @Min(50)
  @Max(280)
  heightCm!: number;

  @IsInt()
  @Min(20)
  @Max(500)
  weightKg!: number;

  @IsEnum(ActivityLevel)
  activityLevel!: ActivityLevel;

  @IsEnum(GoalType)
  goalType!: GoalType;
}
