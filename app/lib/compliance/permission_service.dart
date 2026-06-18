import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

/// 权限申请结果(供 UI 决定降级路径)。
enum PermissionOutcome {
  granted,
  denied, // 本次拒绝,可再次询问
  permanentlyDenied, // 永久拒绝 → 引导去系统设置(perm.openSettings)
}

/// 【权限按需索取 + 优雅降级】(宪法 §1.2 / PRD §4.3)。
///
/// 强约束:
/// - **绝不在启动时盲目索取**;每个权限仅在用户主动触发对应功能时申请(用时再申)。
/// - 系统权限弹窗前,UI 须先弹**自定义前置解释弹窗**(perm.*),用户点「允许」后才调本服务。
/// - 被拒绝**绝不闪退**:返回 outcome 让 UI 降级(改用其他录入方式 / 引导去设置)。
/// - 不申请定位/麦克风/通讯录等与核心无关的权限(PRD §4.3)。
class PermissionService {
  const PermissionService();

  /// 相机权限(用户点「拍照」时,F1)。
  Future<PermissionOutcome> requestCamera() => _request(Permission.camera);

  /// 相册/照片权限(用户点「相册」时,F2)。
  Future<PermissionOutcome> requestPhotos() => _request(Permission.photos);

  /// 通知权限(开通知开关 / 首次保存后询问一次,Should)。
  Future<PermissionOutcome> requestNotifications() => _request(Permission.notification);

  /// 仅**查询**是否已授权(不触发系统弹窗)。用于"仅首次解释"——
  /// 已授权则跳过前置解释弹窗,直接走功能(§7.3)。
  Future<bool> hasCamera() => _isGranted(Permission.camera);
  Future<bool> hasPhotos() => _isGranted(Permission.photos);
  Future<bool> hasNotifications() => _isGranted(Permission.notification);

  Future<bool> _isGranted(Permission permission) async {
    try {
      final PermissionStatus status = await permission.status;
      return status.isGranted || status.isLimited;
    } catch (_) {
      return false;
    }
  }

  Future<PermissionOutcome> _request(Permission permission) async {
    try {
      final PermissionStatus status = await permission.request();
      if (status.isGranted || status.isLimited) return PermissionOutcome.granted;
      if (status.isPermanentlyDenied || status.isRestricted) {
        return PermissionOutcome.permanentlyDenied;
      }
      return PermissionOutcome.denied;
    } catch (_) {
      // 任何原生异常都降级为「拒绝」,绝不崩溃(宪法 §1.2)。
      return PermissionOutcome.denied;
    }
  }

  /// 永久拒绝后引导去系统设置(对应 perm.openSettings)。
  Future<void> openSettings() async {
    try {
      await openAppSettings();
    } catch (_) {
      // 打开设置失败不致命。
    }
  }
}

final permissionServiceProvider =
    Provider<PermissionService>((Ref ref) => const PermissionService());
