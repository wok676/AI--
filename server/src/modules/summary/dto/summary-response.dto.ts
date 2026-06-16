/**
 * 每日汇总(API.md §4.14 · 进度环)。
 */
export interface DailySummaryDto {
  date: string;
  goalKcal: number | null;
  consumedKcal: number;
  remainingKcal: number | null;
  macros: { proteinG: number; carbsG: number; fatG: number };
  streakDays: number;
}

/** 趋势单日(API.md §4.15)。 */
export interface TrendDayDto {
  date: string;
  consumedKcal: number;
  goalKcal: number | null;
  proteinG: number;
  carbsG: number;
  fatG: number;
}

/** 近 N 天趋势(API.md §4.15)。 */
export interface TrendDto {
  days: TrendDayDto[];
}
