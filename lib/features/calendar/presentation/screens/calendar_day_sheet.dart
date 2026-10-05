import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/utils/duration_format.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_dialog.dart';
import 'package:kc_admin_portal/core/widgets/app_side_sheet.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';
import 'package:kc_admin_portal/core/widgets/app_status_badge.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/permission_providers.dart';
import 'package:kc_admin_portal/features/calendar/data/models/calendar_models.dart';
import 'package:kc_admin_portal/features/calendar/presentation/calendar_cell_state.dart';
import 'package:kc_admin_portal/features/calendar/presentation/providers/calendar_providers.dart';
import 'package:kc_admin_portal/features/employees/presentation/providers/employee_providers.dart';
import 'package:kc_admin_portal/features/leave/presentation/providers/leave_providers.dart';
import 'package:kc_admin_portal/shared/models/audit_entry_model.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/widgets/status_badges.dart';

/// One day of an employee's calendar, with everything an admin can do on
/// it: record or correct attendance (including work on a holiday or weekly
/// off), add leave or act on a pending request, mark a company holiday, and
/// see what was changed and by whom.
///
/// Every action opens on top of this sheet and comes back to it; the backend
/// checks the permission of each change.
class CalendarDaySheet extends ConsumerWidget {
  const CalendarDaySheet({
    required this.employeeId,
    required this.date,
    super.key,
  });

  final String employeeId;
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (employeeId: employeeId, date: date);
    final detail = ref.watch(calendarDayProvider(key));
    final name = ref.watch(employeeDetailProvider(employeeId)).value?.name;

    return AppSideSheet(
      title: AppDateFormat.long(date),
      subtitle: name,
      body: AsyncValueView<CalendarDayDetailModel>(
        value: detail,
        compact: true,
        onRetry: () => ref.invalidate(calendarDayProvider(key)),
        data: (data) => _DayBody(
          employeeId: employeeId,
          employeeName: name ?? 'this employee',
          detail: data,
        ),
      ),
    );
  }
}

class _DayBody extends ConsumerWidget {
  const _DayBody({
    required this.employeeId,
    required this.employeeName,
    required this.detail,
  });

  final String employeeId;
  final String employeeName;
  final CalendarDayDetailModel detail;

  Map<String, String> get _path => {
    AppRouteParams.id: employeeId,
    AppRouteParams.date: AppDateFormat.iso(detail.day.date),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = detail.day;
    final today = ref.watch(clockProvider)().dateOnly;
    final state = cellStateOf(day, today);
    final grants = ref.watch(grantsProvider);
    bool can(AppPermission p) => grants.contains(p);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s24,
      children: [
        _Overview(day: day, state: state),
        _Section(
          title: 'ATTENDANCE',
          child: _Attendance(
            day: day,
            today: today,
            onRecord: !can(AppPermission.attendanceCorrect)
                ? null
                : () {
                    final recordId = day.attendance?.punchIn == null
                        ? null
                        : day.attendance?.id;
                    recordId == null
                        ? context.goNamed(
                            AppRouteNames.calendarDayAttendance,
                            pathParameters: _path,
                          )
                        : context.goNamed(
                            AppRouteNames.calendarDayAttendanceCorrect,
                            pathParameters: {
                              ..._path,
                              AppRouteParams.recordId: recordId,
                            },
                          );
                  },
          ),
        ),
        _Section(
          title: 'LEAVE',
          child: _Leave(
            day: day,
            employeeName: employeeName,
            canDecide: can(AppPermission.leaveApprove),
            onAdd: can(AppPermission.leaveCreate)
                ? () => context.goNamed(
                    AppRouteNames.calendarDayLeaveAdd,
                    pathParameters: _path,
                  )
                : null,
            onEdit: can(AppPermission.leaveEdit)
                ? (leaveId) => context.goNamed(
                    AppRouteNames.calendarDayLeaveEdit,
                    pathParameters: {..._path, AppRouteParams.leaveId: leaveId},
                  )
                : null,
          ),
        ),
        _Section(
          title: 'COMPANY HOLIDAY',
          child: _Holiday(
            day: day,
            onMark: can(AppPermission.holidayCreate)
                ? () => context.goNamed(
                    AppRouteNames.calendarDayHolidayAdd,
                    pathParameters: _path,
                  )
                : null,
            onManage: can(AppPermission.holidayView)
                ? () => context.goNamed(AppRouteNames.holidays)
                : null,
          ),
        ),
        // Change history is for roles with `audit.view` (the server
        // leaves it out for others).
        if (can(AppPermission.auditView))
          _Section(
            title: 'HISTORY',
            child: _History(entries: detail.history),
          ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.s10,
    children: [
      Semantics(
        header: true,
        child: Text(title, style: AppTextStyles.overline),
      ),
      child,
    ],
  );
}

/// The day's colour and what kind of day it is.
class _Overview extends StatelessWidget {
  const _Overview({required this.day, required this.state});

  final CalendarDayModel day;
  final CalendarCellState state;

  @override
  Widget build(BuildContext context) {
    final schedule = day.schedule;
    final kind = switch (day.dayType) {
      CalendarDayType.holiday => 'Company holiday · ${day.holidayName ?? ''}',
      CalendarDayType.weekOff => 'Weekly off',
      _ when schedule != null =>
        'Working day · ${schedule.startTime.toApi()}–'
            '${schedule.endTime.toApi()} · '
            '${DurationFormat.full(schedule.expectedMinutes)} expected',
      _ => 'Working day',
    };
    final tone = state.tone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s8,
      children: [
        Wrap(
          spacing: AppSpacing.s6,
          runSpacing: AppSpacing.s6,
          children: [
            if (tone != null) AppStatusBadge(label: state.label, tone: tone),
            if (day.overtimeMinutes > 0) OvertimeBadge(day.overtimeMinutes),
            if (day.attendance?.corrected ?? false)
              const AppStatusBadge(label: 'Corrected', tone: StatusTone.info),
          ],
        ),
        Text(
          kind,
          style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _Attendance extends StatelessWidget {
  const _Attendance({
    required this.day,
    required this.today,
    required this.onRecord,
  });

  final CalendarDayModel day;
  final DateTime today;

  /// Null hides the button (the role can't correct attendance).
  final VoidCallback? onRecord;

  @override
  Widget build(BuildContext context) {
    if (day.date.isAfter(today)) {
      return Text(
        'Attendance can be recorded from the day itself.',
        style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
      );
    }
    final attendance = day.attendance;
    final hasRecord = attendance?.id != null && attendance?.punchIn != null;
    final offDay = day.dayType != CalendarDayType.working;
    final worked = attendance?.workedMinutes;

    final facts = [
      if (attendance?.punchIn != null)
        ('Punch in', AppDateFormat.time(attendance!.punchIn!)),
      if (attendance?.punchIn != null)
        (
          'Punch out',
          attendance!.punchOut == null
              ? 'Not punched out'
              : AppDateFormat.time(attendance.punchOut!),
        ),
      if (worked != null) ('Worked', DurationFormat.full(worked)),
      if (day.overtimeMinutes > 0)
        ('Overtime', DurationFormat.full(day.overtimeMinutes)),
    ];

    final label = hasRecord
        ? 'Correct attendance'
        : switch (day.dayType) {
            CalendarDayType.holiday => 'Record holiday work',
            CalendarDayType.weekOff => 'Record week-off work',
            _ => 'Add attendance',
          };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s12,
      children: [
        if (facts.isEmpty)
          Text(
            offDay
                ? 'No work recorded. Nobody is marked absent on this day.'
                : 'Nothing recorded for this day.',
            style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
          )
        else
          Wrap(
            spacing: AppSpacing.s24,
            runSpacing: AppSpacing.s10,
            children: [
              for (final (title, value) in facts)
                MergeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSpacing.s2,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(value, style: AppTextStyles.bodySemibold),
                    ],
                  ),
                ),
            ],
          ),
        if (onRecord != null)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: AppButton(
              label: label,
              icon: hasRecord
                  ? Icons.edit_calendar_outlined
                  : Icons.add_circle_outline_rounded,
              variant: AppButtonVariant.secondary,
              size: AppButtonSize.small,
              onPressed: onRecord,
            ),
          ),
      ],
    );
  }
}

class _Leave extends ConsumerWidget {
  const _Leave({
    required this.day,
    required this.employeeName,
    required this.canDecide,
    required this.onAdd,
    required this.onEdit,
  });

  final CalendarDayModel day;
  final String employeeName;

  /// Approve and reject (`leave.approve`).
  final bool canDecide;

  /// Each is hidden when null (the role doesn't allow it).
  final VoidCallback? onAdd;
  final ValueChanged<String>? onEdit;

  Future<void> _decide(
    BuildContext context,
    WidgetRef ref,
    CalendarLeaveModel leave,
    LeaveStatus status,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    if (status == LeaveStatus.rejected) {
      final confirmed = await showAppConfirmDialog(
        context,
        title: 'Reject this leave?',
        message:
            '$employeeName · ${leave.leaveType.name}. It stays in the leave '
            'history as rejected.',
        confirmLabel: 'Reject leave',
        cancelLabel: 'Keep',
        isDestructive: true,
      );
      if (!confirmed) return;
    }
    final error = await ref
        .read(leaveActionsProvider.notifier)
        .setStatus(leave.id, status);
    showAppSnackBarOn(
      messenger,
      error ?? 'Leave ${status.label.toLowerCase()} for $employeeName',
      tone: error == null ? SnackBarTone.success : SnackBarTone.error,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = ref.watch(leaveActionsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s12,
      children: [
        if (day.leaves.isEmpty)
          Text(
            'No leave on this day.',
            style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
          ),
        for (final leave in day.leaves)
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            children: [
              Text(
                '${leave.leaveType.name} leave'
                '${leave.isHalfDay ? ' · half day' : ''}',
                style: AppTextStyles.bodySemibold,
              ),
              LeaveStatusBadge(leave.status),
              // Only pending leave can be decided or edited (approved
              // 2026-09-30); the backend enforces it.
              if (leave.status == LeaveStatus.pending && canDecide) ...[
                AppButton(
                  label: 'Approve',
                  size: AppButtonSize.small,
                  isLoading: busy.contains(leave.id),
                  onPressed: () =>
                      _decide(context, ref, leave, LeaveStatus.approved),
                ),
                AppButton(
                  label: 'Reject',
                  size: AppButtonSize.small,
                  variant: AppButtonVariant.secondary,
                  onPressed: busy.contains(leave.id)
                      ? null
                      : () =>
                            _decide(context, ref, leave, LeaveStatus.rejected),
                ),
              ],
              if (leave.status == LeaveStatus.pending && onEdit != null)
                AppButton(
                  label: 'Edit',
                  size: AppButtonSize.small,
                  variant: AppButtonVariant.ghost,
                  onPressed: () => onEdit!(leave.id),
                ),
            ],
          ),
        if (onAdd != null)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: AppButton(
              label: 'Add leave',
              icon: Icons.event_available_outlined,
              variant: AppButtonVariant.secondary,
              size: AppButtonSize.small,
              onPressed: onAdd,
            ),
          ),
      ],
    );
  }
}

class _Holiday extends StatelessWidget {
  const _Holiday({
    required this.day,
    required this.onMark,
    required this.onManage,
  });

  final CalendarDayModel day;

  /// Each is hidden when null (the role doesn't allow it).
  final VoidCallback? onMark;
  final VoidCallback? onManage;

  @override
  Widget build(BuildContext context) {
    final muted = AppTextStyles.body.copyWith(color: AppColors.textMuted);
    if (day.dayType == CalendarDayType.holiday) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.s12,
        runSpacing: AppSpacing.s8,
        children: [
          Text(day.holidayName ?? 'Company holiday', style: muted),
          if (onManage != null)
            AppButton(
              label: 'Manage holidays',
              variant: AppButtonVariant.ghost,
              size: AppButtonSize.small,
              onPressed: onManage,
            ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s8,
      children: [
        Text(
          'A company holiday applies to every employee: nobody is marked '
          'absent and leave on it is not counted.',
          style: muted,
        ),
        if (onMark != null)
          AppButton(
            label: 'Mark as company holiday',
            icon: Icons.event_available_outlined,
            variant: AppButtonVariant.secondary,
            size: AppButtonSize.small,
            onPressed: onMark,
          ),
      ],
    );
  }
}

class _History extends StatelessWidget {
  const _History({required this.entries});

  final List<AuditEntryModel> entries;

  @override
  Widget build(BuildContext context) {
    final muted = AppTextStyles.caption.copyWith(color: AppColors.textMuted);
    if (entries.isEmpty) {
      return Text(
        'No changes recorded for this day.',
        style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s12,
      children: [
        for (final entry in entries)
          MergeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s2,
              children: [
                Text(entry.summary, style: AppTextStyles.bodySemibold),
                for (final change in entry.changes)
                  Text(
                    '${change.label}: ${change.before ?? '—'} → '
                    '${change.after ?? '—'}',
                    style: AppTextStyles.small,
                  ),
                if (entry.reason != null || entry.remarks != null)
                  Text(
                    [?entry.reason, ?entry.remarks].join(' · '),
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                Text(
                  '${entry.actor.name} · '
                  '${AppDateFormat.medium(entry.createdAt)} '
                  '${AppDateFormat.time(entry.createdAt)}',
                  style: muted,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
