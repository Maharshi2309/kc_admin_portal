import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/responsive_grid.dart';
import 'package:kc_admin_portal/features/leave/data/models/leave_models.dart';
import 'package:kc_admin_portal/shared/models/leave_balance_model.dart';

/// Leave type choice with each type's remaining balance for the chosen
/// employee, e.g. "Casual · 8 days left" (design board 09).
class LeaveTypeCards extends StatelessWidget {
  const LeaveTypeCards({
    required this.types,
    required this.balances,
    required this.selectedId,
    required this.onSelected,
    this.enabled = true,
    super.key,
  });

  final List<LeaveTypeModel> types;

  /// The employee's balances; empty until an employee is chosen.
  final List<LeaveBalanceModel> balances;
  final String? selectedId;
  final ValueChanged<String> onSelected;
  final bool enabled;

  static const double _minCardWidth = 120;

  String _balanceText(LeaveTypeModel type) {
    if (!type.hasBalance) return 'No balance';
    final balance = balances.where((b) => b.leaveTypeId == type.id).firstOrNull;
    final remaining = balance?.remaining;
    return remaining == null ? '—' : '${FormatUtils.days(remaining)} left';
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveGrid(
      minItemWidth: _minCardWidth,
      spacing: AppSpacing.s8,
      children: [
        for (final type in types)
          _TypeCard(
            name: type.name,
            balance: _balanceText(type),
            isSelected: type.id == selectedId,
            onTap: enabled ? () => onSelected(type.id) : null,
          ),
      ],
    );
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({
    required this.name,
    required this.balance,
    required this.isSelected,
    required this.onTap,
  });

  final String name;
  final String balance;
  final bool isSelected;
  final VoidCallback? onTap;

  static const double _selectedBorderWidth = 2;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: '$name, $balance',
      excludeSemantics: true,
      child: Material(
        color: isSelected ? AppColors.primarySubtle : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.borderStrong,
            width: isSelected ? _selectedBorderWidth : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.lgAll,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s12,
              vertical: AppSpacing.s10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s2,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyBold.copyWith(
                    color: isSelected ? AppColors.primary : null,
                  ),
                ),
                Text(
                  balance,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
