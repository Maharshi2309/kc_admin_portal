import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/utils/duration_format.dart';
import 'package:kc_admin_portal/core/widgets/app_empty_view.dart';
import 'package:kc_admin_portal/core/widgets/app_icon_button.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/core/widgets/responsive_data_view.dart';
import 'package:kc_admin_portal/features/attendance/data/models/attendance_models.dart';
import 'package:kc_admin_portal/features/attendance/presentation/providers/attendance_providers.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/permission_providers.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/widgets/status_badges.dart';

/// One employee's daily records for [month], newest first, each with a
/// correct / add action (profile "Attendance log" tab, design board 05).
class AttendanceLogList extends ConsumerWidget {
  const AttendanceLogList({
    required this.employeeId,
    required this.month,
    super.key,
  });

  final String employeeId;
  final DateTime month;

  static const double _tableMinWidth = 480;
  static const double _actionWidth = 72;

  void _correct(BuildContext context, AttendanceRecordModel record) {
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
          AppRouteParams.employeeId: employeeId,
          AppRouteParams.date: AppDateFormat.iso(record.date),
        },
      );
    }
  }

  static bool _canEdit(AttendanceRecordModel record) =>
      record.status != AttendanceDayStatus.onLeave &&
      record.status != AttendanceDayStatus.weeklyOff &&
      record.status != AttendanceDayStatus.holiday;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canCorrect = ref.can(AppPermission.attendanceCorrect);
    final key = (employeeId: employeeId, month: month);
    final log = ref.watch(employeeAttendanceLogProvider(key));
    String time(DateTime? t) => t == null ? '—' : AppDateFormat.time(t);

    return AsyncValueView<List<AttendanceRecordModel>>(
      value: log,
      compact: true,
      onRetry: () => ref.invalidate(employeeAttendanceLogProvider(key)),
      isEmpty: (items) => items.isEmpty,
      empty: const AppEmptyView(
        compact: true,
        icon: Icons.event_busy_outlined,
        title: 'No attendance recorded this month',
      ),
      data: (items) => ResponsiveDataView<AttendanceRecordModel>(
        rows: items,
        rowKey: (r) => r.date.toIso8601String(),
        tableMinWidth: _tableMinWidth,
        mobileItemBuilder: (context, r) => Row(
          spacing: AppSpacing.s12,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.s2,
                children: [
                  Text(
                    AppDateFormat.long(r.date),
                    style: AppTextStyles.bodySemibold,
                  ),
                  Text(
                    'In ${time(r.punchIn)} · Out ${time(r.punchOut)}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            AttendanceStatusBadge(r.status),
          ],
        ),
        columns: [
          AppDataColumn(
            label: 'Date',
            flex: 2,
            minWidth: 150,
            cellBuilder: (context, r) => Text(
              AppDateFormat.long(r.date),
              style: AppTextStyles.bodySemibold,
            ),
          ),
          AppDataColumn(
            label: 'In',
            minWidth: 70,
            cellBuilder: (context, r) => Text(time(r.punchIn)),
          ),
          AppDataColumn(
            label: 'Out',
            minWidth: 70,
            cellBuilder: (context, r) => Text(time(r.punchOut)),
          ),
          AppDataColumn(
            label: 'Worked',
            minWidth: 90,
            priority: 1,
            cellBuilder: (context, r) => Text(
              r.workedMinutes == null
                  ? '—'
                  : DurationFormat.full(r.workedMinutes!),
            ),
          ),
          AppDataColumn(
            label: 'Status',
            minWidth: 130,
            cellBuilder: (context, r) => AttendanceStatusBadge(r.status),
          ),
          AppDataColumn(
            label: '',
            fixedWidth: _actionWidth,
            alignment: AlignmentDirectional.centerEnd,
            cellBuilder: (context, r) => canCorrect && _canEdit(r)
                ? AppIconButton(
                    icon: r.id == null
                        ? Icons.add_circle_outline_rounded
                        : Icons.edit_calendar_outlined,
                    tooltip: r.id == null
                        ? 'Add attendance for ${AppDateFormat.medium(r.date)}'
                        : 'Correct ${AppDateFormat.medium(r.date)}',
                    onPressed: () => _correct(context, r),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
