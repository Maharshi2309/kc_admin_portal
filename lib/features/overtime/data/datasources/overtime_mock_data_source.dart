import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_guard.dart';
import 'package:kc_admin_portal/features/attendance/data/datasources/attendance_mock_data_source.dart';
import 'package:kc_admin_portal/features/overtime/data/datasources/overtime_remote_data_source.dart';
import 'package:kc_admin_portal/features/overtime/data/models/overtime_models.dart';

/// DEV ONLY (`USE_MOCK_API=true`): the overtime report built from the same
/// attendance records the Attendance screen shows, as the backend does
/// (docs/DATABASE_V2.md §3.6).
class OvertimeMockDataSource implements OvertimeRemoteDataSource {
  /// Checks the signed-in user's permissions, like the backend (§4.2).
  final MockGuard guard;

  OvertimeMockDataSource({
    this.guard = const MockGuard.allowAll(),
    required this.attendance,
    this.latency = Duration.zero,
  });

  final AttendanceMockDataSource attendance;
  final Duration latency;

  @override
  Future<OvertimeReportModel> report(
    String employeeId, {
    required DateTime from,
    required DateTime to,
  }) async {
    await Future<void>.delayed(latency);
    guard.require(AppPermission.overtimeView);
    final start = from.dateOnly;
    final end = to.dateOnly;
    if (end.isBefore(start)) {
      throw const ValidationException(
        'The end date must be on or after the start date.',
        fieldErrors: {'to': 'Must be on or after the start date'},
      );
    }

    final schedules = attendance.schedules;
    final records = attendance.recordsBetween(employeeId, start, end);
    final days = [
      for (final r in records)
        if ((r.overtimeMinutes ?? 0) > 0)
          OvertimeDayModel(
            date: r.date,
            dayKind: r.dayKind,
            expectedMinutes: r.expectedMinutes ?? 0,
            workedMinutes: r.workedMinutes ?? 0,
            overtimeMinutes: r.overtimeMinutes!,
            dayBasisMinutes:
                schedules.on(employeeId, r.date)?.expectedMinutes ?? 0,
          ),
    ];

    // Every month in the range up to today, with its working hours.
    final byMonth = <DateTime, ({int overtime, int expected, int worked})>{};
    for (final r in records) {
      final month = r.date.monthStart;
      final sum = byMonth[month] ?? (overtime: 0, expected: 0, worked: 0);
      byMonth[month] = (
        overtime: sum.overtime + (r.overtimeMinutes ?? 0),
        expected: sum.expected + (r.expectedMinutes ?? 0),
        worked: sum.worked + (r.workedMinutes ?? 0),
      );
    }
    final versions = {
      for (final r in records) schedules.on(employeeId, r.date)?.id,
    }..remove(null);
    final lastDay = records.isEmpty ? end : records.last.date;

    return OvertimeReportModel(
      from: start,
      to: end,
      totalMinutes: days.fold(0, (sum, d) => sum + d.overtimeMinutes),
      expectedMinutes: byMonth.values.fold<int>(
        0,
        (sum, m) => sum + m.expected,
      ),
      workedMinutes: byMonth.values.fold<int>(0, (sum, m) => sum + m.worked),
      dayBasisMinutes: schedules.on(employeeId, lastDay)?.expectedMinutes ?? 0,
      scheduleChanged: versions.length > 1,
      months: [
        for (final MapEntry(key: month, value: sum) in byMonth.entries)
          OvertimeMonthModel(
            month: month,
            minutes: sum.overtime,
            expectedMinutes: sum.expected,
            workedMinutes: sum.worked,
          ),
      ],
      // Newest first, as a history.
      days: days.reversed.toList(),
    );
  }
}
