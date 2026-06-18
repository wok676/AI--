import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_dimens.dart';

/// 启动页(UI §4.1):会话恢复期间停留(router redirect 解析完成后跳转)。
/// 极简品牌占位,绝不卡白屏。
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Image.asset(
                'assets/icon/icon.png',
                width: 96,
                height: 96,
                filterQuality: FilterQuality.medium,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.appTitle, style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.lg),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ),
      ),
    );
  }
}
