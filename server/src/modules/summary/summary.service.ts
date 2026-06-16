import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CurrentUserContext } from '../../common/auth/auth.types';
import { AppException } from '../../common/errors/app.exception';
import { isValidLocalDate, recentLocalDates, toLocalDateUTC } from '../../common/util/local-date';
import { GoalService } from '../goal/goal.service';
import { DailySummaryDto, TrendDayDto, TrendDto } from './dto/summary-response.dto';

/**
 * 每日热量/宏量汇总 + 对比目标(API.md §4.14/§4.15)。
 * 横向归属:全部聚合 where { ownerId }。命中 MealEntry @@index([ownerId, localDate])。
 */
@Injectable()
export class SummaryService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly goal: GoalService,
  ) {}

  async daily(user: CurrentUserContext, date: string): Promise<DailySummaryDto> {
    if (!isValidLocalDate(date)) {
      throw new AppException('VALIDATION_FAILED');
    }
    const agg = await this.aggregateDay(user.id, date);
    const goal = await this.goal.getEffective(user.id, date);
    const goalKcal = goal?.targetKcal ?? null;
    const consumedKcal = this.round(agg.totalKcal);

    return {
      date,
      goalKcal,
      consumedKcal,
      remainingKcal: goalKcal === null ? null : this.round(goalKcal - consumedKcal),
      macros: {
        proteinG: this.round(agg.totalProteinG),
        carbsG: this.round(agg.totalCarbsG),
        fatG: this.round(agg.totalFatG),
      },
      streakDays: await this.streak(user.id, date),
    };
  }

  /** 近 N 天趋势(API.md §4.15)。days 限定 1..30(Should:Free 7,Pro 30)。 */
  async trend(user: CurrentUserContext, days: number): Promise<TrendDto> {
    const n = Math.min(Math.max(Number.isFinite(days) ? days : 7, 1), 30);
    const today = toLocalDateUTC();
    const dates = recentLocalDates(today, n); // 降序(含今日)

    const out: TrendDayDto[] = [];
    for (const date of dates.slice().reverse()) {
      // 升序输出
      const agg = await this.aggregateDay(user.id, date);
      const goal = await this.goal.getEffective(user.id, date);
      out.push({
        date,
        consumedKcal: this.round(agg.totalKcal),
        goalKcal: goal?.targetKcal ?? null,
        proteinG: this.round(agg.totalProteinG),
        carbsG: this.round(agg.totalCarbsG),
        fatG: this.round(agg.totalFatG),
      });
    }
    return { days: out };
  }

  /** 用 MealEntry 冗余 totals 求和(写时已算,读时免聚合 FoodItem)。 */
  private async aggregateDay(
    ownerId: string,
    localDate: string,
  ): Promise<{
    totalKcal: number;
    totalProteinG: number;
    totalCarbsG: number;
    totalFatG: number;
  }> {
    const res = await this.prisma.mealEntry.aggregate({
      where: { ownerId, localDate },
      _sum: { totalKcal: true, totalProteinG: true, totalCarbsG: true, totalFatG: true },
    });
    const s = res._sum;
    return {
      totalKcal: s.totalKcal ?? 0,
      totalProteinG: s.totalProteinG ?? 0,
      totalCarbsG: s.totalCarbsG ?? 0,
      totalFatG: s.totalFatG ?? 0,
    };
  }

  /**
   * 连续记录天数(Should):从给定日往前找有 meal 的连续自然日;断档即止。
   * 上限回溯 60 天防长扫。
   */
  private async streak(ownerId: string, endDate: string): Promise<number> {
    const window = recentLocalDates(endDate, 60); // 降序
    const logged = await this.prisma.mealEntry.findMany({
      where: { ownerId, localDate: { in: window } },
      select: { localDate: true },
      distinct: ['localDate'],
    });
    const set = new Set(logged.map((m: { localDate: string }) => m.localDate));
    let count = 0;
    for (const d of window) {
      if (set.has(d)) count++;
      else break;
    }
    return count;
  }

  private round(n: number): number {
    return Math.round(n * 100) / 100;
  }
}
