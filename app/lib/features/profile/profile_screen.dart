import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../api/types.dart';
import '../../common/test_keys.dart';
import '../../common/widgets/app_gradient_background.dart';
import '../../common/widgets/app_snackbar.dart';
import '../../common/widgets/skeleton.dart';
import '../../common/widgets/state_views.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/locale_controller.dart';
import '../../l10n/supported_locales.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimens.dart';
import '../auth/auth_controller.dart';
import '../data/repositories.dart';
import 'account_delete_dialog.dart';

/// 当前用户资料 provider(GET /me)。
final meProvider = FutureProvider<MeProfile>((Ref ref) {
  return ref.watch(meRepositoryProvider).getMe();
});

/// 个人中心 / 设置页(UI §5.7):资料 + 目标 + 通知 + 单位 + 语言 + 协议/隐私/关于
/// + 退出登录 + **显著的注销入口(error 色,不隐藏)**。
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<MeProfile> me = ref.watch(meProvider);
    final LocaleState localeState = ref.watch(localeControllerProvider);
    final String currentLang = localeState.isFollowingSystem
        ? l10n.settings_language_systemDefault
        : (SupportedLocales.nativeNames[localeState.effective.languageCode] ?? '');

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(l10n.settings_profile),
      ),
      body: AppGradientBackground(
        child: me.when(
        skipLoadingOnReload: true,
        loading: () => const _ProfileSkeleton(),
        error: (Object e, _) =>
            ErrorView(error: e, onRetry: () => ref.invalidate(meProvider)),
        data: (MeProfile profile) => ListView(
          key: const ValueKey<String>(TestKeys.profileScreen),
          children: <Widget>[
            // —— 头像 + 昵称:浅色卡片质感(头像圆底 + 名称),视觉增强 ——
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.person,
                            color: AppColors.onPrimaryContainer, size: 28),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(profile.username,
                            style: Theme.of(context).textTheme.titleLarge),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // —— 设置项 ——
            // (移除原"个人资料"行:无对应详情/编辑页,点击空操作;用户资料已在上方头像卡展示。)
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: Text(l10n.goal_title),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.goal),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.notifications_outlined),
              title: Text(l10n.settings_notifications),
              value: profile.notifyEnabled,
              onChanged: (bool v) => _toggleNotify(context, ref, v),
            ),
            _UnitsTile(profile: profile),
            ListTile(
              key: const ValueKey<String>(TestKeys.languageEntry),
              leading: const Icon(Icons.language),
              title: Text(l10n.settings_language),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(currentLang,
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: AppColors.onSurfaceVariant)),
                  const Icon(Icons.chevron_right),
                ],
              ),
              onTap: () => context.push(AppRoutes.language),
            ),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: Text(l10n.settings_terms),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.legalTerms),
            ),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: Text(l10n.settings_privacy),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.legalPrivacy),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.settings_about),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),

            const Divider(height: 1),
            // —— 退出登录 ——
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: OutlinedButton(
                key: const ValueKey<String>(TestKeys.logoutBtn),
                onPressed: () => _logout(context, ref),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
                ),
                child: Text(l10n.auth_logout),
              ),
            ),

            // —— 注销账号(error 色,显著不隐藏,§7.2;居中略小,仍带警告图标保持可发现)——
            Center(
              child: TextButton.icon(
                key: const ValueKey<String>(TestKeys.deleteAccountBtn),
                onPressed: () => AccountDeleteFlow.show(context, ref),
                icon: const Icon(Icons.warning_amber, size: 18, color: AppColors.error),
                label: Text(
                  l10n.account_delete_entry,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: AppColors.error),
                ),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
      ),
    );
  }

  Future<void> _toggleNotify(BuildContext context, WidgetRef ref, bool value) async {
    try {
      await ref.read(meRepositoryProvider).patchMe(<String, Object?>{'notifyEnabled': value});
      ref.invalidate(meProvider);
    } catch (e) {
      if (context.mounted) AppSnackbar.showError(context, e);
    }
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        content: Text(l10n.logout_confirm),
        // 取消与确认两按钮视觉等权(参考注销弹窗风格,避免取消是不起眼小链接):
        // 取消用 OutlinedButton 更可见,确认用 FilledButton,两者同高、左右平衡。
        actionsPadding: const EdgeInsets.all(AppSpacing.md),
        actions: <Widget>[
          OutlinedButton(
            key: const ValueKey<String>(TestKeys.logoutCancelBtn),
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.common_cancel),
          ),
          const SizedBox(width: AppSpacing.sm),
          FilledButton(
            key: const ValueKey<String>(TestKeys.logoutConfirmBtn),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.auth_logout),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(authControllerProvider.notifier).logout();
      // router redirect 自动回登录页。
    } catch (e) {
      if (context.mounted) AppSnackbar.showError(context, e);
    }
  }
}

/// 单位偏好行(能量 kcal/kJ + 质量 g/oz),内联切换写回 PATCH /me。
class _UnitsTile extends ConsumerWidget {
  const _UnitsTile({required this.profile});
  final MeProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return ExpansionTile(
      leading: const Icon(Icons.straighten),
      title: Text(l10n.settings_units),
      childrenPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      children: <Widget>[
        _UnitRow(
          label: l10n.settings_units_energy,
          options: <(String, String)>[
            ('kcal', l10n.settings_units_kcal),
            ('kJ', l10n.settings_units_kj),
          ],
          current: profile.unitEnergy,
          onSelect: (String v) => _patch(context, ref, <String, Object?>{'unitEnergy': v}),
        ),
        _UnitRow(
          label: l10n.settings_units_mass,
          options: <(String, String)>[
            ('g', l10n.settings_units_g),
            ('oz', l10n.settings_units_oz),
          ],
          current: profile.unitMass,
          onSelect: (String v) => _patch(context, ref, <String, Object?>{'unitMass': v}),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }

  Future<void> _patch(
      BuildContext context, WidgetRef ref, Map<String, Object?> patch) async {
    try {
      await ref.read(meRepositoryProvider).patchMe(patch);
      ref.invalidate(meProvider);
    } catch (e) {
      if (context.mounted) AppSnackbar.showError(context, e);
    }
  }
}

class _UnitRow extends StatelessWidget {
  const _UnitRow({
    required this.label,
    required this.options,
    required this.current,
    required this.onSelect,
  });

  final String label;
  final List<(String, String)> options;
  final String current;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label)),
          Wrap(
            spacing: AppSpacing.xs,
            children: <Widget>[
              for (final (String value, String text) in options)
                ChoiceChip(
                  label: Text(text),
                  selected: current == value,
                  onSelected: (_) => onSelect(value),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();
  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey<String>(TestKeys.stateLoading),
      padding: const EdgeInsets.all(AppSpacing.md),
      children: const <Widget>[
        Skeleton(width: double.infinity, height: 64, radius: AppRadius.md),
        SizedBox(height: AppSpacing.md),
        Skeleton(width: double.infinity, height: 56, radius: AppRadius.sm),
        SizedBox(height: AppSpacing.sm),
        Skeleton(width: double.infinity, height: 56, radius: AppRadius.sm),
        SizedBox(height: AppSpacing.sm),
        Skeleton(width: double.infinity, height: 56, radius: AppRadius.sm),
      ],
    );
  }
}
