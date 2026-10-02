import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/features/leave/data/models/leave_models.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

/// "All 48 · Pending 3 · Approved 41 · Rejected 2 · Cancelled 2" tabs
/// (design board 08). Counts come from the backend; scrolls sideways on
/// narrow screens.
class LeaveStatusTabs extends StatelessWidget {
  const LeaveStatusTabs({
    required this.counts,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final LeaveStatusCounts counts;

  /// `null` = All.
  final LeaveStatus? selected;
  final ValueChanged<LeaveStatus?> onSelected;

  static const List<LeaveStatus?> _tabs = [
    null,
    LeaveStatus.pending,
    LeaveStatus.approved,
    LeaveStatus.rejected,
    LeaveStatus.cancelled,
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: AppSpacing.s6,
        children: [
          for (final status in _tabs)
            _Tab(
              label: status?.label ?? 'All',
              count: counts.of(status),
              isSelected: status == selected,
              onTap: () => onSelected(status),
            ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = isSelected ? AppColors.primary : AppColors.textSecondary;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$label, ${FormatUtils.count(count)}',
      excludeSemantics: true,
      child: Material(
        color: isSelected ? AppColors.primarySoft : Colors.transparent,
        borderRadius: AppRadius.mdAll,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mdAll,
          child: Container(
            constraints: const BoxConstraints(minHeight: AppSizes.buttonHeight),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.s8,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodySemibold.copyWith(color: foreground),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s6,
                    vertical: AppSpacing.s2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.surface : AppColors.neutralBg,
                    borderRadius: AppRadius.pillAll,
                  ),
                  child: Text(
                    FormatUtils.count(count),
                    style: AppTextStyles.captionBold.copyWith(
                      color: foreground,
                    ),
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
