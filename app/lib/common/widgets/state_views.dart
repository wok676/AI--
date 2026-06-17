import 'package:flutter/material.dart';

import '../../api/types.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/message_key.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimens.dart';

/// 空态(UI §3.9)。插画位先用图标占位(具体插画资产 T5/T6 接入)。
class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
    this.actionIcon,
  });

  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  /// 主 CTA 可选前缀图标(如「记录一餐」配相机图标,视觉增强)。
  final IconData? actionIcon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // 更精致的图标插画:图标 + 浅色强调圆底组合(视觉增强,纯代码绘制)。
            _EmptyIllustration(icon: icon),
            const SizedBox(height: AppSpacing.lg),
            Text(message, textAlign: TextAlign.center, style: theme.textTheme.titleMedium),
            if (actionLabel != null && onAction != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: onAction,
                icon: Icon(actionIcon ?? Icons.add),
                label: Text(actionLabel!),
                style: FilledButton.styleFrom(
                  elevation: AppElevation.level2,
                  minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 空态插画:外层浅 primaryContainer 圆底 + 内层白色圆 + 主图标,层次柔和。
class _EmptyIllustration extends StatelessWidget {
  const _EmptyIllustration({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: 132,
      height: 132,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.45),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 92,
        height: 92,
        decoration: const BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 44, color: theme.colorScheme.primary),
      ),
    );
  }
}

/// 错误态(UI §3 / §6:messageKey → i18n + 重试)。
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    // 统一把任何异常翻成 i18n 文案:ApiError 用其 messageKey,否则通用错误。
    final String message = error is ApiError
        ? l10n.byMessageKey((error as ApiError).messageKey)
        : l10n.common_error_generic;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.error_outline, size: 56, color: theme.colorScheme.error),
            const SizedBox(height: AppSpacing.md),
            Text(message, textAlign: TextAlign.center, style: theme.textTheme.bodyLarge),
            if (onRetry != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.common_retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
