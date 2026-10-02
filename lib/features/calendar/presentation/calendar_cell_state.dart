import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/widgets/app_status_badge.dart';
import 'package:kc_admin_portal/features/calendar/data/models/calendar_models.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

/// The one colour a calendar day gets. Extra facts (pending leave,
/// corrections, overtime) are [CalendarMarker]s on top.
enum CalendarCellState {
  present('Present', 'P', StatusTone.success),
  late('Late', 'LATE', StatusTone.late),
  halfDay('Half day', 'HALF', StatusTone.halfDay),
  onLeave('On leave', 'L', StatusTone.warning),
  absent('Absent', 'A', StatusTone.danger),
  holiday('Company holiday', 'HOL', StatusTone.info),
  holidayWorked('Holiday worked', 'HW', StatusTone.offDayWorked),
  weekOff('Week off', 'OFF', StatusTone.neutral),
  weekOffWorked('Week off worked', 'WW', StatusTone.offDayWorked),

  /// A working day still to come (no fill).
  upcoming('Working day', '', null),

  /// No attendance (e.g. before joining, or no schedule).
  noRecord('No record', '', null);

  const CalendarCellState(this.label, this.short, this.tone);

  final String label;
  final String short;

  /// Null: no fill.
  final StatusTone? tone;
}

/// Facts shown as small markers, explained in the legend.
enum CalendarMarker {
  pendingLeave('Pending leave'),
  corrected('Attendance corrected'),
  overtime('Overtime');

  const CalendarMarker(this.label);

  final String label;
}

/// The cell state of [day] as of [today]. Presentation only: every fact
/// comes from the API.
CalendarCellState cellStateOf(CalendarDayModel day, DateTime today) {
  final attendance = day.attendance;
  final worked = attendance?.punchIn != null;
  switch (day.dayType) {
    case CalendarDayType.holiday:
      return worked
          ? CalendarCellState.holidayWorked
          : CalendarCellState.holiday;
    case CalendarDayType.weekOff:
      return worked
          ? CalendarCellState.weekOffWorked
          : CalendarCellState.weekOff;
    case CalendarDayType.working:
    case CalendarDayType.unknown:
      break;
  }

  if (day.date.dateOnly.isAfter(today.dateOnly)) {
    // Planned leave shows ahead; anything else is just a working day.
    final approved = day.leaves
        .where((l) => l.status == LeaveStatus.approved)
        .firstOrNull;
    if (approved == null) return CalendarCellState.upcoming;
    return approved.isHalfDay
        ? CalendarCellState.halfDay
        : CalendarCellState.onLeave;
  }

  return switch (attendance?.status) {
    AttendanceDayStatus.present => CalendarCellState.present,
    AttendanceDayStatus.late => CalendarCellState.late,
    AttendanceDayStatus.halfDay => CalendarCellState.halfDay,
    AttendanceDayStatus.onLeave => CalendarCellState.onLeave,
    AttendanceDayStatus.absent => CalendarCellState.absent,
    _ => CalendarCellState.noRecord,
  };
}

/// The markers of [day], in legend order.
List<CalendarMarker> markersOf(CalendarDayModel day) => [
  if (day.leaves.any((l) => l.status == LeaveStatus.pending))
    CalendarMarker.pendingLeave,
  if (day.attendance?.corrected ?? false) CalendarMarker.corrected,
  if (day.overtimeMinutes > 0) CalendarMarker.overtime,
];

/// "CL", "SL", …: the leave type's initial and "L", for leave cells.
String leaveShortOf(CalendarDayModel day) {
  final leave = day.leaves
      .where((l) => l.status == LeaveStatus.approved)
      .firstOrNull;
  final name = leave?.leaveType.name.trim() ?? '';
  return name.isEmpty ? 'L' : '${name[0].toUpperCase()}L';
}
