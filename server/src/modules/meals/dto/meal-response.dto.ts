import { MealType, RecognitionSource } from '../../../common/domain/enums';

/**
 * 餐内食物项响应(API.md §4.11)。字段名与前端共享类型逐字段对齐。
 */
export interface FoodItemDto {
  id: string;
  name: string;
  quantity: number;
  unit: string;
  kcal: number;
  proteinG: number;
  carbsG: number;
  fatG: number;
  confidence: number | null;
  isManual: boolean;
}

/**
 * 一餐完整响应(API.md §4.11/§4.12)。含 totals(写时计算冗余合计)。
 */
export interface MealEntryDto {
  id: string;
  mealType: MealType;
  consumedAt: string;
  localDate: string;
  source: RecognitionSource;
  note: string | null;
  totalKcal: number;
  totalProteinG: number;
  totalCarbsG: number;
  totalFatG: number;
  items: FoodItemDto[];
  createdAt: string;
  updatedAt: string;
}

/** 日视图(API.md §4.12)。 */
export interface MealDayDto {
  date: string;
  entries: MealEntryDto[];
}

export interface OkDto {
  ok: true;
}
