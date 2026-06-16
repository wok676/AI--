import { Module } from '@nestjs/common';
import { MealsController } from './meals.controller';
import { MealsService } from './meals.service';

/**
 * 饮食记录域(API.md §4.11–4.13)。横向归属在 service 层强制 where { ownerId }。
 */
@Module({
  controllers: [MealsController],
  providers: [MealsService],
})
export class MealsModule {}
