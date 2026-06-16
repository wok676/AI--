import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'common/widgets/app_error_boundary.dart';

/// 入口(宪法 §1.2/§5:零崩溃 / 零白屏)。
/// - runZonedGuarded 捕获所有未处理的异步异常;
/// - FlutterError.onError 捕获框架同步错误;
/// - ErrorWidget.builder 替换默认红屏为友好兜底 UI。
void main() {
  runZonedGuarded<void>(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      // build 期异常 → 友好兜底而非红屏/白屏。
      ErrorWidget.builder = AppErrorBoundary.fallback;

      // 框架同步错误:debug 打印,release 静默(绝不泄露堆栈,§5)。
      FlutterError.onError = (FlutterErrorDetails details) {
        if (kDebugMode) {
          FlutterError.presentError(details);
        }
        // TODO(T7/devops): 上报到崩溃监控(脱敏,不含 PII/token)。
      };

      runApp(const ProviderScope(child: CalorieApp()));
    },
    (Object error, StackTrace stack) {
      // 未处理的异步异常兜底:debug 打印,release 静默上报,绝不崩溃。
      if (kDebugMode) {
        debugPrint('Uncaught zone error: $error');
      }
      // TODO(T7/devops): 上报到崩溃监控。
    },
  );
}
