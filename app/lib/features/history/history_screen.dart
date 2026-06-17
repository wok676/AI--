import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/types.dart';
import '../../common/l10n_helpers.dart';
import '../../common/widgets/app_snackbar.dart';
import '../../common/widgets/skeleton.dart';
import '../../common/widgets/state_views.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/locale_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimens.dart';
import '../data/repositories.dart';
import '../home/home_providers.dart';

/// 历史 / 趋势页(UI §5.5):SegmentedButton 切日/趋势。
/// 日视图:日期选择 + 餐次列表(可删);趋势:近 7 天柱状(fl_chart)。
/// 三态齐全;RTL 下日期箭头与图表方向镜像。
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

enum _HistoryTab { day, trend }

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  _HistoryTab _tab = _HistoryTab.day;
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.history_title)),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: SegmentedButton<_HistoryTab>(
              segments: <ButtonSegment<_HistoryTab>>[
                ButtonSegment<_HistoryTab>(
                    value: _HistoryTab.day, label: Text(l10n.history_tab_day)),
                ButtonSegment<_HistoryTab>(
                    value: _HistoryTab.trend, label: Text(l10n.history_tab_trend)),
              ],
              selected: <_HistoryTab>{_tab},
              onSelectionChanged: (Set<_HistoryTab> s) =>
                  setState(() => _tab = s.first),
            ),
          ),
          Expanded(
            child: _tab == _HistoryTab.day
                ? _DayView(
                    day: _selectedDay,
                    onChangeDay: (DateTime d) => setState(() => _selectedDay = d),
                  )
                : const _TrendView(),
          ),
        ],
      ),
    );
  }
}

class _DayView extends ConsumerWidget {
  const _DayView({required this.day, required this.onChangeDay});
  final DateTime day;
  final ValueChanged<DateTime> onChangeDay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String localeCode = ref.watch(localeControllerProvider).effective.languageCode;
    final String date = DateFmt.iso(day);
    final AsyncValue<List<MealEntry>> meals = ref.watch(mealsByDateProvider(date));

    return Column(
      children: <Widget>[
        // 日期选择器(◀▶ 箭头在 RTL 自动镜像,UI §8.2)。
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () => onChangeDay(day.subtract(const Duration(days: 1))),
              icon: const Icon(Icons.chevron_left),
              tooltip: l10n.history_prevDay,
            ),
            Text(DateFmt.medium(day, localeCode),
                style: Theme.of(context).textTheme.titleMedium),
            IconButton(
              onPressed: () => onChangeDay(day.add(const Duration(days: 1))),
              icon: const Icon(Icons.chevron_right),
              tooltip: l10n.history_nextDay,
            ),
          ],
        ),
        Expanded(
          child: meals.when(
            skipLoadingOnReload: true,
            loading: () => const _ListSkeleton(),
            error: (Object e, _) => ErrorView(
              error: e,
              onRetry: () => ref.invalidate(mealsByDateProvider(date)),
            ),
            data: (List<MealEntry> list) {
              if (list.isEmpty) {
                return EmptyView(message: l10n.common_empty);
              }
              return ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: list.length,
                separatorBuilder: (BuildContext _, int _) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (BuildContext ctx, int i) => _DayMealCard(
                  entry: list[i],
                  date: date,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DayMealCard extends ConsumerWidget {
  const _DayMealCard({required this.entry, required this.date});
  final MealEntry entry;
  final String date;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        content: Text(l10n.meal_delete_confirm),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.common_cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(mealRepositoryProvider).deleteMeal(entry.id);
      ref.invalidate(mealsByDateProvider(date));
      ref.invalidate(dailySummaryProvider(date));
      if (context.mounted) AppSnackbar.showMessage(context, l10n.meal_delete_success);
    } catch (e) {
      if (context.mounted) AppSnackbar.showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: <Widget>[
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
            Text('${entry.totalKcal.round()} ${l10n.summary_unit_kcal}',
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: theme.colorScheme.primary)),
            IconButton(
              onPressed: () => _delete(context, ref),
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              tooltip: l10n.common_delete,
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendView extends ConsumerWidget {
  const _TrendView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String localeCode = ref.watch(localeControllerProvider).effective.languageCode;
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final AsyncValue<List<TrendDay>> trend = ref.watch(trendProvider(7));

    return trend.when(
      skipLoadingOnReload: true,
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Skeleton(width: double.infinity, height: 220, radius: AppRadius.md),
      ),
      error: (Object e, _) =>
          ErrorView(error: e, onRetry: () => ref.invalidate(trendProvider(7))),
      data: (List<TrendDay> days) {
        if (days.isEmpty) return EmptyView(message: l10n.common_empty);
        // RTL:X 轴右→左(最近在 start),反转展示顺序(UI §8.2)。
        final List<TrendDay> ordered = isRtl ? days.reversed.toList() : days;
        final double maxY = ordered.fold<double>(
              0,
              (double m, TrendDay d) =>
                  d.consumedKcal > m ? d.consumedKcal.toDouble() : m,
            ) *
            1.2;

        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(l10n.history_trend_title,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 240,
                child: BarChart(
                  BarChartData(
                    maxY: maxY <= 0 ? 100 : maxY,
                    alignment: BarChartAlignment.spaceAround,
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            final int idx = value.toInt();
                            if (idx < 0 || idx >= ordered.length) {
                              return const SizedBox.shrink();
                            }
                            final DateTime? d =
                                DateTime.tryParse(ordered[idx].date);
                            return Padding(
                              padding: const EdgeInsets.only(top: AppSpacing.xxs),
                              child: Text(
                                d == null ? '' : DateFmt.shortDay(d, localeCode),
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: <BarChartGroupData>[
                      for (int i = 0; i < ordered.length; i++)
                        BarChartGroupData(
                          x: i,
                          barRods: <BarChartRodData>[
                            BarChartRodData(
                              toY: ordered[i].consumedKcal.toDouble(),
                              color: AppColors.primary,
                              width: 16,
                              borderRadius: BorderRadius.circular(AppRadius.xs),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: <Widget>[
                  _LegendDot(color: AppColors.primary, label: l10n.history_trend_caloriesLegend),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(width: 12, height: 12, decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(AppRadius.xs))),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: const <Widget>[
        Skeleton(width: double.infinity, height: 72, radius: AppRadius.md),
        SizedBox(height: AppSpacing.sm),
        Skeleton(width: double.infinity, height: 72, radius: AppRadius.md),
      ],
    );
  }
}
