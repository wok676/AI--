import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_dimens.dart';

/// 全局兜底 UI 构造器(宪法 §5:替换 Flutter 默认红屏,零白屏/零崩溃)。
///
/// 在 [main] 里赋给 `ErrorWidget.builder`。任何 build 期异常都渲染为可读的友好兜底,
/// 而非默认的灰/红错误盒子。文案走 i18n;若 l10n 尚不可用则用中性英文兜底。
class AppErrorBoundary {
  AppErrorBoundary._();

  static Widget fallback(FlutterErrorDetails details) {
    // 仅 debug 打印,release 不暴露任何堆栈(宪法 §5)。
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }
    return const _FallbackScaffold();
  }
}

class _FallbackScaffold extends StatelessWidget {
  const _FallbackScaffold();

  @override
  Widget build(BuildContext context) {
    // l10n 可能在极早期不可用;用 maybeOf 容错。
    // 极早期 localizations 可能不可用,用可空查找容错(绝不二次崩溃)。
    final AppLocalizations? l10n =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    final String message = l10n?.common_error_generic ??
        'Something went wrong. Please try again.';

    return Directionality(
      textDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(message, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
