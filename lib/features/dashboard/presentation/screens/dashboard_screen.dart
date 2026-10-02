import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/router/route_permissions.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_alert_banner.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_page.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';
import 'package:kc_admin_portal/core/widgets/app_status_badge.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/core/widgets/responsive_grid.dart';
import 'package:kc_admin_portal/features/attendance/presentation/providers/attendance_providers.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/auth_controller.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/permission_providers.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:kc_admin_portal/features/dashboard/presentation/dashboard_text.dart';
import 'package:kc_admin_portal/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:kc_admin_portal/features/dashboard/presentation/widgets/attendance_chart_card.dart';
import 'package:kc_admin_portal/features/dashboard/presentation/widgets/attention_card.dart';
import 'package:kc_admin_portal/features/dashboard/presentation/widgets/kpi_card.dart';
import 'package:kc_admin_portal/features/dashboard/presentation/widgets/leave_usage_card.dart';
import 'package:kc_admin_portal/features/dashboard/presentation/widgets/today_lists.dart';
import 'package:kc_admin_portal/shared/models/employee_summary_model.dart';

/// Today at a glance. Layout from the design: KPI cards, the monthly chart
/// beside "Needs your attention", then today's lists.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  /// KPI cards stay ≥ 170 px wide so labels never break mid-word: all
  /// across on laptops and wider, balanced rows on tablets and phones.
  static const double _kpiMinWidth = 170;

  /// Chart and attention side by side need at least this much width (the
  /// design's 2 : 1 split); narrower, they stack.
  static const double _chartRowMinWidth = 880;
  static const int _chartFlex = 2;

  /// Bottom cards stay ≥ 300 px wide: 3 across on desktop, stacked on phones.
  static const double _listCardMinWidth = 300;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dashboardSummaryProvider);
    final now = ref.watch(clockProvider)();
    final userName = ref.watch(authControllerProvider).value?.name;
    final grants = ref.watch(grantsProvider);
    bool can(String route) => canOpenRoute(route, grants);

    return AppPageBody(
      children: [
        AppPageHeader(
          title: DashboardText.greeting(now, userName),
          subtitle:
              summary.whenData(DashboardText.scheduleLine).value ??
              "Here's today at a glance. Select a card to open its section.",
          actions: [
            if (can(AppRouteNames.employeeAdd))
              AppButton(
                label: 'Add employee',
                icon: Icons.person_add_alt_1_outlined,
                variant: AppButtonVariant.secondary,
                onPressed: () => context.goNamed(AppRouteNames.employeeAdd),
              ),
            if (can(AppRouteNames.leaveAdd))
              AppButton(
                label: 'Add leave',
                icon: Icons.event_available_outlined,
                variant: AppButtonVariant.secondary,
                onPressed: () => context.goNamed(AppRouteNames.leaveAdd),
              ),
            if (can(AppRouteNames.attendance) &&
                grants.contains(AppPermission.attendancePunch))
              AppButton(
                label: 'Mark attendance',
                icon: Icons.schedule_rounded,
                onPressed: () => context.goNamed(AppRouteNames.attendance),
              ),
          ],
        ),
        AsyncValueView<DashboardSummaryModel>(
          value: summary,
          loadingMessage: 'Loading dashboard…',
          onRetry: () => ref.invalidate(dashboardSummaryProvider),
          data: (data) => _DashboardBody(summary: data, today: now.dateOnly),
        ),
      ],
    );
  }
}

class _DashboardBody extends ConsumerWidget {
  const _DashboardBody({required this.summary, required this.today});

  final DashboardSummaryModel summary;
  final DateTime today;

  /// Opens [routeName], or null when the role can't open it (the link is
  /// then hidden).
  VoidCallback? _link(
    BuildContext context,
    Set<AppPermission> grants,
    String routeName,
  ) =>
      canOpenRoute(routeName, grants) ? () => context.goNamed(routeName) : null;

  Future<void> _punchIn(
    BuildContext context,
    WidgetRef ref,
    EmployeeSummaryModel employee,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final error = await ref
        .read(attendanceActionsProvider.notifier)
        .punchIn(employee.id);
    showAppSnackBarOn(
      messenger,
      error ?? '${employee.name} punched in',
      tone: error == null ? SnackBarTone.success : SnackBarTone.error,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = ref.watch(attendanceActionsProvider);
    final grants = ref.watch(grantsProvider);
    VoidCallback? link(String route) => _link(context, grants, route);

    final holiday = summary.holiday;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s20,
      children: [
        if (holiday != null)
          AppAlertBanner(
            tone: AlertTone.info,
            title: 'Today is a company holiday: ${holiday.name}',
            message: DashboardText.holidayMessage(summary),
            action: link(AppRouteNames.holidays) == null
                ? null
                : AppButton(
                    label: 'Holidays',
                    size: AppButtonSize.small,
                    variant: AppButtonVariant.secondary,
                    onPressed: link(AppRouteNames.holidays),
                  ),
          ),
        ResponsiveGrid(
          minItemWidth: DashboardScreen._kpiMinWidth,
          // Up to 5 with the overtime card, in one row on wide screens.
          maxColumns: 5,
          children: _kpiCards(link),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final chart = AttendanceChartCard(
              onViewDetails: link(AppRouteNames.attendance),
            );
            final attention = AttentionCard(
              items: summary.attention,
              onOpen: (kind) => link(switch (kind) {
                AttentionKind.pendingLeave => AppRouteNames.leave,
                _ => AppRouteNames.attendance,
              }),
            );
            if (constraints.maxWidth < DashboardScreen._chartRowMinWidth) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: AppSpacing.s16,
                children: [chart, attention],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s16,
              children: [
                Expanded(flex: DashboardScreen._chartFlex, child: chart),
                Expanded(child: attention),
              ],
            );
          },
        ),
        ResponsiveGrid(
          minItemWidth: DashboardScreen._listCardMinWidth,
          maxColumns: 3,
          equalHeight: false,
          children: [
            NotPunchedInCard(
              employees: summary.notPunchedIn,
              total: summary.notPunchedInTotal,
              onViewAll: link(AppRouteNames.attendance),
              busyEmployeeIds: busy,
              nobodyScheduled: summary.scheduledToday == 0,
              onPunchIn: grants.contains(AppPermission.attendancePunch)
                  ? (employee) => _punchIn(context, ref, employee)
                  : null,
            ),
            OnLeaveTodayCard(
              leaves: summary.onLeave,
              total: summary.onLeaveToday,
              today: today,
              onViewAll: link(AppRouteNames.leave),
            ),
            if (summary.leaveUsage != null)
              LeaveUsageCard(
                usage: summary.leaveUsage!,
                onViewLeaves: link(AppRouteNames.leave),
              ),
          ],
        ),
      ],
    );
  }

  List<Widget> _kpiCards(VoidCallback? Function(String route) link) => [
    KpiCard(
      label: 'Total employees',
      value: summary.totalEmployees,
      icon: Icons.group_outlined,
      tone: StatusTone.neutral,
      actionLabel: 'View employees',
      onTap: link(AppRouteNames.employees),
    ),
    KpiCard(
      label: 'Present today',
      value: summary.presentToday,
      percent: summary.presentPercent,
      icon: Icons.check_rounded,
      tone: StatusTone.success,
      actionLabel: 'View attendance',
      onTap: link(AppRouteNames.attendance),
    ),
    KpiCard(
      label: 'On leave today',
      value: summary.onLeaveToday,
      percent: summary.onLeavePercent,
      icon: Icons.event_busy_outlined,
      tone: StatusTone.warning,
      actionLabel: 'View leaves',
      onTap: link(AppRouteNames.leave),
    ),
    KpiCard(
      label: 'Absent today',
      value: summary.absentToday,
      percent: summary.absentPercent,
      icon: Icons.close_rounded,
      tone: StatusTone.danger,
      actionLabel: 'See who is absent',
      onTap: link(AppRouteNames.attendance),
    ),
    // Only for roles with `overtime.view` (the server leaves it out).
    if (summary.overtimeMinutesThisMonth != null)
      KpiCard(
        label: 'Overtime this month',
        value: summary.overtimeMinutesThisMonth!,
        valueText: FormatUtils.duration(summary.overtimeMinutesThisMonth!),
        caption: switch (summary.overtimeEmployeesThisMonth) {
          null => null,
          1 => '1 employee',
          final n => '${FormatUtils.count(n)} employees',
        },
        icon: Icons.more_time_rounded,
        tone: StatusTone.offDayWorked,
        actionLabel: 'Overtime',
        onTap: null,
      ),
  ];
}
