import { Controller, Get } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { Public } from '../../common/auth/public.decorator';

/**
 * 健康检查(API.md §3 #22 / §4.18,部署用)。公开端点。
 */
@ApiTags('health')
@Controller('health')
export class HealthController {
  @Public()
  @Get()
  check(): { status: 'ok'; time: string } {
    return { status: 'ok', time: new Date().toISOString() };
  }
}
