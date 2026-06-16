import 'package:intl/intl.dart';

import '../api/types.dart';
import '../l10n/app_localizations.dart';

/// 把契约枚举/单位映射到 i18n 文案,集中一处避免散落 switch(宪法 §7 零硬编码)。
extension MealTypeL10n on AppLocalizations {
  String mealTypeLabel(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return meal_breakfast;
      case MealType.lunch:
        return meal_lunch;
      case MealType.dinner:
        return meal_dinner;
      case MealType.snack:
        return meal_snack;
    }
  }

  /// 食物份量单位文案(契约 unit 字符串 → i18n)。未知单位回落原始串。
  String unitLabel(String unit) {
    switch (unit) {
      case 'serving':
        return recognize_item_serving_unit_serving;
      case 'piece':
        return recognize_item_serving_unit_piece;
      case 'g':
      case 'gram':
        return recognize_item_serving_unit_gram;
      default:
        return unit;
    }
  }
}

/// 日期本地化(Intl,按 locale 格式化,宪法 §7)。
abstract final class DateFmt {
  DateFmt._();

  /// YYYY-MM-DD(API 入参用,locale 无关)。
  static String iso(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// 友好展示(如 Jun 16,按 locale)。
  static String medium(DateTime d, String localeCode) =>
      DateFormat.MMMd(localeCode).format(d);

  /// 趋势 X 轴短标签(如 6/16)。
  static String shortDay(DateTime d, String localeCode) =>
      DateFormat.Md(localeCode).format(d);
}
