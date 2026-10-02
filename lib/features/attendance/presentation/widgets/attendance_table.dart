import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_avatar.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_icon_button.dart';
import 'package:kc_admin_portal/core/widgets/app_progress_bar.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';
import 'package:kc_admin_portal/core/widgets/responsive_data_view.dart';
import 'package:kc_admin_portal/features/attendance/data/models/attendance_models.dart';
import 'package:kc_admin_portal/features/attendance/presentation/providers/attendance_providers.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/permission_providers.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/widgets/status_badges.dart';

/// The day's attendance rows (design board 06). Punch buttons appear only
/// for today; the pencil corrects a record or adds a missing one.
class AttendanceTable extends ConsumerWidget {
  const AttendanceTable({
    required this.records,
    required this.isToday,
    super.key,
  });

  final List<AttendanceRecordModel> records;
  final bool isToday;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveDataView<AttendanceRecordModel>(
      rows: records,
      rowKey: (r) => r.employee.id,
      mobileItemBuilder: (context, r) =>
          _MobileItem(record: r, isToday: isToday),
      columns: [
        AppDataColumn(
          label: 'Employee',
          flex: 3,
          minWidth: 230,
          cellBuilder: (context, r) => _EmployeeCell(record: r),
        ),
        AppDataColumn(
          label: 'Punch in',
          minWidth: 100,
          cellBuilder: (context, r) => _TimeText(r.punchIn),
        ),
        AppDataColumn(
          label: 'Punch out',
          minWidth: 100,
          priority: 2,
          cellBuilder: (context, r) => _TimeText(r.punchOut),
        ),
        AppDataColumn(
          label: 'Worked',
          flex: 2,
          minWidth: 140,
          priority: 3,
          cellBuilder: (context, r) => _WorkedCell(record: r),
        ),
        AppDataColumn(
          label: 'Status',
          flex: 2,
          minWidth: 150,
          cellBuilder: (context, r) => _StatusCell(record: r),
        ),
        AppDataColumn(
          label: 'Action',
          flex: 2,
          minWidth: 190,
          alignment: AlignmentDirectional.centerEnd,
          cellBuilder: (context, r) => _RowActions(record: r, isToday: isToday),
        ),
      ],
    );
  }
}

class _EmployeeCell extends ConsumerWidget {
  const _EmployeeCell({required this.record});

  final AttendanceRecordModel record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employee = record.employee;
    final canOpen = ref.can(AppPermission.employeeView);
    return Row(
      spacing: AppSpacing.s12,
      children: [
        AppAvatar(name: employee.name),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.s2,
            children: [
              InkWell(
                onTap: canOpen
                    ? () => context.goNamed(
                        AppRouteNames.employeeProfile,
                        pathParameters: {AppRouteParams.id: employee.id},
                      )
                    : null,
                child: Text(
                  employee.name,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySemibold,
                ),
              ),
              Text(
                [
                  employee.ecNumber,
                  ?employee.department,
                  ?_shiftText(record),
                ].join(' · '),
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The employee's own hours that day, e.g. "09:30–18:30".
String? _shiftText(AttendanceRecordModel record) {
  final schedule = record.schedule;
  return schedule == null
      ? null
      : '${schedule.startTime.toApi()}–${schedule.endTime.toApi()}';
}

class _TimeText extends StatelessWidget {
  const _TimeText(this.time);

  final DateTime? time;

  @override
  Widget build(BuildContext context) {
    return Text(
      time == null ? '—' : AppDateFormat.time(time!),
      style: time == null
          ? AppTextStyles.body.copyWith(color: AppColors.textPlaceholder)
          : AppTextStyles.bodySemibold.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
    );
  }
}

class _WorkedCell extends StatelessWidget {
  const _WorkedCell({required this.record});

  final AttendanceRecordModel record;

  static const double _barWidth = 96;

  @override
  Widget build(BuildContext context) {
    final minutes = record.workedMinutes;
    if (minutes == null) {
      return Text(
        record.punchIn == null ? '—' : 'In progress',
        style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
      );
    }
    final expected = record.expectedMinutes ?? 0;
    final overtime = record.overtimeMinutes ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s4,
      children: [
        Text.rich(
          TextSpan(
            text: FormatUtils.duration(minutes),
            children: [
              if (expected > 0)
                TextSpan(
                  text: ' of ${FormatUtils.duration(expected)}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
            ],
          ),
          style: AppTextStyles.body,
        ),
        if (record.workedPercent != null)
          SizedBox(
            width: _barWidth,
            child: AppProgressBar(
              value: record.workedPercent! / 100,
              color: AppColors.successSwatch,
            ),
          ),
        Wrap(
          spacing: AppSpacing.s4,
          runSpacing: AppSpacing.s4,
          children: [
            DayKindBadge(record.dayKind),
            if (overtime > 0) OvertimeBadge(overtime),
          ],
        ),
      ],
    );
  }
}

class _StatusCell extends StatelessWidget {
  const _StatusCell({required this.record});

  final AttendanceRecordModel record;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s4,
      children: [
        AttendanceStatusBadge(record.status),
        if (record.note != null)
          Text(
            record.note!,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
          ),
      ],
    );
  }
}

/// Punch in / out (today only), and correct / add record.
class _RowActions extends ConsumerWidget {
  const _RowActions({required this.record, required this.isToday});

  final AttendanceRecordModel record;
  final bool isToday;

  Future<void> _punch(BuildContext context, WidgetRef ref, bool isIn) async {
    final messenger = ScaffoldMessenger.of(context);
    final actions = ref.read(attendanceActionsProvider.notifier);
    final employee = record.employee;
    final error = isIn
        ? await actions.punchIn(employee.id)
        : await actions.punchOut(employee.id);
    showAppSnackBarOn(
      messenger,
      error ?? '${employee.name} punched ${isIn ? 'in' : 'out'}',
      tone: error == null ? SnackBarTone.success : SnackBarTone.error,
    );
  }

  void _correct(BuildContext context) {
    final id = record.id;
    if (id != null) {
      context.goNamed(
        AppRouteNames.attendanceCorrect,
        pathParameters: {AppRouteParams.id: id},
      );
    } else {
      context.goNamed(
        AppRouteNames.attendanceAdd,
        queryParameters: {
          AppRouteParams.employeeId: record.employee.id,
          AppRouteParams.date: AppDateFormat.iso(record.date),
        },
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = ref
        .watch(attendanceActionsProvider)
        .contains(record.employee.id);
    final onLeave = record.status == AttendanceDayStatus.onLeave;
    final mayPunch = ref.can(AppPermission.attendancePunch);
    final mayCorrect = ref.can(AppPermission.attendanceCorrect);
    // Work on a holiday or weekly off is recorded with "Add attendance".
    final canPunchIn =
        mayPunch &&
        isToday &&
        record.punchIn == null &&
        !onLeave &&
        record.status != AttendanceDayStatus.weeklyOff &&
        record.status != AttendanceDayStatus.holiday;
    final canPunchOut =
        mayPunch &&
        isToday &&
        record.punchIn != null &&
        record.punchOut == null;
    final name = record.employee.name;

    final Widget primary;
    if (canPunchIn) {
      primary = AppButton(
        label: 'Punch in',
        size: AppButtonSize.small,
        isLoading: busy,
        onPressed: () => _punch(context, ref, true),
      );
    } else if (canPunchOut) {
      primary = AppButton(
        label: 'Punch out',
        size: AppButtonSize.small,
        variant: AppButtonVariant.secondary,
        isLoading: busy,
        onPressed: () => _punch(context, ref, false),
      );
    } else {
      final text = onLeave
          ? 'On leave'
          : record.punchOut != null
          ? 'Completed'
          : '';
      primary = Text(
        text,
        style: AppTextStyles.smallSemibold.copyWith(color: AppColors.textMuted),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s6,
      children: [
        Flexible(child: primary),
        if (!onLeave && mayCorrect)
          AppIconButton(
            icon: record.id == null
                ? Icons.add_circle_outline_rounded
                : Icons.edit_calendar_outlined,
            tooltip: record.id == null
                ? 'Add attendance for $name'
                : 'Correct attendance for $name',
            onPressed: () => _correct(context),
          ),
      ],
    );
  }
}

class _MobileItem extends StatelessWidget {
  const _MobileItem({required this.record, required this.isToday});

  final AttendanceRecordModel record;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final worked = record.workedMinutes;
    final times = [
      if (record.punchIn != null) 'In ${AppDateFormat.time(record.punchIn!)}',
      if (record.punchOut != null)
        'Out ${AppDateFormat.time(record.punchOut!)}',
      if (worked != null) FormatUtils.duration(worked),
      ?record.note,
    ].join(' · ');
    final overtime = record.overtimeMinutes ?? 0;
    final hasExtras =
        overtime > 0 || record.dayKind != AttendanceDayKind.working;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s10,
      children: [
        Row(
          spacing: AppSpacing.s12,
          children: [
            AppAvatar(name: record.employee.name),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.s2,
                children: [
                  Text(
                    record.employee.name,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySemibold,
                  ),
                  Text(
                    times.isEmpty
                        ? [
                            record.employee.ecNumber,
                            ?_shiftText(record),
                          ].join(' · ')
                        : times,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            AttendanceStatusBadge(record.status),
          ],
        ),
        if (hasExtras)
          Wrap(
            spacing: AppSpacing.s4,
            runSpacing: AppSpacing.s4,
            children: [
              DayKindBadge(record.dayKind),
              if (overtime > 0) OvertimeBadge(overtime),
            ],
          ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: _RowActions(record: record, isToday: isToday),
        ),
      ],
    );
  }
}
