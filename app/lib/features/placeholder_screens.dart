import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_dimens.dart';

/// T4 占位页:仅建好导航骨架与可复用结构,具体业务 UI 由 T5/T6 实现。
/// 每页 AppBar + 居中标题,文案全走 i18n(零硬编码)。
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title, this.showAppBar = true});

  final String title;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ? AppBar(title: Text(title)) : null,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      _PlaceholderScreen(title: AppLocalizations.of(context).appTitle, showAppBar: false);
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      _PlaceholderScreen(title: AppLocalizations.of(context).auth_login_title);
}

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      _PlaceholderScreen(title: AppLocalizations.of(context).home_today);
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      _PlaceholderScreen(title: AppLocalizations.of(context).history_tab_day);
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      _PlaceholderScreen(title: AppLocalizations.of(context).settings_profile);
}
