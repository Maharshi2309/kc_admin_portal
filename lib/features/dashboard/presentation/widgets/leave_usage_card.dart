import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_link.dart';
import 'package:kc_admin_portal/core/widgets/app_progress_bar.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/dashboard_summary_model.dart';

/// Organisation-wide leave used this year (all figures from the backend).
class LeaveUsageCard extends StatelessWidget {
  const LeaveUsageCard({
    required this.usage,
    required this.onViewLeaves,
    super.key,
  });

  final LeaveUsageModel usage;

  /// Null hides the link (the role can't open Leaves).
  final VoidCallback? onViewLeaves;

  static const double _percentPerFraction = 100;

  @override
  Widget build(BuildContext context) {
    final percent = FormatUtils.percent(usage.usedPercent);

    return SectionCard(
      title: 'Leave used · ${usage.year}',
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s24,
        vertical: AppSpacing.s20,
      ),
      gap: AppSpacing.s14,
      trailing: onViewLeaves == null
          ? null
          : AppLink(label: 'Leaves', onPressed: onViewLeaves),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s14,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: AppSpacing.s8,
            children: [
              Text(percent, style: AppTextStyles.statLarge),
              Text(
                'of all leave used',
                style: AppTextStyles.small.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
          AppProgressBar(
            value: usage.usedPercent / _percentPerFraction,
            thick: true,
            semanticLabel: '$percent of all leave used',
          ),
          Row(
            children: [
              Expanded(
                child: _Figure(
                  label: 'Taken',
                  value: FormatUtils.days(usage.takenDays),
                ),
              ),
              Expanded(
                child: _Figure(
                  label: 'Remaining',
                  value: FormatUtils.days(usage.remainingDays),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s2,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
        ),
        Text(value, style: AppTextStyles.statXSmall),
      ],
    );
  }
}
