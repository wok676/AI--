import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { MealsService } from './meals.service';
import { CurrentUser } from '../../common/auth/current-user.decorator';
import { CurrentUserContext } from '../../common/auth/auth.types';
import { CreateMealDto, UpdateMealDto } from './dto/meal.dto';
import { MealDayDto, MealEntryDto, OkDto } from './dto/meal-response.dto';

/**
 * 饮食记录端点(API.md §3 #12–16)。需 Bearer(全局 JwtAuthGuard)。
 * 所有路径不接受外部 ownerId;归属取 req.user(横向归属 §6)。
 */
@ApiTags('meals')
@Controller('meals')
export class MealsController {
  constructor(private readonly meals: MealsService) {}

  @Post()
  create(
    @CurrentUser() user: CurrentUserContext,
    @Body() dto: CreateMealDto,
  ): Promise<MealEntryDto> {
    return this.meals.create(user, dto);
  }

  @Get()
  list(@CurrentUser() user: CurrentUserContext, @Query('date') date: string): Promise<MealDayDto> {
    return this.meals.listByDate(user, date);
  }

  @Get(':id')
  getOne(@CurrentUser() user: CurrentUserContext, @Param('id') id: string): Promise<MealEntryDto> {
    return this.meals.getOne(user, id);
  }

  @Patch(':id')
  update(
    @CurrentUser() user: CurrentUserContext,
    @Param('id') id: string,
    @Body() dto: UpdateMealDto,
  ): Promise<MealEntryDto> {
    return this.meals.update(user, id, dto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.OK)
  remove(@CurrentUser() user: CurrentUserContext, @Param('id') id: string): Promise<OkDto> {
    return this.meals.remove(user, id);
  }
}
