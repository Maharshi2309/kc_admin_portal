import 'package:json_annotation/json_annotation.dart';

/// Statuses sent by the backend. Values the app does not know (e.g. added
/// on the backend later) map to `unknown` instead of breaking parsing.
///
/// TODO — REQUIREMENT CONFIRMATION REQUIRED: the attendance and leave status
/// lists and their rules are not final. These values follow the design.

@JsonEnum(fieldRename: FieldRename.snake)
enum EmployeeStatus {
  active,
  inactive,
  unknown;

  String get label => switch (this) {
    active => 'Active',
    inactive => 'Inactive',
    unknown => 'Unknown',
  };
}

/// Attendance state of one employee on one day.
@JsonEnum(fieldRename: FieldRename.snake)
enum AttendanceDayStatus {
  present,
  late,
  halfDay,
  onLeave,
  absent,
  weeklyOff,
  holiday,
  unknown;

  String get label => switch (this) {
    present => 'Present',
    late => 'Late',
    halfDay => 'Half day',
    onLeave => 'On leave',
    absent => 'Absent',
    weeklyOff => 'Weekly off',
    holiday => 'Holiday',
    unknown => 'Not recorded',
  };

  /// Short tag for calendar cells.
  String get shortLabel => switch (this) {
    present => 'P',
    late => 'LATE',
    halfDay => 'HALF',
    onLeave => 'L',
    absent => 'A',
    weeklyOff => 'OFF',
    holiday => 'HOL',
    unknown => '',
  };
}

@JsonEnum(fieldRename: FieldRename.snake)
enum LeaveStatus {
  pending,
  approved,
  rejected,
  cancelled,
  unknown;

  String get label => switch (this) {
    pending => 'Pending',
    approved => 'Approved',
    rejected => 'Rejected',
    cancelled => 'Cancelled',
    unknown => 'Unknown',
  };
}

/// What kind of day an attendance record's work happened on. Work on a
/// company holiday or weekly off is recorded separately and counts fully as
/// overtime (approved 2026-09-30).
@JsonEnum(fieldRename: FieldRename.snake)
enum AttendanceDayKind {
  working,
  holidayWorked,
  weekOffWorked,
  unknown;

  String get label => switch (this) {
    working => 'Working day',
    holidayWorked => 'Holiday worked',
    weekOffWorked => 'Week off worked',
    unknown => 'Unknown',
  };
}

/// Whether a date is a working day for an employee, their weekly off, or a
/// company holiday. Company holidays win over weekly offs.
@JsonEnum(fieldRename: FieldRename.snake)
enum CalendarDayType {
  working,
  weekOff,
  holiday,
  unknown;

  String get label => switch (this) {
    working => 'Working day',
    weekOff => 'Week off',
    holiday => 'Company holiday',
    unknown => 'Unknown',
  };
}
