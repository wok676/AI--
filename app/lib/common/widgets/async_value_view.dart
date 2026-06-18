import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'state_views.dart';

/// 三态通用视图(宪法 §5:加载/空/错误三态齐全),基于 Riverpod [AsyncValue]。
///
/// - loading → [skeleton](默认圈,鼓励各页传入骨架屏 widget,UI §3.10);
/// - error   → [ErrorView](messageKey 转 i18n + 重试);
/// - data    → 若 [isEmpty] 判定为空则显示 [EmptyView],否则 [data] 构建内容。
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    super.key,
    required this.value,
    required this.data,
    this.skeleton,
    this.isEmpty,
    this.emptyMessage,
    this.emptyIcon = Icons.inbox_outlined,
    this.emptyActionLabel,
    this.onEmptyAction,
    this.onRetry,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;

  /// 加载态自定义骨架(强烈建议传以贴合真实布局);不传则用居中转圈。
  final Widget? skeleton;

  /// 判定 data 是否为空(如空列表)。返回 true 显示空态。
  final bool Function(T data)? isEmpty;
  final String? emptyMessage;
  final IconData emptyIcon;
  final String? emptyActionLabel;
  final VoidCallback? onEmptyAction;

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      loading: () =>
          skeleton ?? const Center(child: CircularProgressIndicator()),
      error: (Object e, _) => ErrorView(error: e, onRetry: onRetry),
      data: (T d) {
        if (isEmpty != null && isEmpty!(d)) {
          return EmptyView(
            message: emptyMessage ?? '',
            icon: emptyIcon,
            actionLabel: emptyActionLabel,
            onAction: onEmptyAction,
          );
        }
        return data(d);
      },
    );
  }
}
