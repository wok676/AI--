import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../api/types.dart';
import '../../common/l10n_helpers.dart';
import '../../common/test_keys.dart';
import '../../common/widgets/app_snackbar.dart';
import '../../common/widgets/disclaimer_banner.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/message_key.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimens.dart';
import '../data/repositories.dart';
import '../home/home_providers.dart';

/// 识别确认页入参(经 go_router extra 传递)。
class RecognitionConfirmArgs {
  const RecognitionConfirmArgs({required this.result, required this.source});
  final RecognitionResult result;
  final RecognitionSource source;
}

/// 低置信度阈值(UI §5.4:< 此值显示 recognize.lowConfidence 标记)。
const double _kLowConfidence = 0.6;

/// AI 识别结果确认页(UI §5.4 核心页 / PRD F4-F8)。
/// - 可编辑食物项卡片(改名/调份量/删项/手动加项);
/// - 固定免责声明常驻(recognize.disclaimer,§7.4);
/// - 餐次 ChoiceChip(默认 suggestedMealType);
/// - 确认 → POST /meals → 回首页刷新;保存失败 messageKey 提示不崩。
class RecognitionConfirmScreen extends ConsumerStatefulWidget {
  const RecognitionConfirmScreen({super.key, required this.args});
  final RecognitionConfirmArgs args;

  @override
  ConsumerState<RecognitionConfirmScreen> createState() =>
      _RecognitionConfirmScreenState();
}

class _RecognitionConfirmScreenState
    extends ConsumerState<RecognitionConfirmScreen> {
  late List<MealItem> _items;
  late MealType _mealType;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _items = widget.args.result.items
        .map(MealItem.fromRecognized)
        .toList(growable: true);
    _mealType = widget.args.result.suggestedMealType;
  }

  num get _totalKcal =>
      _items.fold<num>(0, (num sum, MealItem i) => sum + i.kcal);

  Future<void> _save() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    if (_items.isEmpty) {
      AppSnackbar.showMessage(context, l10n.recognize_emptyItems);
      return;
    }
    setState(() => _saving = true);
    try {
      final DateTime now = DateTime.now();
      await ref
          .read(mealRepositoryProvider)
          .saveMeal(
            mealType: _mealType,
            consumedAt: now.toUtc().toIso8601String(),
            localDate: DateFmt.iso(now),
            source: widget.args.source,
            items: _items,
          );
      // 刷新今日首页数据。
      final String today = todayIso();
      ref.invalidate(dailySummaryProvider(today));
      ref.invalidate(mealsByDateProvider(today));
      if (mounted) {
        AppSnackbar.showMessage(context, l10n.recognize_save_success);
        // 回到 Today(弹出确认页栈)。
        if (context.canPop()) {
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _editItem(int index) async {
    final MealItem? edited = await showModalBottomSheet<MealItem>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) => _ItemEditorSheet(item: _items[index]),
    );
    if (edited != null) setState(() => _items[index] = edited);
  }

  Future<void> _addManual() async {
    const MealItem template = MealItem(
      name: '',
      quantity: 1,
      unit: 'serving',
      kcal: 0,
      proteinG: 0,
      carbsG: 0,
      fatG: 0,
      isManual: true,
    );
    final MealItem? added = await showModalBottomSheet<MealItem>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) => const _ItemEditorSheet(item: template),
    );
    if (added != null) setState(() => _items.add(added));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.recognize_result_title)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: <Widget>[
          // —— 可编辑食物项卡列表 ——
          for (int i = 0; i < _items.length; i++) ...<Widget>[
            _ItemCard(
              item: _items[i],
              onEdit: () => _editItem(i),
              onDelete: () => setState(() => _items.removeAt(i)),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],

          // —— 手动添加一项 ——
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              key: const ValueKey<String>(TestKeys.recognitionAddManualBtn),
              onPressed: _saving ? null : _addManual,
              icon: const Icon(Icons.add),
              label: Text(l10n.recognize_item_addManual),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // —— 餐次选择(ChoiceChip,默认 suggestedMealType)——
          Text(
            l10n.recognize_mealType_label,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            children: <Widget>[
              for (final MealType t in MealType.values)
                ChoiceChip(
                  label: Text(l10n.mealTypeLabel(t)),
                  selected: _mealType == t,
                  onSelected: _saving
                      ? null
                      : (_) => setState(() => _mealType = t),
                ),
            ],
          ),

          const Divider(height: AppSpacing.lg),

          // —— 固定免责声明条(常驻,§7.4)——
          DisclaimerBanner(
            text: l10n.byMessageKey(widget.args.result.disclaimerKey),
          ),
          const SizedBox(height: AppSpacing.sm),

          // —— 保存 ——
          FilledButton(
            key: const ValueKey<String>(TestKeys.recognitionSaveBtn),
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(AppSizes.buttonHeightCta),
            ),
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.onPrimary,
                    ),
                  )
                : Text(
                    '${l10n.common_save}  ·  ${_totalKcal.round()} ${l10n.summary_unit_kcal}',
                  ),
          ),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  final MealItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool lowConfidence =
        item.confidence != null && item.confidence! < _kLowConfidence;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    item.name.isEmpty ? l10n.recognize_field_name : item.name,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                  tooltip: l10n.common_edit,
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  tooltip: l10n.common_delete,
                ),
              ],
            ),
            Text(
              '${l10n.recognize_item_serving}: ${item.quantity} ${l10n.unitLabel(item.unit)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            // 数值用 LTR 局部包裹避免 BiDi 乱序(UI §8.3)。
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                '${item.kcal.round()} ${l10n.summary_unit_kcal} · '
                'P${item.proteinG.round()} C${item.carbsG.round()} F${item.fatG.round()}',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            if (lowConfidence) ...<Widget>[
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.warning_amber,
                    size: 16,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Expanded(
                    child: Text(
                      l10n.recognize_lowConfidence,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 食物项编辑底部抽屉(改名/份量/单位/热量/宏量)。
class _ItemEditorSheet extends StatefulWidget {
  const _ItemEditorSheet({required this.item});
  final MealItem item;

  @override
  State<_ItemEditorSheet> createState() => _ItemEditorSheetState();
}

class _ItemEditorSheetState extends State<_ItemEditorSheet> {
  late final TextEditingController _name = TextEditingController(
    text: widget.item.name,
  );
  late final TextEditingController _qty = TextEditingController(
    text: _trimNum(widget.item.quantity),
  );
  late final TextEditingController _kcal = TextEditingController(
    text: _trimNum(widget.item.kcal),
  );
  late final TextEditingController _protein = TextEditingController(
    text: _trimNum(widget.item.proteinG),
  );
  late final TextEditingController _carbs = TextEditingController(
    text: _trimNum(widget.item.carbsG),
  );
  late final TextEditingController _fat = TextEditingController(
    text: _trimNum(widget.item.fatG),
  );
  late String _unit = widget.item.unit.isEmpty ? 'serving' : widget.item.unit;

  static String _trimNum(num v) =>
      v == v.roundToDouble() ? v.round().toString() : v.toString();

  @override
  void dispose() {
    _name.dispose();
    _qty.dispose();
    _kcal.dispose();
    _protein.dispose();
    _carbs.dispose();
    _fat.dispose();
    super.dispose();
  }

  num _parse(TextEditingController c) => num.tryParse(c.text.trim()) ?? 0;

  void _confirm() {
    final MealItem result = widget.item.copyWith(
      name: _name.text.trim(),
      quantity: _parse(_qty),
      unit: _unit,
      kcal: _parse(_kcal),
      proteinG: _parse(_protein),
      carbsG: _parse(_carbs),
      fatG: _parse(_fat),
    );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    const List<String> units = <String>['serving', 'piece', 'g'];

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              l10n.recognize_editItem_title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _name,
              decoration: InputDecoration(labelText: l10n.recognize_field_name),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _qty,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.recognize_field_quantity,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: units.contains(_unit) ? _unit : 'serving',
                    decoration: InputDecoration(
                      labelText: l10n.recognize_field_unit,
                    ),
                    items: <DropdownMenuItem<String>>[
                      for (final String u in units)
                        DropdownMenuItem<String>(
                          value: u,
                          child: Text(l10n.unitLabel(u)),
                        ),
                    ],
                    onChanged: (String? v) =>
                        setState(() => _unit = v ?? _unit),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _kcal,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.recognize_item_calories,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _protein,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.recognize_item_protein,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: TextField(
                    controller: _carbs,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.recognize_item_carbs,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: TextField(
                    controller: _fat,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.recognize_item_fat,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.common_cancel),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton(
                    onPressed: _confirm,
                    child: Text(l10n.common_save),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
