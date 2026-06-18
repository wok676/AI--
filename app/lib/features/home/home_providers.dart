import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/types.dart';
import '../../common/l10n_helpers.dart';
import '../data/repositories.dart';

/// 今日日期(本地,YYYY-MM-DD)。
String todayIso() => DateFmt.iso(DateTime.now());

/// 今日汇总(进度环,API §4.14)。FutureProvider.family by date 便于历史复用。
final dailySummaryProvider = FutureProvider.family<DailySummary, String>((
  Ref ref,
  String date,
) {
  return ref.watch(summaryRepositoryProvider).daily(date);
});

/// 某日餐次列表(API §4.12)。
final mealsByDateProvider = FutureProvider.family<List<MealEntry>, String>((
  Ref ref,
  String date,
) {
  return ref.watch(mealRepositoryProvider).mealsByDate(date);
});

/// 近 N 天趋势(API §4.15)。
final trendProvider = FutureProvider.family<List<TrendDay>, int>((
  Ref ref,
  int days,
) {
  return ref.watch(summaryRepositoryProvider).trend(days: days);
});
