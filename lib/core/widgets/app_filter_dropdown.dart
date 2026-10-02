import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_focus.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/widgets/app_dropdown.dart';

/// Table-toolbar filter chip: "Department  All ▾". Highlights when a value is
/// selected; `null` means no filter ("All").
///
/// With [allLabel] set to `null` there is no "All" option and the chip never
/// highlights: a plain compact picker (e.g. rows per page).
class AppFilterDropdown<T> extends StatelessWidget {
  const AppFilterDropdown({
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    this.allLabel = 'All',
    super.key,
  });

  final String label;
  final List<AppDropdownItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? allLabel;

  @override
  Widget build(BuildContext context) {
    final selectedLabel = items
        .where((item) => item.value == value)
        .map((item) => item.label)
        .firstOrNull;
    final isActive = allLabel != null && value != null && selectedLabel != null;

    return MenuAnchor(
      menuChildren: [
        if (allLabel != null)
          _option(label: allLabel!, isSelected: value == null, value: null),
        for (final item in items)
          _option(
            label: item.label,
            isSelected: item.value == value,
            value: item.value,
          ),
      ],
      builder: (context, controller, _) => AppFilterChipButton(
        label: label,
        valueLabel: selectedLabel ?? allLabel ?? '',
        isActive: isActive,
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
    );
  }

  Widget _option({
    required String label,
    required bool isSelected,
    required T? value,
  }) {
    return MenuItemButton(
      onPressed: () => onChanged(value),
      trailingIcon: isSelected
          ? const Icon(Icons.check_rounded, size: AppSizes.iconSmall)
          : null,
      child: Text(label),
    );
  }
}

/// The "Label  Value ▾" chip used by toolbar filters.
class AppFilterChipButton extends StatelessWidget {
  const AppFilterChipButton({
    super.key,
    required this.label,
    required this.valueLabel,
    required this.isActive,
    required this.onPressed,
  });

  final String label;
  final String valueLabel;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final foreground = isActive ? AppColors.primary : AppColors.textPrimary;

    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size(0, AppSizes.chipHeight)),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: AppSpacing.s12),
        ),
        shape: const WidgetStatePropertyAll(StadiumBorder()),
        side: AppFocus.side(
          base: BorderSide(
            color: isActive ? AppColors.primary : AppColors.borderStrong,
          ),
        ),
        backgroundColor: WidgetStatePropertyAll(
          isActive ? AppColors.primarySoft : AppColors.surface,
        ),
        foregroundColor: WidgetStatePropertyAll(foreground),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // On narrow screens or with large text the chip is capped at the
          // available width and the labels end with an ellipsis.
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.small.copyWith(
                color: isActive ? AppColors.primary : AppColors.textMuted,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s6),
          Flexible(
            child: Text(
              valueLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.buttonSmall.copyWith(color: foreground),
            ),
          ),
          const SizedBox(width: AppSpacing.s4),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: AppSizes.iconSmall,
          ),
        ],
      ),
    );
  }
}
