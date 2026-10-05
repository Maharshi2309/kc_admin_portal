import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_progress_bar.dart';
import 'package:kc_admin_portal/core/widgets/responsive_grid.dart';
import 'package:kc_admin_portal/shared/models/leave_balance_model.dart';

/// The employee's Casual balance (earned, used, pending, remaining) and the
/// Unpaid days taken, as calculated by the backend (design board 05).
class LeaveBalanceCards extends StatelessWidget {
  const LeaveBalanceCards({required this.balance, super.key});

  final LeaveBalanceModel balance;

  static const double _minCardWidth = 200;

  @override
  Widget build(BuildContext context) {
    return ResponsiveGrid(
      minItemWidth: _minCardWidth,
      children: [
        _BalanceCard(
          title: 'Casual leave',
          note: '1 day earned each month',
          value: balance.remaining,
          unit: 'left',
          progress: balance.accrued > 0
              ? (balance.remaining / balance.accrued).clamp(0, 1).toDouble()
              : 0,
          progressLabel:
              '${FormatUtils.count(balance.remaining)} of '
              '${FormatUtils.days(balance.accrued)} left',
          footer: [
            '${FormatUtils.count(balance.accrued)} earned',
            '${FormatUtils.count(balance.used)} used',
            if (balance.pending > 0)
              '${FormatUtils.count(balance.pending)} pending',
          ].join(' · '),
        ),
        _BalanceCard(
          title: 'Unpaid leave',
          note: 'No fixed balance',
          value: balance.unpaidTaken,
          unit: 'taken',
          footer: 'Not paid · not limited by balance',
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.title,
    required this.note,
    required this.value,
    required this.unit,
    required this.footer,
    this.progress,
    this.progressLabel,
  });

  final String title;
  final String note;
  final double value;

  /// "left" or "taken", after "N day(s)".
  final String unit;
  final String footer;
  final double? progress;
  final String? progressLabel;

  @override
  Widget build(BuildContext context) {
    final muted = AppTextStyles.caption.copyWith(color: AppColors.textMuted);
    final count = FormatUtils.count(value);

    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s20,
        vertical: AppSpacing.s18,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s10,
        children: [
          // The note moves under the title when both don't fit.
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: AppSpacing.s8,
            children: [
              Text(
                title,
                style: AppTextStyles.smallSemibold.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(note, style: muted),
            ],
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: AppSpacing.s6,
            children: [
              Text(count, style: AppTextStyles.statMedium),
              Text(
                '${value == 1 ? 'day' : 'days'} $unit',
                style: AppTextStyles.small.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
          AppProgressBar(value: progress ?? 0, semanticLabel: progressLabel),
          Text(footer, style: muted),
        ],
      ),
    );
  }
}
