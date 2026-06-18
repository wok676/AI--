import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/types.dart';
import '../../common/l10n_helpers.dart';
import '../../common/test_keys.dart';
import '../../common/widgets/app_gradient_background.dart';
import '../../common/widgets/macro_bars.dart';
import '../../common/widgets/progress_ring.dart';
import '../../common/widgets/skeleton.dart';
import '../../common/widgets/state_views.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/locale_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimens.dart';
import '../capture/capture_flow.dart';
import 'home_providers.dart';

/// 首页 Today(UI §5.2):进度环 + 三宏量条 + 餐次卡列表 + 拍照 FAB。
/// 三态齐全(加载骨架优先 / 空态插画 / 错误重试)。
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String date = todayIso();
    final String localeCode = ref.watch(localeControllerProvider).effective.languageCode;
    final DateTime now = DateTime.now();

    // 避免同屏出现两个同义主操作(空态中部 CTA + 右下 FAB):
    // 空态(当日无记录)只保留中部 CTA、隐藏 FAB;有数据/加载/错误时保留 FAB。
    final AsyncValue<List<MealEntry>> mealsForFab = ref.watch(mealsByDateProvider(date));
    final bool showFab = mealsForFab.maybeWhen(
      data: (List<MealEntry> list) => list.isNotEmpty,
      orElse: () => true,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(l10n.home_today),
      ),
      floatingActionButton: showFab
          ? FloatingActionButton.extended(
              key: const ValueKey<String>(TestKeys.recordMealBtn),
              onPressed: () => CaptureFlow.showMethodSheet(context, ref),
              icon: const Icon(Icons.photo_camera),
              label: Text(l10n.home_fab_addMeal),
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
            )
          : null,
      body: AppGradientBackground(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(dailySummaryProvider(date));
            ref.invalidate(mealsByDateProvider(date));
            await ref.read(dailySummaryProvider(date).future).catchError((_) {
              return const DailySummary(
                date: '', goalKcal: 0, consumedKcal: 0, remainingKcal: 0,
                proteinG: 0, carbsG: 0, fatG: 0,
              );
            });
          },
          child: ListView(
            key: const ValueKey<String>(TestKeys.todayScreen),
            padding: const EdgeInsets.all(AppSpacing.md),
            children: <Widget>[
              // 按时段问候条:早上好/下午好/晚上好 👋 · 已格式化日期(视觉增强)。
              _GreetingBar(now: now, localeCode: localeCode),
              const SizedBox(height: AppSpacing.lg),
              _SummarySection(date: date),
              const SizedBox(height: AppSpacing.lg),
              _MealsSection(date: date),
              const SizedBox(height: AppSpacing.xxl), // 给 FAB 留出空间
            ],
          ),
        ),
      ),
    );
  }
}

/// 问候条:按本地时间判断时段选用对应 i18n 文案 + 格式化日期。
class _GreetingBar extends StatelessWidget {
  const _GreetingBar({required this.now, required this.localeCode});
  final DateTime now;
  final String localeCode;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final int h = now.hour;
    final String greeting = h >= 5 && h < 12
        ? l10n.home_greeting_morning
        : (h >= 12 && h < 18
            ? l10n.home_greeting_afternoon
            : l10n.home_greeting_evening);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(greeting, style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          DateFmt.medium(now, localeCode),
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _SummarySection extends ConsumerWidget {
  const _SummarySection({required this.date});
  final String date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<DailySummary> summary = ref.watch(dailySummaryProvider(date));

    return summary.when(
      skipLoadingOnReload: true,
      loading: () => const _SummarySkeleton(),
      error: (Object e, _) => SizedBox(
        height: 280,
        child: ErrorView(
          error: e,
          onRetry: () => ref.invalidate(dailySummaryProvider(date)),
        ),
      ),
      data: (DailySummary s) {
        final int remaining = (s.goalKcal - s.consumedKcal).round();
        return Column(
          children: <Widget>[
            ProgressRing(
              key: const ValueKey<String>(TestKeys.todayProgressRing),
              consumed: s.consumedKcal,
              goal: s.goalKcal,
              centerTop: s.consumedKcal.round().toString(),
              centerBottom: s.goalKcal > 0
                  ? '/ ${s.goalKcal.round()} ${l10n.summary_unit_kcal}'
                  : l10n.summary_goalNotSet,
              subtitle: s.goalKcal > 0 && remaining > 0
                  ? l10n.summary_remaining(remaining)
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            MacroBars(
              proteinLabel: l10n.recognize_item_protein,
              carbsLabel: l10n.recognize_item_carbs,
              fatLabel: l10n.recognize_item_fat,
              proteinG: s.proteinG,
              carbsG: s.carbsG,
              fatG: s.fatG,
            ),
          ],
        );
      },
    );
  }
}

class _MealsSection extends ConsumerWidget {
  const _MealsSection({required this.date});
  final String date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<List<MealEntry>> meals = ref.watch(mealsByDateProvider(date));

    return meals.when(
      skipLoadingOnReload: true,
      loading: () => const _MealsSkeleton(),
      error: (Object e, _) => ErrorView(
        error: e,
        onRetry: () => ref.invalidate(mealsByDateProvider(date)),
      ),
      data: (List<MealEntry> list) {
        if (list.isEmpty) {
          return EmptyView(
            key: const ValueKey<String>(TestKeys.todayEmptyCta),
            message: l10n.home_empty_cta,
            icon: Icons.restaurant_outlined,
            actionLabel: l10n.home_fab_addMeal,
            actionIcon: Icons.photo_camera,
            onAction: () => CaptureFlow.showMethodSheet(context, ref),
          );
        }
        return Column(
          children: <Widget>[
            for (final MealEntry m in list) ...<Widget>[
              _MealCard(entry: m),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        );
      },
    );
  }
}

class _MealCard extends StatelessWidget {
  const _MealCard({required this.entry});
  final MealEntry entry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: <Widget>[
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: const Icon(Icons.restaurant, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(l10n.mealTypeLabel(entry.mealType),
                      style: theme.textTheme.titleMedium),
                  Text(l10n.today_mealItemCount(entry.items.length),
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: AppColors.onSurfaceVariant)),
                ],
              ),
            ),
            Text(
              '${entry.totalKcal.round()} ${l10n.summary_unit_kcal}',
              style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── 骨架(UI §3.10,RTL 自动反向) ─────────────────────────

class _SummarySkeleton extends StatelessWidget {
  const _SummarySkeleton();
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        Skeleton.circle(diameter: AppSizes.progressRingDiameter),
        SizedBox(height: AppSpacing.lg),
        Skeleton(width: double.infinity, height: 24),
      ],
    );
  }
}

class _MealsSkeleton extends StatelessWidget {
  const _MealsSkeleton();
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        Skeleton(width: double.infinity, height: 72, radius: AppRadius.md),
        SizedBox(height: AppSpacing.sm),
        Skeleton(width: double.infinity, height: 72, radius: AppRadius.md),
        SizedBox(height: AppSpacing.sm),
        Skeleton(width: double.infinity, height: 72, radius: AppRadius.md),
      ],
    );
  }
}
