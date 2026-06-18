import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../l10n/locale_controller.dart';
import '../storage/token_store.dart';
import 'error_mapper.dart';
import 'types.dart';

/// 统一 API client(宪法 §5):dio 实例 + 拦截器集中处理
/// ① 注入 Authorization / Accept-Language;② 超时;③ 网络抖动重试;
/// ④ 401 自动 refresh 重放;⑤ 所有错误 → [ApiError](messageKey,UI 转 i18n)。
class ApiClient {
  // ignore_for_file: prefer_initializing_formals
  ApiClient({
    required TokenStore tokenStore,
    required String Function() acceptLanguage,
    Dio? dio,
  }) : _tokenStore = tokenStore,
       _acceptLanguage = acceptLanguage,
       _dio = dio ?? Dio() {
    _dio.options
      ..baseUrl = AppConfig.apiRoot
      ..connectTimeout = const Duration(
        milliseconds: AppConfig.connectTimeoutMs,
      )
      ..receiveTimeout = const Duration(
        milliseconds: AppConfig.receiveTimeoutMs,
      )
      ..headers['Content-Type'] = 'application/json';

    _dio.interceptors.add(
      InterceptorsWrapper(onRequest: _onRequest, onError: _onError),
    );
  }

  final Dio _dio;
  final TokenStore _tokenStore;
  final String Function() _acceptLanguage;

  /// 防止并发 401 触发多次刷新。
  Future<bool>? _refreshing;

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // ② Accept-Language:当前生效 locale(后端按此渲染 messageKey,API §0)。
    options.headers['Accept-Language'] = _acceptLanguage();

    // ① Authorization:公开端点(标记 skipAuth)不注入。
    final bool skipAuth = options.extra['skipAuth'] == true;
    if (!skipAuth) {
      final String? access = await _tokenStore.readAccessToken();
      if (access != null && access.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $access';
      }
    }
    handler.next(options);
  }

  Future<void> _onError(DioException e, ErrorInterceptorHandler handler) async {
    final RequestOptions req = e.requestOptions;

    // ④ 401 且非刷新请求本身 → 尝试刷新一次并重放。
    final bool isAuthEndpoint = req.path.startsWith('/auth/');
    if (e.response?.statusCode == 401 &&
        !isAuthEndpoint &&
        req.extra['retried401'] != true) {
      final bool ok = await _refreshToken();
      if (ok) {
        try {
          req.extra['retried401'] = true;
          final Response<Object?> retried = await _dio.fetch<Object?>(req);
          return handler.resolve(retried);
        } catch (_) {
          // 重放仍失败 → 继续走错误流程。
        }
      }
    }

    // ③ 幂等 GET 的网络/超时抖动重试。
    if (_shouldRetry(e)) {
      final int attempt = (req.extra['retryAttempt'] as int?) ?? 0;
      if (attempt < AppConfig.maxRetries) {
        req.extra['retryAttempt'] = attempt + 1;
        await Future<void>.delayed(Duration(milliseconds: 300 * (attempt + 1)));
        try {
          final Response<Object?> retried = await _dio.fetch<Object?>(req);
          return handler.resolve(retried);
        } catch (_) {
          // 落入下方统一错误映射。
        }
      }
    }

    // ⑤ 统一转 ApiError(messageKey)。
    handler.reject(e.copyWith(error: mapDioException(e)));
  }

  bool _shouldRetry(DioException e) {
    final bool idempotent = e.requestOptions.method.toUpperCase() == 'GET';
    final bool transient =
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError ||
        (e.response?.statusCode == 503);
    return idempotent && transient;
  }

  /// 刷新 token(并发去重)。成功后写回 secure storage。
  Future<bool> _refreshToken() {
    return _refreshing ??= () async {
      try {
        final String? refresh = await _tokenStore.readRefreshToken();
        if (refresh == null || refresh.isEmpty) return false;
        final Response<Map<String, Object?>> resp = await _dio
            .post<Map<String, Object?>>(
              '/auth/refresh',
              data: <String, Object?>{'refreshToken': refresh},
              options: Options(extra: <String, Object?>{'skipAuth': true}),
            );
        final Map<String, Object?> data =
            resp.data ?? const <String, Object?>{};
        final AuthSession session = AuthSession.fromJson(data);
        if (session.accessToken.isEmpty) return false;
        await _tokenStore.saveSession(session);
        return true;
      } catch (_) {
        // 刷新失败 → 清凭证(调用方据 401 引导回登录)。
        await _tokenStore.clear();
        return false;
      } finally {
        _refreshing = null;
      }
    }();
  }

  /// 暴露底层 dio 供 T5/T6 的 repository 调用(GET/POST/multipart 等)。
  Dio get dio => _dio;
}

/// 提供当前生效 locale 的 languageCode 作为 Accept-Language。
final apiClientProvider = Provider<ApiClient>((Ref ref) {
  return ApiClient(
    tokenStore: ref.watch(tokenStoreProvider),
    acceptLanguage: () =>
        ref.read(localeControllerProvider).effective.languageCode,
  );
});
