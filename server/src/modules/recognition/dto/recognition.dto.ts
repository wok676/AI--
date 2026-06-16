import { IsIn, IsOptional, IsString, MaxLength, MinLength } from 'class-validator';
import { RecognitionSource } from '../../../common/domain/enums';

/**
 * 文字描述识别入参(API.md §4.10 F3,application/json)。
 * 图片识别走 multipart/form-data,由 controller 用 FileInterceptor 取 file + source(见 controller)。
 * 配合全局 ValidationPipe(whitelist + forbidNonWhitelisted)。
 */
export class RecognizeTextDto {
  @IsString()
  @MinLength(1)
  @MaxLength(1000)
  text!: string;

  @IsIn([RecognitionSource.TEXT])
  source!: RecognitionSource.TEXT;
}

/**
 * 图片识别 multipart 表单中的 source 字段(image 文件由拦截器单独处理)。
 */
export class RecognizeImageFormDto {
  @IsOptional()
  @IsIn([RecognitionSource.PHOTO, RecognitionSource.GALLERY])
  source?: RecognitionSource.PHOTO | RecognitionSource.GALLERY;
}
