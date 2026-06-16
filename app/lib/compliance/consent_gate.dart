import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/secure_storage.dart';

/// 【隐私合规拦截】——第三方 SDK 初始化前置同意闸门(宪法 §1 / PRD §4.1/§4.7)。
///
/// 设计意图:
/// - v1 明确「无广告 / 无第三方追踪 / 无第三方分析」(PRD §4.4),因此当前**没有任何**
///   第三方 SDK 需要初始化。但合规策略要求:**在用户主动勾选同意《隐私政策》之前,
///   任何第三方 SDK(广告 / 分析 / 推送)的初始化都必须被本地拦截并静默。**
/// - 本闸门即为该策略的**唯一强制落地点**:未来若接入任何第三方 SDK,其 init 必须、
///   且只能经由 [runIfConsented] 调用;在 [hasConsented] 为 false 时静默跳过(no-op),
///   绝不在同意前触发任何数据收集。
///
/// 关键不变量:
/// - 同意状态由注册时的显式勾选写入(后端二次校验 consentAccepted,API §4.1),
///   客户端缓存一份用于 SDK 闸门判断。
/// - 同意默认 false(未勾选不得预置);严禁「点击即同意」的隐式路径写入此状态。
class ConsentGate {
  ConsentGate(this._storage);

  final SecureStorage _storage;

  static const String _kConsentKey = 'compliance.privacyConsent';
  static const String _kConsentVersionKey = 'compliance.privacyConsentVersion';

  /// 是否已获得隐私同意。读失败一律视为「未同意」(从严,绝不放行 SDK)。
  Future<bool> hasConsented() async {
    try {
      return (await _storage.read(_kConsentKey)) == 'true';
    } catch (_) {
      return false;
    }
  }

  /// 记录用户**主动勾选**的同意(注册成功后调用)。
  /// [version] 对齐 API 注册请求的 consentVersion,便于政策更新后重新征求。
  Future<void> grantConsent({required String version}) async {
    await _storage.write(_kConsentKey, 'true');
    await _storage.write(_kConsentVersionKey, version);
  }

  /// 撤回同意 / 注销时清除(回到「同意前」状态,第三方 SDK 重新被拦截)。
  Future<void> revokeConsent() async {
    await _storage.delete(_kConsentKey);
    await _storage.delete(_kConsentVersionKey);
  }

  /// 仅在已同意时执行第三方 SDK 初始化等带数据收集的副作用;
  /// 未同意则**静默拦截**(no-op),不抛异常、不收集任何数据。
  ///
  /// 用法(未来接入任意第三方 SDK 时):
  ///   await consentGate.runIfConsented(() async { await SomeAnalytics.init(); });
  Future<void> runIfConsented(Future<void> Function() thirdPartySdkInit) async {
    if (await hasConsented()) {
      await thirdPartySdkInit();
    }
    // else: 同意前静默拦截 —— 不初始化、不上报、不收集(合规红线)。
  }
}

final consentGateProvider = Provider<ConsentGate>(
  (Ref ref) => ConsentGate(ref.watch(secureStorageProvider)),
);
