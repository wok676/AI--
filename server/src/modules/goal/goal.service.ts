import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CurrentUserContext } from '../../common/auth/auth.types';
import { ActivityLevel, GoalType, Sex } from '../../common/domain/enums';
import { toLocalDateUTC } from '../../common/util/local-date';
import { EstimateGoalDto, PutGoalDto } from './dto/goal.dto';
import { GoalDto, GoalEstimateDto } from './dto/goal-response.dto';

/**
 * 每日热量目标(API.md §4.16/§4.17)。横向归属:全部 where { ownerId }。
 */
@Injectable()
export class GoalService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * 取「当日生效」目标:effectiveFrom <= 给定本地日期中最近的一条;无则返回 null。
   * 供 GET /goal 与 summary 共用。
   */
  async getEffective(ownerId: string, onDate?: string): Promise<GoalDto | null> {
    const date = onDate ?? toLocalDateUTC();
    const goal = await this.prisma.dailyGoal.findFirst({
      where: { ownerId, effectiveFrom: { lte: date } },
      orderBy: { effectiveFrom: 'desc' },
    });
    if (!goal) return null;
    return { targetKcal: goal.targetKcal, effectiveFrom: goal.effectiveFrom, source: goal.source };
  }

  async get(user: CurrentUserContext): Promise<GoalDto | null> {
    return this.getEffective(user.id);
  }

  /** upsert by (ownerId, effectiveFrom):同一天只一条生效目标(DB §7)。 */
  async put(user: CurrentUserContext, dto: PutGoalDto): Promise<GoalDto> {
    const source = dto.source ?? 'manual';
    const goal = await this.prisma.dailyGoal.upsert({
      where: { ownerId_effectiveFrom: { ownerId: user.id, effectiveFrom: dto.effectiveFrom } },
      create: {
        ownerId: user.id, // 取自鉴权上下文(横向归属)
        targetKcal: dto.targetKcal,
        effectiveFrom: dto.effectiveFrom,
        source,
      },
      update: { targetKcal: dto.targetKcal, source },
    });
    return { targetKcal: goal.targetKcal, effectiveFrom: goal.effectiveFrom, source: goal.source };
  }

  /**
   * Mifflin-St Jeor BMR × 活动系数 × 目标调整(API.md §4.17 · 纯计算不落库)。
   * 返回「建议参考值」,固定附免责声明(不构成医疗建议,PRD §4.6)。
   */
  estimate(dto: EstimateGoalDto): GoalEstimateDto {
    const age = new Date().getFullYear() - dto.birthYear;
    // BMR(Mifflin-St Jeor):男 +5,女 -161,未指定取两者均值(-78)
    const base = 10 * dto.weightKg + 6.25 * dto.heightCm - 5 * age;
    const sexAdj = dto.sex === Sex.MALE ? 5 : dto.sex === Sex.FEMALE ? -161 : -78;
    const bmr = base + sexAdj;

    const activityFactor: Record<ActivityLevel, number> = {
      [ActivityLevel.SEDENTARY]: 1.2,
      [ActivityLevel.LIGHT]: 1.375,
      [ActivityLevel.MODERATE]: 1.55,
      [ActivityLevel.ACTIVE]: 1.725,
      [ActivityLevel.VERY_ACTIVE]: 1.9,
    };
    const tdee = bmr * activityFactor[dto.activityLevel];

    // 目标调整:减重 -15%,增重 +15%,维持不变(温和、安全区间)
    const goalFactor: Record<GoalType, number> = {
      [GoalType.LOSE]: 0.85,
      [GoalType.MAINTAIN]: 1,
      [GoalType.GAIN]: 1.15,
    };
    const estimated = Math.round((tdee * goalFactor[dto.goalType]) / 10) * 10;

    return { estimatedKcal: estimated, disclaimerKey: 'goal.disclaimer' };
  }
}
