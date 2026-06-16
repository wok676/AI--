import {
  Body,
  Controller,
  Headers,
  HttpCode,
  HttpStatus,
  Post,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiConsumes, ApiTags } from '@nestjs/swagger';
import { memoryStorage } from 'multer';
import { RecognitionService } from './recognition.service';
import { CurrentUser } from '../../common/auth/current-user.decorator';
import { CurrentUserContext } from '../../common/auth/auth.types';
import { AppException } from '../../common/errors/app.exception';
import { RecognitionSource } from '../../common/domain/enums';
import { RecognizeTextDto } from './dto/recognition.dto';
import { RecognitionResultDto } from './dto/recognition-response.dto';

/**
 * 上传文件最小类型(避免引入 @types/multer 依赖)。memoryStorage 保证 buffer 不落磁盘。
 */
interface UploadedImage {
  buffer: Buffer;
  mimetype: string;
  size: number;
}

/**
 * AI 食物识别端点(API.md §3 #11 · POST /recognition)。需 Bearer(全局 JwtAuthGuard)。
 * 两种形态:multipart 图片(/recognition,FileInterceptor)与 JSON 文字(/recognition/text)。
 * 同一业务路径 /recognition:Content-Type 为 multipart 时走图片处理器;前端文字请求打 /recognition/text。
 *
 * 注:为兼容契约 §4.10 的单端点语义,图片与文字共用 RecognitionService.recognize;
 * 文字请求体若误带到图片端点会被 ValidationPipe 拦截。
 */
@ApiTags('recognition')
@Controller('recognition')
export class RecognitionController {
  constructor(private readonly recognition: RecognitionService) {}

  /**
   * 图片识别(F1/F2)。memoryStorage:原图仅进内存 buffer,处理后由 service 丢弃,绝不落盘/落库。
   */
  @Post()
  @HttpCode(HttpStatus.OK)
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(
    FileInterceptor('image', {
      storage: memoryStorage(),
      // 大小上限兜底(精确上限在 service 用配置再校验)
      limits: { fileSize: 16 * 1024 * 1024 },
    }),
  )
  async recognizeImage(
    @CurrentUser() user: CurrentUserContext,
    @UploadedFile() file: UploadedImage | undefined,
    @Body('source') source: string | undefined,
    @Headers('x-local-date') localDate: string | undefined,
  ): Promise<RecognitionResultDto> {
    if (!file || !file.buffer || file.size === 0) {
      throw new AppException('RECOGNIZE_FAILED');
    }
    const mediaType = this.resolveMediaType(file.mimetype);
    const src =
      source === RecognitionSource.GALLERY ? RecognitionSource.GALLERY : RecognitionSource.PHOTO;

    return this.recognition.recognize(user, {
      source: src,
      image: { buffer: file.buffer, mediaType },
      localDate: this.normalizeLocalDate(localDate),
    });
  }

  /**
   * 文字描述识别(F3)。application/json。
   */
  @Post('text')
  @HttpCode(HttpStatus.OK)
  async recognizeText(
    @CurrentUser() user: CurrentUserContext,
    @Body() dto: RecognizeTextDto,
    @Headers('x-local-date') localDate: string | undefined,
  ): Promise<RecognitionResultDto> {
    return this.recognition.recognize(user, {
      source: RecognitionSource.TEXT,
      text: dto.text,
      localDate: this.normalizeLocalDate(localDate),
    });
  }

  private resolveMediaType(mimetype: string): string {
    if (mimetype === 'image/png') return 'image/png';
    if (mimetype === 'image/jpeg' || mimetype === 'image/jpg') return 'image/jpeg';
    // 不支持的类型:归一为无法识别(不接受任意二进制)
    throw new AppException('RECOGNIZE_FAILED');
  }

  private normalizeLocalDate(value: string | undefined): string | undefined {
    return value && /^\d{4}-\d{2}-\d{2}$/.test(value) ? value : undefined;
  }
}
