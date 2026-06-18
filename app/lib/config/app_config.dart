/// 运行时配置(宪法 §6:配置走 .env,仓库不含真值)。
///
/// Flutter 用编译期 --dart-define 注入(EAS/CI 从环境读取),不硬编码密钥/URL。
/// 例:flutter run --dart-define=API_BASE_URL=https://api.example.com
abstract final class AppConfig {
  AppConfig._();

  /// 后端 API 基址(含到 /api 前缀);版本前缀 /v1 由 client 拼接(API §0)。
  /// 默认指向本地开发后端,生产由 --dart-define 覆盖。
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );

  static const String apiVersion = 'v1';

  /// 完整 API 根:.../api/v1
  static String get apiRoot => '$apiBaseUrl/$apiVersion';

  /// 网络超时(ms),可由 --dart-define 覆盖。
  /// 连接超时放宽到 45s:免费 PaaS(如 Render)实例休眠后冷启动需 ~40s 才能接受连接,
  /// 10s 会导致"休眠后首开必失败(网络异常)";放宽后首开虽慢但能成功(§5 容错)。
  static const int connectTimeoutMs = int.fromEnvironment(
    'API_CONNECT_TIMEOUT_MS',
    defaultValue: 45000,
  );
  static const int receiveTimeoutMs = int.fromEnvironment(
    'API_RECEIVE_TIMEOUT_MS',
    defaultValue: 20000,
  );

  /// AI 识别(文字/图片)专用接收超时:AI 推理 + 中转往返延迟波动大(实测 4~15s+,
  /// 偶发更久),普通 20s 会**误杀有效请求**导致"识别失败"。给识别单独放宽到 60s。
  static const int recognizeReceiveTimeoutMs = int.fromEnvironment(
    'API_RECOGNIZE_RECEIVE_TIMEOUT_MS',
    defaultValue: 60000,
  );

  /// 失败重试次数(幂等 GET / 网络抖动)。
  static const int maxRetries = int.fromEnvironment(
    'API_MAX_RETRIES',
    defaultValue: 2,
  );
}
