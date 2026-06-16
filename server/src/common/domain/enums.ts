/**
 * 领域枚举(镜像 docs/DB-Schema.md §1 与 prisma/schema.prisma)。
 * 在代码层独立定义,使类型层与具体 Prisma provider(Postgres/SQLite dev)解耦:
 * SQLite 不生成原生 enum 类型,故不直接 import 自 @prisma/client。
 * 值与 Prisma enum 字面量逐一对齐,数据库读写一致。
 */

export enum Role {
  USER = 'USER',
  ADMIN = 'ADMIN',
}

export enum Plan {
  FREE = 'FREE',
  PRO = 'PRO',
}

export enum AuthProvider {
  EMAIL = 'EMAIL',
  APPLE = 'APPLE',
  GOOGLE = 'GOOGLE',
}

export enum MealType {
  BREAKFAST = 'BREAKFAST',
  LUNCH = 'LUNCH',
  DINNER = 'DINNER',
  SNACK = 'SNACK',
}

export enum Sex {
  MALE = 'MALE',
  FEMALE = 'FEMALE',
  UNSPECIFIED = 'UNSPECIFIED',
}

export enum ActivityLevel {
  SEDENTARY = 'SEDENTARY',
  LIGHT = 'LIGHT',
  MODERATE = 'MODERATE',
  ACTIVE = 'ACTIVE',
  VERY_ACTIVE = 'VERY_ACTIVE',
}

export enum GoalType {
  LOSE = 'LOSE',
  MAINTAIN = 'MAINTAIN',
  GAIN = 'GAIN',
}

export enum AccountStatus {
  ACTIVE = 'ACTIVE',
  BANNED = 'BANNED',
}

export enum RecognitionSource {
  PHOTO = 'PHOTO',
  GALLERY = 'GALLERY',
  TEXT = 'TEXT',
}
