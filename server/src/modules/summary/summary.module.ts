import { Module } from '@nestjs/common';
import { SummaryController } from './summary.controller';
import { SummaryService } from './summary.service';
import { GoalModule } from '../goal/goal.module';

/**
 * 汇总域(API.md §4.14/§4.15)。依赖 GoalModule 解析「当日生效目标」。
 */
@Module({
  imports: [GoalModule],
  controllers: [SummaryController],
  providers: [SummaryService],
})
export class SummaryModule {}
