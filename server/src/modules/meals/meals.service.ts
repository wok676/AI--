import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import { CurrentUserContext } from '../../common/auth/auth.types';
import { assertOwned } from '../../common/auth/ownership';
import { AppException } from '../../common/errors/app.exception';
import { MealType, RecognitionSource } from '../../common/domain/enums';
import { isValidLocalDate } from '../../common/util/local-date';
import { CreateMealDto, FoodItemInputDto, UpdateMealDto } from './dto/meal.dto';
import { FoodItemDto, MealDayDto, MealEntryDto } from './dto/meal-response.dto';

type MealWithItems = Prisma.MealEntryGetPayload<{ include: { items: true } }>;

/**
 * 饮食记录 CRUD(API.md §4.11–4.13)。
 * 横向归属铁律(§6):所有读/改/删强制 where { id, ownerId: currentUser.id };
 * 非本人或不存在一律归一 RESOURCE_NOT_FOUND(404),不暴露存在性。
 * totals 写时由 items 求和计算(冗余合计,读时免聚合)。
 */
@Injectable()
export class MealsService {
  constructor(private readonly prisma: PrismaService) {}

  async create(user: CurrentUserContext, dto: CreateMealDto): Promise<MealEntryDto> {
    const totals = this.computeTotals(dto.items);
    const meal = await this.prisma.mealEntry.create({
      data: {
        ownerId: user.id, // 取自鉴权上下文,绝不信任外部传入(横向归属)
        mealType: dto.mealType,
        consumedAt: new Date(dto.consumedAt),
        localDate: dto.localDate,
        source: dto.source,
        note: dto.note ?? null,
        ...totals,
        items: {
          create: dto.items.map((it) => this.toItemCreate(it, user.id)),
        },
      },
      include: { items: true },
    });
    return this.toDto(meal);
  }

  /** 日视图(API.md §4.12):按 owner + localDate 过滤,mealType/consumedAt 排序。 */
  async listByDate(user: CurrentUserContext, date: string): Promise<MealDayDto> {
    if (!isValidLocalDate(date)) {
      throw new AppException('VALIDATION_FAILED');
    }
    const entries = await this.prisma.mealEntry.findMany({
      where: { ownerId: user.id, localDate: date },
      include: { items: true },
      orderBy: [{ consumedAt: 'asc' }, { createdAt: 'asc' }],
    });
    return { date, entries: entries.map((e) => this.toDto(e)) };
  }

  async getOne(user: CurrentUserContext, id: string): Promise<MealEntryDto> {
    const meal = await this.prisma.mealEntry.findFirst({
      where: { id, ownerId: user.id }, // 横向归属过滤
      include: { items: true },
    });
    return this.toDto(assertOwned(meal)); // 空 → 404,不暴露存在性
  }

  /**
   * 编辑(API.md §4.13)。先以 where{id,ownerId} 确认归属(否则 404);
   * items 提供时全量替换并重算 totals。单事务保证一致性。
   */
  async update(user: CurrentUserContext, id: string, dto: UpdateMealDto): Promise<MealEntryDto> {
    const existing = await this.prisma.mealEntry.findFirst({
      where: { id, ownerId: user.id },
      select: { id: true },
    });
    assertOwned(existing);

    const updated = await this.prisma.$transaction(async (tx: Prisma.TransactionClient) => {
      const data: Prisma.MealEntryUpdateInput = {};
      if (dto.mealType !== undefined) data.mealType = dto.mealType;
      if (dto.consumedAt !== undefined) data.consumedAt = new Date(dto.consumedAt);
      if (dto.note !== undefined) data.note = dto.note;

      if (dto.items !== undefined) {
        // 全量替换:删旧 items → 建新 items → 重算 totals
        await tx.foodItem.deleteMany({ where: { mealEntryId: id } });
        const totals = this.computeTotals(dto.items);
        Object.assign(data, totals);
        data.items = { create: dto.items.map((it) => this.toItemCreate(it, user.id)) };
      }

      return tx.mealEntry.update({
        where: { id }, // 归属已在上方确认;此处 id 唯一定位
        data,
        include: { items: true },
      });
    });
    return this.toDto(updated);
  }

  async remove(user: CurrentUserContext, id: string): Promise<{ ok: true }> {
    // deleteMany + where{id,ownerId}:非本人/不存在 → count 0 → 归一 404,不暴露存在性
    const res = await this.prisma.mealEntry.deleteMany({ where: { id, ownerId: user.id } });
    if (res.count === 0) {
      throw new AppException('RESOURCE_NOT_FOUND');
    }
    return { ok: true };
  }

  // ---------------- helpers ----------------

  private toItemCreate(
    it: FoodItemInputDto,
    ownerId: string,
  ): Prisma.FoodItemCreateWithoutMealEntryInput {
    return {
      ownerId, // 冗余横向归属(直接查/改单项免 join)
      name: it.name,
      quantity: it.quantity,
      unit: it.unit,
      kcal: it.kcal,
      proteinG: it.proteinG,
      carbsG: it.carbsG,
      fatG: it.fatG,
      confidence: it.confidence ?? null,
      isManual: it.isManual ?? false,
    };
  }

  private computeTotals(items: FoodItemInputDto[]): {
    totalKcal: number;
    totalProteinG: number;
    totalCarbsG: number;
    totalFatG: number;
  } {
    // 合计为各项绝对值(quantity 已包含在 AI/用户填写的 kcal 中,按 API.md 示例 items 为最终值)
    return items.reduce(
      (acc, it) => ({
        totalKcal: this.round(acc.totalKcal + it.kcal),
        totalProteinG: this.round(acc.totalProteinG + it.proteinG),
        totalCarbsG: this.round(acc.totalCarbsG + it.carbsG),
        totalFatG: this.round(acc.totalFatG + it.fatG),
      }),
      { totalKcal: 0, totalProteinG: 0, totalCarbsG: 0, totalFatG: 0 },
    );
  }

  private round(n: number): number {
    return Math.round(n * 100) / 100;
  }

  private toDto(meal: MealWithItems): MealEntryDto {
    return {
      id: meal.id,
      mealType: meal.mealType as MealType,
      consumedAt: meal.consumedAt.toISOString(),
      localDate: meal.localDate,
      source: meal.source as RecognitionSource,
      note: meal.note,
      totalKcal: meal.totalKcal,
      totalProteinG: meal.totalProteinG,
      totalCarbsG: meal.totalCarbsG,
      totalFatG: meal.totalFatG,
      items: meal.items
        .slice()
        .sort((a, b) => a.createdAt.getTime() - b.createdAt.getTime())
        .map(
          (i): FoodItemDto => ({
            id: i.id,
            name: i.name,
            quantity: i.quantity,
            unit: i.unit,
            kcal: i.kcal,
            proteinG: i.proteinG,
            carbsG: i.carbsG,
            fatG: i.fatG,
            confidence: i.confidence,
            isManual: i.isManual,
          }),
        ),
      createdAt: meal.createdAt.toISOString(),
      updatedAt: meal.updatedAt.toISOString(),
    };
  }
}
