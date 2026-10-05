import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_link.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/dashboard_summary_model.dart';

/// Organisation-wide leave (all figures from the backend): Casual left,
/// Casual and Unpaid taken this year, and this month's requests by status.
/// Unpaid leave is never counted as remaining paid leave.
class LeaveUsageCard extends StatelessWidget {
  const LeaveUsageCard({
    required this.usage,
    required this.onViewBalances,
    super.key,
  });

  final LeaveUsageModel usage;

  /// Null hides the link (the user can't open Leaves).
  final VoidCallback? onViewBalances;

  @override
  Widget build(BuildContext context) {
    final remaining = FormatUtils.days(usage.casualRemainingDays);
    final muted = AppTextStyles.small.copyWith(color: AppColors.textMuted);

    return SectionCard(
      title: 'Leave · ${usage.year}',
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s24,
        vertical: AppSpacing.s20,
      ),
      gap: AppSpacing.s14,
      trailing: onViewBalances == null
          ? null
          : AppLink(label: 'Balances', onPressed: onViewBalances),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s14,
        children: [
          Semantics(
            label: '$remaining of Casual leave left, all employees',
            excludeSemantics: true,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: AppSpacing.s8,
              children: [
                Text(remaining, style: AppTextStyles.statLarge),
                Text('of Casual leave left · all employees', style: muted),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _Figure(
                  label: 'Casual taken',
                  value: FormatUtils.days(usage.casualTakenDays),
                ),
              ),
              Expanded(
                child: _Figure(
                  label: 'Unpaid taken',
                  value: FormatUtils.days(usage.unpaidTakenDays),
                ),
              ),
            ],
          ),
          const Divider(height: 1, color: AppColors.border),
          Text('Requests this month', style: muted),
          Row(
            children: [
              Expanded(
                child: _Figure(
                  label: 'Approved',
                  value: FormatUtils.count(usage.approvedThisMonth),
                ),
              ),
              Expanded(
                child: _Figure(
                  label: 'Pending',
                  value: FormatUtils.count(usage.pendingThisMonth),
                ),
              ),
              Expanded(
                child: _Figure(
                  label: 'Rejected',
                  value: FormatUtils.count(usage.rejectedThisMonth),
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
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.s2,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
          ),
          Text(value, style: AppTextStyles.statXSmall),
        ],
      ),
    );
  }
}
