import { Logger, ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { ConfigService } from '@nestjs/config';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import helmet from 'helmet';
import { AppModule } from './app.module';
import { AppException } from './common/errors/app.exception';

async function bootstrap(): Promise<void> {
  const app = await NestFactory.create(AppModule, { bufferLogs: false });
  const config = app.get(ConfigService);
  const logger = new Logger('Bootstrap');

  // 生产环境强制要求强随机 JWT 密钥(零硬编码密钥铁律 §1.4)
  const isProd = config.get<string>('nodeEnv') === 'production';
  const accessSecret = config.get<string>('jwt.accessSecret');
  if (isProd && (!accessSecret || accessSecret.includes('dev-only'))) {
    throw new Error('JWT_ACCESS_SECRET must be set to a strong random value in production');
  }

  // 全局前缀 /api/v1(API.md §0)
  app.setGlobalPrefix('api/v1');

  // 安全基线:Helmet(§6)
  app.use(helmet());

  // CORS 白名单(§6);开发留空则放行所有以便本地联调
  const corsOrigins = config.get<string[]>('corsOrigins') ?? [];
  app.enableCors({
    origin: corsOrigins.length > 0 ? corsOrigins : true,
    credentials: true,
  });

  // 入参强校验:whitelist 去未声明字段,forbidNonWhitelisted 直接拒绝多余字段(§6 / 约束)
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      transformOptions: { enableImplicitConversion: false },
      // 校验失败交全局过滤器归一为 VALIDATION_FAILED;此处不抛带原值的默认异常
      exceptionFactory: () => new AppException('VALIDATION_FAILED'),
    }),
  );

  // Swagger / OpenAPI(API.md:后端出 OpenAPI 文档)
  if (!isProd) {
    const swaggerConfig = new DocumentBuilder()
      .setTitle('TestAI API')
      .setDescription('AI 饮食热量记录后端 · 鉴权域(FROZEN contract: docs/API.md)')
      .setVersion('1.0')
      .addBearerAuth()
      .build();
    const document = SwaggerModule.createDocument(app, swaggerConfig);
    SwaggerModule.setup('api/docs', app, document);
  }

  const port = config.get<number>('port') ?? 3000;
  await app.listen(port);
  logger.log(`TestAI server listening on :${port} (prefix /api/v1)`);
}

void bootstrap();
