import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsBoolean,
  IsEnum,
  IsISO8601,
  IsNumber,
  IsOptional,
  IsString,
  Matches,
  Max,
  MaxLength,
  Min,
  MinLength,
  ValidateNested,
} from 'class-validator';
import { MealType, RecognitionSource } from '../../../common/domain/enums';

/**
 * 餐内单条食物项(API.md §4.11)。数值强校验:非负 + 合理上限,杜绝脏数据污染汇总。
 * 字段名与 DB FoodItem / 前端共享类型逐字段对齐。
 */
export class FoodItemInputDto {
  @IsString()
  @MinLength(1)
  @MaxLength(120)
  name!: string;

  @IsNumber()
  @Min(0)
  @Max(10000)
  quantity!: number;

  @IsString()
  @MinLength(1)
  @MaxLength(24)
  unit!: string;

  @IsNumber()
  @Min(0)
  @Max(100000)
  kcal!: number;

  @IsNumber()
  @Min(0)
  @Max(100000)
  proteinG!: number;

  @IsNumber()
  @Min(0)
  @Max(100000)
  carbsG!: number;

  @IsNumber()
  @Min(0)
  @Max(100000)
  fatG!: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Max(1)
  confidence?: number;

  @IsOptional()
  @IsBoolean()
  isManual?: boolean;
}

/**
 * 创建一餐(API.md §4.11)。ownerId 取 req.user.id,绝不接受外部传入(横向归属 §6)。
 */
export class CreateMealDto {
  @IsEnum(MealType)
  mealType!: MealType;

  @IsISO8601()
  consumedAt!: string;

  @Matches(/^\d{4}-\d{2}-\d{2}$/, { message: 'localDate must be YYYY-MM-DD' })
  localDate!: string;

  @IsEnum(RecognitionSource)
  source!: RecognitionSource;

  @IsOptional()
  @IsString()
  @MaxLength(500)
  note?: string;

  @IsArray()
  @ArrayMinSize(1)
  @ArrayMaxSize(50)
  @ValidateNested({ each: true })
  @Type(() => FoodItemInputDto)
  items!: FoodItemInputDto[];
}

/**
 * 编辑一餐(API.md §4.13)。items 提供时全量替换并重算 totals。任意子集。
 */
export class UpdateMealDto {
  @IsOptional()
  @IsEnum(MealType)
  mealType?: MealType;

  @IsOptional()
  @IsISO8601()
  consumedAt?: string;

  @IsOptional()
  @IsString()
  @MaxLength(500)
  note?: string;

  @IsOptional()
  @IsArray()
  @ArrayMinSize(1)
  @ArrayMaxSize(50)
  @ValidateNested({ each: true })
  @Type(() => FoodItemInputDto)
  items?: FoodItemInputDto[];
}
