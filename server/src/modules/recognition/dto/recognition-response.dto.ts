import { MealType } from '../../../common/domain/enums';

/**
 * 识别结果单条食物项(API.md §4.10 响应)。字段名与前端共享类型逐字段对齐。
 * 注意:宏量字段对外为 proteinG/carbsG/fatG(与 MealEntry/FoodItem 一致),
 * Claude 原始 JSON 用 protein/carbs/fat,由 service 映射归一。
 */
export interface RecognizedItemDto {
  name: string;
  quantity: number;
  unit: string;
  kcal: number;
  proteinG: number;
  carbsG: number;
  fatG: number;
  confidence: number;
}

/**
 * 识别响应(API.md §4.10):**未入库**,供结果确认页编辑;**不含原图 URL**(§4.7)。
 */
export interface RecognitionResultDto {
  items: RecognizedItemDto[];
  suggestedMealType: MealType;
  disclaimerKey: 'recognize.disclaimer';
}
