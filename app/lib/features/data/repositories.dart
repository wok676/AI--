import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api_client.dart';
import '../../api/error_mapper.dart';
import '../../api/types.dart';

/// 仓储层(对照 docs/API.md FROZEN 端点)。
///
/// 设计要点(宪法 §1.2/§5):
/// - 所有网络调用都经统一 [ApiClient](拦截器已集中处理超时/重试/断网/401);
/// - 每个方法把 [DioException] 兜底映射为 [ApiError](messageKey),绝不把原始异常/堆栈泄露给 UI;
/// - Provider 暴露给 Riverpod 的 AsyncNotifier / FutureProvider 调用,三态由 [AsyncValue] 承载。
ApiError _toApiError(Object e) {
  if (e is ApiError) return e;
  if (e is DioException) {
    final Object? mapped = e.error;
    return mapped is ApiError ? mapped : mapDioException(e);
  }
  return const ApiError.local(code: 'INTERNAL_ERROR', messageKey: 'common.error.generic');
}

/// 把任意 repository 调用统一包一层 try-catch,异常转 [ApiError] 抛出(供 AsyncValue.error 捕获)。
Future<T> _guard<T>(Future<T> Function() body) async {
  try {
    return await body();
  } catch (e) {
    throw _toApiError(e);
  }
}

// ───────────────────────── Auth ─────────────────────────

class AuthRepository {
  AuthRepository(this._client);
  final ApiClient _client;
  Dio get _dio => _client.dio;

  /// 公开端点统一打 skipAuth(不注入 Bearer,API §2)。
  Options get _guestOptions => Options(extra: <String, Object?>{'skipAuth': true});

  Future<AuthSession> login({required String email, required String password}) {
    return _guard(() async {
      final Response<Map<String, Object?>> resp = await _dio.post<Map<String, Object?>>(
        '/auth/login',
        data: <String, Object?>{'email': email, 'password': password},
        options: _guestOptions,
      );
      return AuthSession.fromJson(resp.data ?? const <String, Object?>{});
    });
  }

  Future<AuthSession> register({
    required String email,
    required String password,
    required bool consentAccepted,
    required String consentVersion,
    required String locale,
  }) {
    return _guard(() async {
      final Response<Map<String, Object?>> resp = await _dio.post<Map<String, Object?>>(
        '/auth/register',
        data: <String, Object?>{
          'email': email,
          'password': password,
          'consentAccepted': consentAccepted,
          'consentVersion': consentVersion,
          'locale': locale,
        },
        options: _guestOptions,
      );
      return AuthSession.fromJson(resp.data ?? const <String, Object?>{});
    });
  }

  /// Sign in with Apple(iOS Must,API §4.3)。
  Future<AuthSession> apple({
    required String identityToken,
    required String authorizationCode,
    String? fullName,
    required String locale,
  }) {
    return _guard(() async {
      final Response<Map<String, Object?>> resp = await _dio.post<Map<String, Object?>>(
        '/auth/apple',
        data: <String, Object?>{
          'identityToken': identityToken,
          'authorizationCode': authorizationCode,
          'fullName': ?fullName,
          'locale': locale,
        },
        options: _guestOptions,
      );
      return AuthSession.fromJson(resp.data ?? const <String, Object?>{});
    });
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (Ref ref) => AuthRepository(ref.watch(apiClientProvider)),
);

// ───────────────────────── Me / Profile ─────────────────────────

class MeRepository {
  MeRepository(this._client);
  final ApiClient _client;
  Dio get _dio => _client.dio;

  Future<MeProfile> getMe() {
    return _guard(() async {
      final Response<Map<String, Object?>> resp =
          await _dio.get<Map<String, Object?>>('/me');
      return MeProfile.fromJson(resp.data ?? const <String, Object?>{});
    });
  }

  Future<MeProfile> patchMe(Map<String, Object?> patch) {
    return _guard(() async {
      final Response<Map<String, Object?>> resp =
          await _dio.patch<Map<String, Object?>>('/me', data: patch);
      return MeProfile.fromJson(resp.data ?? const <String, Object?>{});
    });
  }
}

final meRepositoryProvider = Provider<MeRepository>(
  (Ref ref) => MeRepository(ref.watch(apiClientProvider)),
);

// ───────────────────────── Recognition / Meals ─────────────────────────

class MealRepository {
  MealRepository(this._client);
  final ApiClient _client;
  Dio get _dio => _client.dio;

  /// 文字识别(API §4.10,JSON)。
  Future<RecognitionResult> recognizeText(String text) {
    return _guard(() async {
      final Response<Map<String, Object?>> resp = await _dio.post<Map<String, Object?>>(
        '/recognition',
        data: <String, Object?>{'text': text, 'source': 'TEXT'},
      );
      return RecognitionResult.fromJson(resp.data ?? const <String, Object?>{});
    });
  }

  /// 图片识别(API §4.10,multipart/form-data)。
  Future<RecognitionResult> recognizeImage({
    required String filePath,
    required RecognitionSource source,
  }) {
    return _guard(() async {
      final FormData form = FormData.fromMap(<String, Object?>{
        'image': await MultipartFile.fromFile(filePath),
        'source': source.toJson(),
      });
      final Response<Map<String, Object?>> resp = await _dio.post<Map<String, Object?>>(
        '/recognition',
        data: form,
        options: Options(contentType: 'multipart/form-data'),
      );
      return RecognitionResult.fromJson(resp.data ?? const <String, Object?>{});
    });
  }

  /// 保存一餐(API §4.11)。
  Future<MealEntry> saveMeal({
    required MealType mealType,
    required String consumedAt,
    required String localDate,
    required RecognitionSource source,
    required List<MealItem> items,
    String? note,
  }) {
    return _guard(() async {
      final Response<Map<String, Object?>> resp = await _dio.post<Map<String, Object?>>(
        '/meals',
        data: <String, Object?>{
          'mealType': mealType.toJson(),
          'consumedAt': consumedAt,
          'localDate': localDate,
          'source': source.toJson(),
          'note': ?note,
          'items': items.map((MealItem i) => i.toJson()).toList(growable: false),
        },
      );
      return MealEntry.fromJson(resp.data ?? const <String, Object?>{});
    });
  }

  /// 日视图(API §4.12)。
  Future<List<MealEntry>> mealsByDate(String date) {
    return _guard(() async {
      final Response<Map<String, Object?>> resp = await _dio.get<Map<String, Object?>>(
        '/meals',
        queryParameters: <String, Object?>{'date': date},
      );
      final Map<String, Object?> data = resp.data ?? const <String, Object?>{};
      return ((data['entries'] as List<Object?>?) ?? const <Object?>[])
          .whereType<Map<String, Object?>>()
          .map(MealEntry.fromJson)
          .toList(growable: false);
    });
  }

  /// 删除餐次(API §4.13)。
  Future<void> deleteMeal(String id) {
    return _guard(() async {
      await _dio.delete<Object?>('/meals/$id');
    });
  }
}

final mealRepositoryProvider = Provider<MealRepository>(
  (Ref ref) => MealRepository(ref.watch(apiClientProvider)),
);

// ───────────────────────── Summary / Goal ─────────────────────────

class SummaryRepository {
  SummaryRepository(this._client);
  final ApiClient _client;
  Dio get _dio => _client.dio;

  Future<DailySummary> daily(String date) {
    return _guard(() async {
      final Response<Map<String, Object?>> resp = await _dio.get<Map<String, Object?>>(
        '/summary/daily',
        queryParameters: <String, Object?>{'date': date},
      );
      return DailySummary.fromJson(resp.data ?? const <String, Object?>{});
    });
  }

  Future<List<TrendDay>> trend({int days = 7}) {
    return _guard(() async {
      final Response<Map<String, Object?>> resp = await _dio.get<Map<String, Object?>>(
        '/summary/trend',
        queryParameters: <String, Object?>{'days': days},
      );
      final Map<String, Object?> data = resp.data ?? const <String, Object?>{};
      return ((data['days'] as List<Object?>?) ?? const <Object?>[])
          .whereType<Map<String, Object?>>()
          .map(TrendDay.fromJson)
          .toList(growable: false);
    });
  }
}

final summaryRepositoryProvider = Provider<SummaryRepository>(
  (Ref ref) => SummaryRepository(ref.watch(apiClientProvider)),
);

class GoalRepository {
  GoalRepository(this._client);
  final ApiClient _client;
  Dio get _dio => _client.dio;

  /// 当前生效目标(无则返回 null,API §4.16)。
  Future<Goal?> getGoal() {
    return _guard(() async {
      final Response<Map<String, Object?>> resp =
          await _dio.get<Map<String, Object?>>('/goal');
      final Map<String, Object?>? data = resp.data;
      if (data == null || data.isEmpty || data['targetKcal'] == null) return null;
      return Goal.fromJson(data);
    });
  }

  Future<Goal> putGoal(Goal goal) {
    return _guard(() async {
      final Response<Map<String, Object?>> resp = await _dio.put<Map<String, Object?>>(
        '/goal',
        data: goal.toJson(),
      );
      return Goal.fromJson(resp.data ?? const <String, Object?>{});
    });
  }

  /// Mifflin-St Jeor 估算(纯计算,API §4.17)。
  Future<int> estimate({
    required String sex,
    required int birthYear,
    required int heightCm,
    required int weightKg,
    required String activityLevel,
    required String goalType,
  }) {
    return _guard(() async {
      final Response<Map<String, Object?>> resp = await _dio.post<Map<String, Object?>>(
        '/goal/estimate',
        data: <String, Object?>{
          'sex': sex,
          'birthYear': birthYear,
          'heightCm': heightCm,
          'weightKg': weightKg,
          'activityLevel': activityLevel,
          'goalType': goalType,
        },
      );
      final Map<String, Object?> data = resp.data ?? const <String, Object?>{};
      return (data['estimatedKcal'] as num?)?.toInt() ?? 0;
    });
  }
}

final goalRepositoryProvider = Provider<GoalRepository>(
  (Ref ref) => GoalRepository(ref.watch(apiClientProvider)),
);
