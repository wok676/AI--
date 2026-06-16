import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../api/types.dart';
import '../../common/l10n_helpers.dart';
import '../../common/widgets/app_snackbar.dart';
import '../../common/widgets/disclaimer_banner.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimens.dart';
import '../data/repositories.dart';
import '../home/home_providers.dart';

/// 当前生效目标 provider(进页预填)。
final _currentGoalProvider = FutureProvider<Goal?>((Ref ref) {
  return ref.watch(goalRepositoryProvider).getGoal();
});

/// 目标设定页(UI §5.6):手动 kcal + 「帮我估算」折叠区(Mifflin-St Jeor)+ 免责声明常驻。
class GoalScreen extends ConsumerStatefulWidget {
  const GoalScreen({super.key});

  @override
  ConsumerState<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends ConsumerState<GoalScreen> {
  final TextEditingController _kcal = TextEditingController();
  bool _saving = false;
  bool _prefilled = false;

  // 估算区
  bool _estimateOpen = false;
  String _sex = 'MALE';
  String _activity = 'MODERATE';
  String _goalType = 'MAINTAIN';
  final TextEditingController _age = TextEditingController();
  final TextEditingController _height = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  bool _estimating = false;
  int? _estimated;

  @override
  void dispose() {
    _kcal.dispose();
    _age.dispose();
    _height.dispose();
    _weight.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final int? target = int.tryParse(_kcal.text.trim());
    if (target == null || target <= 0) {
      AppSnackbar.showMessage(context, l10n.common_error_generic);
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(goalRepositoryProvider).putGoal(
            Goal(
              targetKcal: target,
              effectiveFrom: DateFmt.iso(DateTime.now()),
              source: _estimated != null && _estimated == target ? 'estimated' : 'manual',
            ),
          );
      ref.invalidate(dailySummaryProvider(todayIso()));
      ref.invalidate(_currentGoalProvider);
      if (mounted) {
        AppSnackbar.showMessage(context, l10n.goal_save_success);
        if (context.canPop()) context.pop();
      }
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _estimate() async {
    final int? age = int.tryParse(_age.text.trim());
    final int? height = int.tryParse(_height.text.trim());
    final int? weight = int.tryParse(_weight.text.trim());
    if (age == null || height == null || weight == null) {
      AppSnackbar.showMessage(context, AppLocalizations.of(context).common_error_generic);
      return;
    }
    setState(() => _estimating = true);
    try {
      final int kcal = await ref.read(goalRepositoryProvider).estimate(
            sex: _sex,
            birthYear: DateTime.now().year - age,
            heightCm: height,
            weightKg: weight,
            activityLevel: _activity,
            goalType: _goalType,
          );
      setState(() => _estimated = kcal);
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, e);
    } finally {
      if (mounted) setState(() => _estimating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<Goal?> current = ref.watch(_currentGoalProvider);

    // 预填当前目标(仅一次)。
    current.whenData((Goal? g) {
      if (!_prefilled && g != null && _kcal.text.isEmpty) {
        _kcal.text = g.targetKcal.round().toString();
        _prefilled = true;
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.goal_title)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: <Widget>[
          // —— 大数字输入 ——
          TextField(
            controller: _kcal,
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
            decoration: InputDecoration(labelText: l10n.goal_field_kcal),
          ),
          const SizedBox(height: AppSpacing.md),

          // —— 帮我估算(折叠)——
          Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.calculate_outlined),
                  title: Text(l10n.goal_estimate_cta),
                  trailing: Icon(_estimateOpen ? Icons.expand_less : Icons.expand_more),
                  onTap: () => setState(() => _estimateOpen = !_estimateOpen),
                ),
                if (_estimateOpen) _buildEstimatePanel(l10n),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),
          // —— 固定免责声明(§7.4)——
          DisclaimerBanner(text: l10n.goal_disclaimer),
          const SizedBox(height: AppSpacing.sm),

          FilledButton(
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(AppSizes.buttonHeightCta),
            ),
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.onPrimary),
                  )
                : Text(l10n.common_save),
          ),
        ],
      ),
    );
  }

  Widget _buildEstimatePanel(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 性别
          Text(l10n.goal_sex_label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            children: <Widget>[
              ChoiceChip(
                label: Text(l10n.goal_sex_male),
                selected: _sex == 'MALE',
                onSelected: (_) => setState(() => _sex = 'MALE'),
              ),
              ChoiceChip(
                label: Text(l10n.goal_sex_female),
                selected: _sex == 'FEMALE',
                onSelected: (_) => setState(() => _sex = 'FEMALE'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _age,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: l10n.goal_field_age),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextField(
                  controller: _height,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: l10n.goal_field_height),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextField(
                  controller: _weight,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: l10n.goal_field_weight),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // 活动量
          Text(l10n.goal_field_activity, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: AppSpacing.xs),
          DropdownButtonFormField<String>(
            initialValue: _activity,
            items: <DropdownMenuItem<String>>[
              DropdownMenuItem<String>(value: 'SEDENTARY', child: Text(l10n.goal_activity_sedentary)),
              DropdownMenuItem<String>(value: 'LIGHT', child: Text(l10n.goal_activity_light)),
              DropdownMenuItem<String>(value: 'MODERATE', child: Text(l10n.goal_activity_moderate)),
              DropdownMenuItem<String>(value: 'ACTIVE', child: Text(l10n.goal_activity_active)),
              DropdownMenuItem<String>(value: 'VERY_ACTIVE', child: Text(l10n.goal_activity_veryActive)),
            ],
            onChanged: (String? v) => setState(() => _activity = v ?? _activity),
          ),
          const SizedBox(height: AppSpacing.sm),
          // 目标类型
          Text(l10n.goal_type_label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            children: <Widget>[
              ChoiceChip(
                label: Text(l10n.goal_type_lose),
                selected: _goalType == 'LOSE',
                onSelected: (_) => setState(() => _goalType = 'LOSE'),
              ),
              ChoiceChip(
                label: Text(l10n.goal_type_maintain),
                selected: _goalType == 'MAINTAIN',
                onSelected: (_) => setState(() => _goalType = 'MAINTAIN'),
              ),
              ChoiceChip(
                label: Text(l10n.goal_type_gain),
                selected: _goalType == 'GAIN',
                onSelected: (_) => setState(() => _goalType = 'GAIN'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (_estimated != null) ...<Widget>[
            Text(l10n.goal_estimate_result(_estimated!),
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(color: AppColors.primary)),
            const SizedBox(height: AppSpacing.xs),
            OutlinedButton(
              onPressed: () => setState(() => _kcal.text = _estimated!.toString()),
              child: Text(l10n.goal_estimate_apply),
            ),
          ] else
            OutlinedButton(
              onPressed: _estimating ? null : _estimate,
              child: _estimating
                  ? const SizedBox(
                      width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(l10n.goal_estimate_cta),
            ),
        ],
      ),
    );
  }
}
