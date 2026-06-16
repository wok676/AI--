import { Module } from '@nestjs/common';
import { MeController } from './me.controller';
import { MeService } from './me.service';

/**
 * /me 模块(API.md §3 #9–10)。PrismaModule 为全局,无需在此 import。
 */
@Module({
  controllers: [MeController],
  providers: [MeService],
})
export class MeModule {}
