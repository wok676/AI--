import 'package:dio/dio.dart';

import 'types.dart';

/// 把 dio 异常统一转为 [ApiError](messageKey 对齐 API §0.3),供 UI 转 i18n 文案。
/// 绝不向 UI 暴露堆栈或原始异常(宪法 §5)。
ApiError mapDioException(DioException e) {
  // 后端返回了结构化错误体 → 直接采用其 code/messageKey。
  final Object? data = e.response?.data;
  if (data is Map<String, Object?> && data['messageKey'] != null) {
    return ApiError.fromJson(data, fallbackStatus: e.response?.statusCode);
  }

  // 否则按异常类型/HTTP 状态归类到本地 messageKey。
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const ApiError.local(
        code: 'TIMEOUT',
        messageKey: 'common.error.timeout',
      );
    case DioExceptionType.connectionError:
      return const ApiError.local(
        code: 'NETWORK_ERROR',
        messageKey: 'common.error.network',
      );
    case DioExceptionType.badResponse:
      final int status = e.response?.statusCode ?? 500;
      return ApiError.local(
        statusCode: status,
        code: _codeForStatus(status),
        messageKey: _messageKeyForStatus(status),
      );
    case DioExceptionType.cancel:
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      return const ApiError.local(
        code: 'INTERNAL_ERROR',
        messageKey: 'common.error.generic',
      );
  }
}

String _codeForStatus(int status) => switch (status) {
  401 => 'AUTH_UNAUTHORIZED',
  403 => 'AUTH_FORBIDDEN',
  404 => 'RESOURCE_NOT_FOUND',
  504 => 'TIMEOUT',
  503 => 'NETWORK_ERROR',
  _ => 'INTERNAL_ERROR',
};

String _messageKeyForStatus(int status) => switch (status) {
  401 => 'errors.unauthorized',
  403 => 'errors.forbidden',
  404 => 'errors.notFound',
  504 => 'common.error.timeout',
  503 => 'common.error.network',
  _ => 'common.error.generic',
};
