import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/test_keys.dart';
import '../../l10n/app_localizations.dart';

/// 已登录主框架:底部 NavigationBar 3 Tab(UI §4.1)。
/// Tab 顺序 LTR=Today/History/Profile;RTL 由 NavigationBar 自动反序(UI §8.2)。
/// 此处仅搭骨架,各 Tab 页内容由 T5/T6 填充。
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  /// go_router StatefulNavigationShell:每个 Tab 独立导航栈。
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        key: const ValueKey<String>(TestKeys.navBar),
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (int index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: <NavigationDestination>[
          NavigationDestination(
            key: const ValueKey<String>(TestKeys.tabToday),
            icon: const Icon(Icons.today_outlined),
            selectedIcon: const Icon(Icons.today),
            label: l10n.home_today,
          ),
          NavigationDestination(
            key: const ValueKey<String>(TestKeys.tabHistory),
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history),
            label: l10n.history_title,
          ),
          NavigationDestination(
            key: const ValueKey<String>(TestKeys.tabProfile),
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.settings_profile,
          ),
        ],
      ),
    );
  }
}
