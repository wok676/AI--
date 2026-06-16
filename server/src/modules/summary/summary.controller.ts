import { Controller, Get, ParseIntPipe, Query } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { SummaryService } from './summary.service';
import { CurrentUser } from '../../common/auth/current-user.decorator';
import { CurrentUserContext } from '../../common/auth/auth.types';
import { DailySummaryDto, TrendDto } from './dto/summary-response.dto';

/**
 * 汇总端点(API.md §3 #17–18)。需 Bearer。横向归属取 req.user。
 */
@ApiTags('summary')
@Controller('summary')
export class SummaryController {
  constructor(private readonly summary: SummaryService) {}

  @Get('daily')
  daily(
    @CurrentUser() user: CurrentUserContext,
    @Query('date') date: string,
  ): Promise<DailySummaryDto> {
    return this.summary.daily(user, date);
  }

  @Get('trend')
  trend(
    @CurrentUser() user: CurrentUserContext,
    @Query('days', new ParseIntPipe({ optional: true })) days = 7,
  ): Promise<TrendDto> {
    return this.summary.trend(user, days);
  }
}
