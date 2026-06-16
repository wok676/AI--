// API 共享类型 · 逐字段对齐 docs/API.md(FROZEN)。
//
// 强耦合点②(响应字段名/结构)③(JWT 结构)。改任一字段须前后端同步。
// Dart strict:禁滥用 dynamic;JSON 解析全部容错(缺字段不崩溃,宪法 §1.2)。

import 'package:flutter/foundation.dart';

// ───────────────────────── 枚举(对齐 API/DB 契约) ─────────────────────────

/// 角色(JWT user.role,API §1)。
enum UserRole {
  user,
  admin;

  static UserRole fromJson(Object? v) =>
      v == 'ADMIN' ? UserRole.admin : UserRole.user;
}

enum MealType {
  breakfast,
  lunch,
  dinner,
  snack;

  String toJson() => switch (this) {
        MealType.breakfast => 'BREAKFAST',
        MealType.lunch => 'LUNCH',
        MealType.dinner => 'DINNER',
        MealType.snack => 'SNACK',
      };

  static MealType fromJson(Object? v) => switch (v) {
        'BREAKFAST' => MealType.breakfast,
        'LUNCH' => MealType.lunch,
        'DINNER' => MealType.dinner,
        'SNACK' => MealType.snack,
        _ => MealType.snack,
      };
}

/// 录入来源(API §4.10/§4.11)。
enum RecognitionSource {
  photo,
  gallery,
  text;

  String toJson() => switch (this) {
        RecognitionSource.photo => 'PHOTO',
        RecognitionSource.gallery => 'GALLERY',
        RecognitionSource.text => 'TEXT',
      };
}

// ───────────────────────── JWT 结构(强耦合点③ · API §1) ─────────────────────────

/// 对齐 JWT 返回的 user 子对象:{ id, username, role }。
@immutable
class AuthUser {
  const AuthUser({required this.id, required this.username, required this.role});

  final String id;
  final String username;
  final UserRole role;

  factory AuthUser.fromJson(Map<String, Object?> json) => AuthUser(
        id: json['id'] as String? ?? '',
        username: json['username'] as String? ?? '',
        role: UserRole.fromJson(json['role']),
      );
}

/// 登录/注册/Apple/刷新 成功返回:{ accessToken, refreshToken, user }(API §1,不可改)。
@immutable
class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  final String accessToken; // JWT, 15min
  final String refreshToken; // opaque, 30d —— 存 flutter_secure_storage,禁明文
  final AuthUser user;

  factory AuthSession.fromJson(Map<String, Object?> json) => AuthSession(
        accessToken: json['accessToken'] as String? ?? '',
        refreshToken: json['refreshToken'] as String? ?? '',
        user: AuthUser.fromJson(
          (json['user'] as Map<String, Object?>?) ?? const <String, Object?>{},
        ),
      );
}

// ───────────────────────── 统一错误响应(API §0.2/§0.3) ─────────────────────────

/// 后端统一错误体:{ statusCode, code, messageKey, traceId, details }。绝不含堆栈。
@immutable
class ApiError implements Exception {
  const ApiError({
    required this.statusCode,
    required this.code,
    required this.messageKey,
    this.traceId,
    this.details,
  });

  final int statusCode;
  final String code; // SCREAMING_SNAKE 业务码
  final String messageKey; // i18n key(点号命名空间,前端映射到 ARB 下划线 key)
  final String? traceId;
  final Map<String, Object?>? details;

  factory ApiError.fromJson(Map<String, Object?> json, {int? fallbackStatus}) => ApiError(
        statusCode: (json['statusCode'] as num?)?.toInt() ?? fallbackStatus ?? 500,
        code: json['code'] as String? ?? 'INTERNAL_ERROR',
        messageKey: json['messageKey'] as String? ?? 'common.error.generic',
        traceId: json['traceId'] as String?,
        details: json['details'] as Map<String, Object?>?,
      );

  /// 客户端侧网络/超时/解析等本地异常构造的错误(messageKey 对齐 §0.3)。
  const ApiError.local({
    required this.code,
    required this.messageKey,
    this.statusCode = 0,
    this.traceId,
    this.details,
  });

  @override
  String toString() => 'ApiError($statusCode, $code, $messageKey)';
}

// ───────────────────────── 业务 DTO(供 T5/T6 复用) ─────────────────────────

/// 识别出的单个食物项(API §4.10 items[])。
@immutable
class RecognizedItem {
  const RecognizedItem({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.kcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.confidence,
    this.isManual = false,
  });

  final String name;
  final num quantity;
  final String unit;
  final num kcal;
  final num proteinG;
  final num carbsG;
  final num fatG;
  final double? confidence; // null/低于阈值 → UI 标记 recognize.lowConfidence
  final bool isManual;

  factory RecognizedItem.fromJson(Map<String, Object?> json) => RecognizedItem(
        name: json['name'] as String? ?? '',
        quantity: json['quantity'] as num? ?? 1,
        unit: json['unit'] as String? ?? '',
        kcal: json['kcal'] as num? ?? 0,
        proteinG: json['proteinG'] as num? ?? 0,
        carbsG: json['carbsG'] as num? ?? 0,
        fatG: json['fatG'] as num? ?? 0,
        confidence: (json['confidence'] as num?)?.toDouble(),
        isManual: json['isManual'] as bool? ?? false,
      );

  Map<String, Object?> toJson() => <String, Object?>{
        'name': name,
        'quantity': quantity,
        'unit': unit,
        'kcal': kcal,
        'proteinG': proteinG,
        'carbsG': carbsG,
        'fatG': fatG,
        if (confidence != null) 'confidence': confidence,
        'isManual': isManual,
      };
}

/// 识别响应(未入库,供结果确认页编辑,API §4.10)。
@immutable
class RecognitionResult {
  const RecognitionResult({
    required this.items,
    required this.suggestedMealType,
    required this.disclaimerKey,
  });

  final List<RecognizedItem> items;
  final MealType suggestedMealType;
  final String disclaimerKey; // 固定 recognize.disclaimer(F6 免责声明)

  factory RecognitionResult.fromJson(Map<String, Object?> json) => RecognitionResult(
        items: ((json['items'] as List<Object?>?) ?? const <Object?>[])
            .whereType<Map<String, Object?>>()
            .map(RecognizedItem.fromJson)
            .toList(growable: false),
        suggestedMealType: MealType.fromJson(json['suggestedMealType']),
        disclaimerKey: json['disclaimerKey'] as String? ?? 'recognize.disclaimer',
      );
}

/// 每日汇总(进度环,API §4.14)。
@immutable
class DailySummary {
  const DailySummary({
    required this.date,
    required this.goalKcal,
    required this.consumedKcal,
    required this.remainingKcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.streakDays,
  });

  final String date;
  final num goalKcal;
  final num consumedKcal;
  final num remainingKcal;
  final num proteinG;
  final num carbsG;
  final num fatG;
  final int? streakDays;

  factory DailySummary.fromJson(Map<String, Object?> json) {
    final Map<String, Object?> macros =
        (json['macros'] as Map<String, Object?>?) ?? const <String, Object?>{};
    return DailySummary(
      date: json['date'] as String? ?? '',
      goalKcal: json['goalKcal'] as num? ?? 0,
      consumedKcal: json['consumedKcal'] as num? ?? 0,
      remainingKcal: json['remainingKcal'] as num? ?? 0,
      proteinG: macros['proteinG'] as num? ?? 0,
      carbsG: macros['carbsG'] as num? ?? 0,
      fatG: macros['fatG'] as num? ?? 0,
      streakDays: (json['streakDays'] as num?)?.toInt(),
    );
  }
}
