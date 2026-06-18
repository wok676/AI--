import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/test_keys.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/locale_controller.dart';
import '../../l10n/supported_locales.dart';
import '../../theme/app_colors.dart';

/// 语言选择器(UI §5.7):12 语言 + 「跟随系统」。
/// 当前语言高亮(check + primaryContainer);切到 ar/ur 即时 RTL 重布局(无需重启,PRD §4.8.3)。
class LanguagePickerScreen extends ConsumerWidget {
  const LanguagePickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final LocaleState state = ref.watch(localeControllerProvider);
    final LocaleController controller = ref.read(localeControllerProvider.notifier);
    final bool followingSystem = state.isFollowingSystem;
    final String currentCode = state.effective.languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings_language_title)),
      body: ListView(
        children: <Widget>[
          // 跟随系统
          _LangTile(
            key: const ValueKey<String>(TestKeys.languageOptionSystem),
            label: l10n.settings_language_systemDefault,
            selected: followingSystem,
            onTap: () => controller.followSystem(),
          ),
          const Divider(height: 1),
          for (final Locale locale in SupportedLocales.all)
            _LangTile(
              key: ValueKey<String>(TestKeys.languageOption(locale.languageCode)),
              label: SupportedLocales.nativeNames[locale.languageCode] ?? locale.languageCode,
              selected: !followingSystem && currentCode == locale.languageCode,
              onTap: () => controller.setLocale(locale),
            ),
        ],
      ),
    );
  }
}

class _LangTile extends StatelessWidget {
  const _LangTile(
      {super.key,
      required this.label,
      required this.selected,
      required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: selected ? AppColors.primaryContainer : null,
      // 语言名以本语言书写,局部按其文字方向渲染避免 BiDi 乱序。
      title: Text(label),
      trailing: selected
          ? const Icon(Icons.check, color: AppColors.onPrimaryContainer)
          : null,
      onTap: onTap,
    );
  }
}
