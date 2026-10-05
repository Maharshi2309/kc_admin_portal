import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_empty_view.dart';
import 'package:kc_admin_portal/core/widgets/app_link.dart';
import 'package:kc_admin_portal/core/widgets/app_status_badge.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:kc_admin_portal/features/dashboard/presentation/dashboard_text.dart';
import 'package:kc_admin_portal/features/dashboard/presentation/widgets/person_row.dart';
import 'package:kc_admin_portal/shared/models/employee_summary_model.dart';

const EdgeInsets _listCardPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.s24,
  vertical: AppSpacing.s20,
);

/// Preview of employees who have not punched in today.
class NotPunchedInCard extends StatelessWidget {
  const NotPunchedInCard({
    required this.employees,
    required this.total,
    required this.onViewAll,
    required this.onPunchIn,
    this.busyEmployeeIds = const {},
    this.nobodyScheduled = false,
    super.key,
  });

  final List<EmployeeSummaryModel> employees;

  /// Today is nobody's working day (a company holiday, or everyone's weekly
  /// off), so there's nobody to punch in.
  final bool nobodyScheduled;

  /// Employees whose punch-in is in progress (their button shows a spinner).
  final Set<String> busyEmployeeIds;
  final int total;

  /// Null hides "All N" (the role can't open Attendance).
  final VoidCallback? onViewAll;

  /// Null hides the punch-in buttons (the role can't punch).
  final ValueChanged<EmployeeSummaryModel>? onPunchIn;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Not punched in',
      padding: _listCardPadding,
      gap: AppSpacing.s10,
      trailing: total == 0 || onViewAll == null
          ? null
          : AppLink(
              label: 'All ${FormatUtils.count(total)}',
              onPressed: onViewAll,
            ),
      child: employees.isEmpty
          ? AppEmptyView(
              compact: true,
              icon: nobodyScheduled
                  ? Icons.event_available_outlined
                  : Icons.how_to_reg_outlined,
              title: nobodyScheduled
                  ? 'Nobody is scheduled to work today'
                  : 'Everyone has punched in',
            )
          : Column(
              children: [
                for (final employee in employees)
                  PersonRow(
                    name: employee.name,
                    subtitle: [
                      employee.ecNumber,
                      ?employee.department?.label,
                    ].join(' · '),
                    subtitleIsMono: true,
                    trailing: onPunchIn == null
                        ? null
                        : AppButton(
                            label: 'Punch in',
                            size: AppButtonSize.small,
                            isLoading: busyEmployeeIds.contains(employee.id),
                            onPressed: () => onPunchIn!(employee),
                          ),
                  ),
              ],
            ),
    );
  }
}

/// Preview of employees on leave today.
class OnLeaveTodayCard extends StatelessWidget {
  const OnLeaveTodayCard({
    required this.leaves,
    required this.total,
    required this.today,
    required this.onViewAll,
    super.key,
  });

  final List<LeaveTodayModel> leaves;
  final int total;
  final DateTime today;

  /// Null hides "All N" (the role can't open Leaves).
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'On leave today',
      padding: _listCardPadding,
      gap: AppSpacing.s10,
      trailing: total == 0 || onViewAll == null
          ? null
          : AppLink(
              label: 'All ${FormatUtils.count(total)}',
              onPressed: onViewAll,
            ),
      child: leaves.isEmpty
          ? const AppEmptyView(
              compact: true,
              icon: Icons.beach_access_outlined,
              title: 'No one is on leave today',
            )
          : Column(
              children: [
                for (final leave in leaves)
                  PersonRow(
                    name: leave.employee.name,
                    subtitle: DashboardText.leaveUntil(leave, today),
                    trailing: AppStatusBadge(
                      label: leave.leaveType,
                      tone: leave.isHalfDay
                          ? StatusTone.halfDay
                          : StatusTone.warning,
                    ),
                  ),
              ],
            ),
    );
  }
}
