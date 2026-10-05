import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_empty_view.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/core/widgets/responsive_data_view.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/employees/presentation/providers/employee_providers.dart';
import 'package:kc_admin_portal/shared/widgets/status_badges.dart';

/// An employee's leaves (design board 05), shown in the profile's history
/// card: dates, type with paid/unpaid, days, the Casual balance left after
/// each leave (from the backend), reason and status.
class LeaveHistoryList extends ConsumerWidget {
  const LeaveHistoryList({required this.employeeId, super.key});

  final String employeeId;

  /// The main columns fit from this width (reason, then balance drop
  /// first).
  static const double _tableMinWidth = 480;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(employeeLeaveHistoryProvider(employeeId));
    final muted = AppTextStyles.body.copyWith(color: AppColors.textMuted);

    return AsyncValueView<List<LeaveHistoryItemModel>>(
      value: history,
      compact: true,
      onRetry: () => ref.invalidate(employeeLeaveHistoryProvider(employeeId)),
      isEmpty: (items) => items.isEmpty,
      empty: const AppEmptyView(
        compact: true,
        icon: Icons.event_available_outlined,
        title: 'No leave taken yet',
      ),
      data: (items) => ResponsiveDataView<LeaveHistoryItemModel>(
        rows: items,
        rowKey: (item) => item.id,
        tableMinWidth: _tableMinWidth,
        mobileItemBuilder: (context, item) => _MobileItem(item: item),
        columns: [
          AppDataColumn(
            label: 'Dates',
            flex: 2,
            minWidth: 150,
            // The day count goes under the dates so "Balance after" fits
            // the profile's half-width card.
            cellBuilder: (context, item) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppDateFormat.range(item.startDate, item.endDate),
                  style: AppTextStyles.bodySemibold,
                ),
                Text(
                  FormatUtils.days(item.days),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          AppDataColumn(
            label: 'Type',
            minWidth: 90,
            cellBuilder: (context, item) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.leaveType),
                Text(
                  payLabel(item),
                  style: AppTextStyles.caption.copyWith(
                    color: item.isPaid
                        ? AppColors.textMuted
                        : AppColors.warningFg,
                  ),
                ),
              ],
            ),
          ),
          AppDataColumn(
            label: 'Balance after',
            // Fits the header on one line.
            minWidth: 140,
            priority: 1,
            cellBuilder: (context, item) => Text(
              balanceText(item) ?? '—',
              style: item.balanceAfter == null ? muted : null,
            ),
          ),
          AppDataColumn(
            label: 'Reason',
            flex: 2,
            minWidth: 140,
            priority: 2,
            cellBuilder: (context, item) => Text(
              item.reason ?? '—',
              overflow: TextOverflow.ellipsis,
              style: muted,
            ),
          ),
          AppDataColumn(
            label: 'Status',
            minWidth: 130,
            cellBuilder: (context, item) => LeaveStatusBadge(item.status),
          ),
        ],
      ),
    );
  }
}

/// "Paid" / "Not paid".
String payLabel(LeaveHistoryItemModel item) =>
    item.isPaid ? 'Paid' : 'Not paid';

/// "7 days left"; null when the leave doesn't use the Casual balance
/// (Unpaid, rejected or cancelled).
String? balanceText(LeaveHistoryItemModel item) => switch (item.balanceAfter) {
  final after? => '${FormatUtils.days(after)} left',
  null => null,
};

class _MobileItem extends StatelessWidget {
  const _MobileItem({required this.item});

  final LeaveHistoryItemModel item;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.s12,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.s2,
            children: [
              Text(
                AppDateFormat.range(item.startDate, item.endDate),
                style: AppTextStyles.bodySemibold,
              ),
              Text(
                [
                  '${item.leaveType} (${payLabel(item).toLowerCase()})',
                  FormatUtils.days(item.days),
                  if (item.balanceAfter case final after?)
                    '${FormatUtils.days(after)} left after',
                  ?item.reason,
                ].join(' · '),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        LeaveStatusBadge(item.status),
      ],
    );
  }
}
