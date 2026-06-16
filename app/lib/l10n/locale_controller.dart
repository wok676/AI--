import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/secure_storage.dart';
import 'supported_locales.dart';

/// 语言偏好状态。
/// [override] 为 null 表示「跟随系统」(UI §5.7 settings.language.systemDefault);
/// 非 null 表示用户手动选择,实时生效、无需重启(PRD §4.8.3)。
@immutable
class LocaleState {
  const LocaleState({required this.override});

  /// 用户手动覆盖的 locale;null = 跟随系统。
  final Locale? override;

  /// 解析出当前生效 locale:手动优先,否则取系统首选,最终收敛/回退 en。
  Locale get effective {
    if (override != null) return SupportedLocales.resolve(override);
    final List<Locale> system = PlatformDispatcher.instance.locales;
    for (final Locale s in system) {
      final Locale resolved = SupportedLocales.resolve(s);
      if (resolved.languageCode == s.languageCode) return resolved;
    }
    return SupportedLocales.fallback;
  }

  bool get isFollowingSystem => override == null;
}

/// 语言偏好持久化键(非敏感偏好,允许用安全存储统一管理)。
const String _kLocaleKey = 'pref.locale.override';

/// 语言控制器:加载持久化偏好 → 暴露切换/重置。
class LocaleController extends StateNotifier<LocaleState> {
  LocaleController(this._storage) : super(const LocaleState(override: null)) {
    _restore();
  }

  final SecureStorage _storage;

  Future<void> _restore() async {
    try {
      final String? code = await _storage.read(_kLocaleKey);
      if (code != null && code.isNotEmpty) {
        state = LocaleState(override: SupportedLocales.resolve(Locale(code)));
      }
    } catch (_) {
      // 读取失败不致命:保持跟随系统,绝不崩溃(宪法 §1.2)。
      state = const LocaleState(override: null);
    }
  }

  /// 手动切换到指定语言(实时生效)。
  Future<void> setLocale(Locale locale) async {
    final Locale resolved = SupportedLocales.resolve(locale);
    state = LocaleState(override: resolved);
    try {
      await _storage.write(_kLocaleKey, resolved.languageCode);
    } catch (_) {
      // 持久化失败不影响本次切换。
    }
  }

  /// 重置为「跟随系统」。
  Future<void> followSystem() async {
    state = const LocaleState(override: null);
    try {
      await _storage.delete(_kLocaleKey);
    } catch (_) {}
  }
}

final localeControllerProvider =
    StateNotifierProvider<LocaleController, LocaleState>((Ref ref) {
  return LocaleController(ref.watch(secureStorageProvider));
});
