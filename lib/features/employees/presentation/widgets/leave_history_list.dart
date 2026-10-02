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
/// card.
class LeaveHistoryList extends ConsumerWidget {
  const LeaveHistoryList({required this.employeeId, super.key});

  final String employeeId;

  /// The five columns fit from this width (reason drops first).
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
            minWidth: 170,
            cellBuilder: (context, item) => Text(
              AppDateFormat.range(item.startDate, item.endDate),
              style: AppTextStyles.bodySemibold,
            ),
          ),
          AppDataColumn(
            label: 'Type',
            minWidth: 100,
            cellBuilder: (context, item) => Text(item.leaveType),
          ),
          AppDataColumn(
            label: 'Days',
            minWidth: 70,
            cellBuilder: (context, item) => Text(FormatUtils.count(item.days)),
          ),
          AppDataColumn(
            label: 'Reason',
            flex: 2,
            minWidth: 140,
            priority: 1,
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
                  item.leaveType,
                  FormatUtils.days(item.days),
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
