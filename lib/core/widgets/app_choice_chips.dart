import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';

class AppChoice<T> {
  const AppChoice({required this.value, required this.label});

  final T value;
  final String label;
}

/// Single-select pill chips that wrap onto new lines
/// (reason-for-change and leave-reason pickers in the design).
class AppChoiceChips<T> extends StatelessWidget {
  const AppChoiceChips({
    required this.choices,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<AppChoice<T>> choices;
  final T? selected;
  final ValueChanged<T>? onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s8,
      runSpacing: AppSpacing.s8,
      children: [
        for (final choice in choices)
          ChoiceChip(
            label: Text(choice.label),
            selected: choice.value == selected,
            onSelected: onSelected == null
                ? null
                : (_) => onSelected!(choice.value),
            labelStyle: AppTextStyles.buttonSmall.copyWith(
              color: choice.value == selected
                  ? AppColors.primary
                  : AppColors.textPrimary,
            ),
          ),
      ],
    );
  }
}

/// Multi-select pill chips (e.g. weekly off days). Selected chips use the
/// same colours as [AppChoiceChips].
class AppMultiChoiceChips<T> extends StatelessWidget {
  const AppMultiChoiceChips({
    required this.choices,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final List<AppChoice<T>> choices;
  final Set<T> selected;
  final ValueChanged<Set<T>>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s8,
      runSpacing: AppSpacing.s8,
      children: [
        for (final choice in choices)
          FilterChip(
            label: Text(choice.label),
            selected: selected.contains(choice.value),
            showCheckmark: false,
            onSelected: onChanged == null
                ? null
                : (isOn) => onChanged!(
                    isOn
                        ? {...selected, choice.value}
                        : ({...selected}..remove(choice.value)),
                  ),
            labelStyle: AppTextStyles.buttonSmall.copyWith(
              color: selected.contains(choice.value)
                  ? AppColors.primary
                  : AppColors.textPrimary,
            ),
          ),
      ],
    );
  }
}
