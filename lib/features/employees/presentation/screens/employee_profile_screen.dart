import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/router/route_permissions.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_breadcrumb.dart';
import 'package:kc_admin_portal/core/widgets/app_page.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/permission_providers.dart';
import 'package:kc_admin_portal/features/calendar/presentation/widgets/employee_calendar_card.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/employees/presentation/providers/employee_providers.dart';
import 'package:kc_admin_portal/features/employees/presentation/widgets/employee_history_card.dart';
import 'package:kc_admin_portal/features/employees/presentation/widgets/employee_status_action.dart';
import 'package:kc_admin_portal/features/employees/presentation/widgets/leave_balance_cards.dart';
import 'package:kc_admin_portal/features/employees/presentation/widgets/profile_header_card.dart';
import 'package:kc_admin_portal/features/employees/presentation/widgets/work_schedule_card.dart';
import 'package:kc_admin_portal/features/overtime/presentation/widgets/working_hours_card.dart';
import 'package:kc_admin_portal/shared/models/leave_balance_model.dart';

/// Employee profile (design board 05): details, working schedule, leave
/// balance, attendance calendar, leave history, and working hours and
/// overtime.
class EmployeeProfileScreen extends ConsumerWidget {
  const EmployeeProfileScreen({required this.employeeId, super.key});

  final String employeeId;

  /// Calendar and history side by side need at least this width.
  static const double _twoColumnMinWidth = 1100;
  static const double _calendarWidth = 560;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employee = ref.watch(employeeDetailProvider(employeeId));
    final name = employee.value?.name;

    return AppPageBody(
      children: [
        AppBreadcrumb(
          items: [
            AppBreadcrumbItem(
              'Employees',
              onTap: () => context.goNamed(AppRouteNames.employees),
            ),
            AppBreadcrumbItem(name ?? 'Profile'),
          ],
        ),
        AsyncValueView<EmployeeModel>(
          value: employee,
          onRetry: () => ref.invalidate(employeeDetailProvider(employeeId)),
          data: (data) => _ProfileBody(employee: data),
        ),
      ],
    );
  }
}

class _ProfileBody extends ConsumerWidget {
  const _ProfileBody({required this.employee});

  final EmployeeModel employee;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = employee.id;
    final balances = ref.watch(employeeLeaveBalanceProvider(id));
    final today = ref.watch(clockProvider)().dateOnly;
    final changingStatus = ref
        .watch(employeeStatusControllerProvider)
        .isLoading;
    final grants = ref.watch(grantsProvider);
    bool can(String route) => canOpenRoute(route, grants);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s20,
      children: [
        ProfileHeaderCard(
          employee: employee,
          today: today,
          isChangingStatus: changingStatus,
          onEdit: can(AppRouteNames.employeeEdit)
              ? () => context.goNamed(
                  AppRouteNames.employeeEdit,
                  pathParameters: {AppRouteParams.id: id},
                )
              : null,
          onToggleStatus: grants.contains(AppPermission.employeeDeactivate)
              ? () => toggleEmployeeStatus(context, ref, employee)
              : null,
          onAddLeave: can(AppRouteNames.leaveAdd)
              ? () => context.goNamed(
                  AppRouteNames.leaveAdd,
                  queryParameters: {AppRouteParams.employeeId: id},
                )
              : null,
        ),
        WorkScheduleCard(
          employeeId: id,
          current: employee.schedule,
          onChange: can(AppRouteNames.employeeSchedule)
              ? () => context.goNamed(
                  AppRouteNames.employeeSchedule,
                  pathParameters: {AppRouteParams.id: id},
                )
              : null,
        ),
        AsyncValueView<LeaveBalanceModel>(
          value: balances,
          compact: true,
          onRetry: () => ref.invalidate(employeeLeaveBalanceProvider(id)),
          data: (balance) => LeaveBalanceCards(balance: balance),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final history = EmployeeHistoryCard(
              employeeId: id,
              showAttendanceLog: grants.contains(AppPermission.attendanceView),
            );
            // The calendar needs `calendar.view`; without it the history
            // takes the full width.
            if (!grants.contains(AppPermission.calendarView)) return history;
            final calendar = EmployeeCalendarCard(
              employeeId: id,
              dayMinutes: employee.schedule?.expectedMinutes ?? 0,
              onDayTap: (date) => context.goNamed(
                AppRouteNames.employeeCalendarDay,
                pathParameters: {
                  AppRouteParams.id: id,
                  AppRouteParams.date: AppDateFormat.iso(date),
                },
              ),
            );
            if (constraints.maxWidth <
                EmployeeProfileScreen._twoColumnMinWidth) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: AppSpacing.s16,
                children: [calendar, history],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s16,
              children: [
                SizedBox(
                  width: EmployeeProfileScreen._calendarWidth,
                  child: calendar,
                ),
                Expanded(child: history),
              ],
            );
          },
        ),
        // Working hours and overtime for any period (`overtime.view`).
        if (grants.contains(AppPermission.overtimeView))
          WorkingHoursCard(employeeId: id),
      ],
    );
  }
}
