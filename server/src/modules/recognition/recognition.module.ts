import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { RecognitionController } from './recognition.controller';
import { RecognitionService } from './recognition.service';
import { ClaudeClient } from './claude.client';

/**
 * 识别域(API.md §4.10)。ClaudeClient 后端代理(密钥走 .env,不下发客户端)。
 */
@Module({
  imports: [ConfigModule],
  controllers: [RecognitionController],
  providers: [RecognitionService, ClaudeClient],
})
export class RecognitionModule {}
