import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_progress_bar.dart';
import 'package:kc_admin_portal/core/widgets/responsive_grid.dart';
import 'package:kc_admin_portal/shared/models/leave_balance_model.dart';

/// One card per leave type with the backend's quota, used and remaining
/// days (design board 05).
class LeaveBalanceCards extends StatelessWidget {
  const LeaveBalanceCards({required this.balances, super.key});

  final List<LeaveBalanceModel> balances;

  static const double _minCardWidth = 200;

  @override
  Widget build(BuildContext context) {
    return ResponsiveGrid(
      minItemWidth: _minCardWidth,
      children: [
        for (final balance in balances) _BalanceCard(balance: balance),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.balance});

  final LeaveBalanceModel balance;

  @override
  Widget build(BuildContext context) {
    final quota = balance.quota;
    final remaining = balance.remaining;
    final limited = quota != null && quota > 0 && remaining != null;
    final muted = AppTextStyles.caption.copyWith(color: AppColors.textMuted);

    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s20,
        vertical: AppSpacing.s18,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s10,
        children: [
          // The quota moves under the name when both don't fit.
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: AppSpacing.s8,
            children: [
              Text(
                balance.leaveType,
                style: AppTextStyles.smallSemibold.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                limited ? '${FormatUtils.count(quota)} / year' : 'As needed',
                style: muted,
              ),
            ],
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: AppSpacing.s6,
            children: [
              Text(
                FormatUtils.count(limited ? remaining : balance.used),
                style: AppTextStyles.statMedium,
              ),
              Text(
                limited ? 'days left' : 'days taken',
                style: AppTextStyles.small.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
          AppProgressBar(
            value: limited ? remaining / quota : 0,
            semanticLabel: limited
                ? '${FormatUtils.count(remaining)} of ${FormatUtils.count(quota)} days left'
                : null,
          ),
          Text(
            limited
                ? '${FormatUtils.count(balance.used)} used'
                : 'Not limited by balance',
            style: muted,
          ),
        ],
      ),
    );
  }
}
