import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kc_admin_portal/shared/models/audit_entry_model.dart';
import 'package:kc_admin_portal/shared/models/json_converters.dart';
import 'package:kc_admin_portal/shared/models/named_ref.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/models/work_schedule_model.dart';

part 'calendar_models.freezed.dart';
part 'calendar_models.g.dart';

/// One employee's month (`GET /employees/{id}/calendar?month=YYYY-MM`).
@freezed
abstract class EmployeeCalendarModel with _$EmployeeCalendarModel {
  const factory EmployeeCalendarModel({
    @DateOnlyConverter() required DateTime month,
    required List<CalendarDayModel> days,
    required CalendarSummaryModel summary,
  }) = _EmployeeCalendarModel;

  factory EmployeeCalendarModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeCalendarModelFromJson(json);
}

/// Everything the calendar shows for one date. The backend decides every
/// value; the app only chooses colours and markers from them.
@freezed
abstract class CalendarDayModel with _$CalendarDayModel {
  const factory CalendarDayModel({
    @DateOnlyConverter() required DateTime date,
    @JsonKey(unknownEnumValue: CalendarDayType.unknown)
    required CalendarDayType dayType,
    String? holidayName,

    /// The schedule on this date; null on holidays and weekly offs.
    ScheduleSnapshotModel? schedule,
    CalendarAttendanceModel? attendance,

    /// Leave touching this date, including pending and rejected requests.
    @Default(<CalendarLeaveModel>[]) List<CalendarLeaveModel> leaves,
    @Default(0) int overtimeMinutes,
  }) = _CalendarDayModel;

  factory CalendarDayModel.fromJson(Map<String, dynamic> json) =>
      _$CalendarDayModelFromJson(json);
}

/// The attendance recorded on a calendar day.
@freezed
abstract class CalendarAttendanceModel with _$CalendarAttendanceModel {
  const factory CalendarAttendanceModel({
    /// Null when nothing is recorded (an absence on a working day).
    @JsonKey(fromJson: _optionalId) String? id,
    @JsonKey(unknownEnumValue: AttendanceDayStatus.unknown)
    required AttendanceDayStatus status,
    @JsonKey(unknownEnumValue: AttendanceDayKind.unknown)
    @Default(AttendanceDayKind.working)
    AttendanceDayKind dayKind,
    @CompanyDateTimeConverter() DateTime? punchIn,
    @CompanyDateTimeConverter() DateTime? punchOut,
    int? workedMinutes,
    @Default(false) bool corrected,
  }) = _CalendarAttendanceModel;

  factory CalendarAttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$CalendarAttendanceModelFromJson(json);
}

String? _optionalId(Object? value) => value?.toString();

/// A leave request covering a calendar day.
@freezed
abstract class CalendarLeaveModel with _$CalendarLeaveModel {
  const factory CalendarLeaveModel({
    @JsonKey(fromJson: idFromJson) required String id,
    required NamedRef leaveType,
    @JsonKey(unknownEnumValue: LeaveStatus.unknown) required LeaveStatus status,
    @Default(false) bool isHalfDay,
  }) = _CalendarLeaveModel;

  factory CalendarLeaveModel.fromJson(Map<String, dynamic> json) =>
      _$CalendarLeaveModelFromJson(json);
}

/// Month totals shown above the calendar.
@freezed
abstract class CalendarSummaryModel with _$CalendarSummaryModel {
  const factory CalendarSummaryModel({
    required int workingDays,
    required int present,
    required int absent,
    required double leaveDays,
    required int holidays,
    required int weekOffs,
    required int holidayWorked,
    required int weekOffWorked,
    required int expectedMinutes,
    required int workedMinutes,
    required int overtimeMinutes,
  }) = _CalendarSummaryModel;

  factory CalendarSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$CalendarSummaryModelFromJson(json);
}

/// One date in full, for the day sheet
/// (`GET /employees/{id}/calendar/{date}`).
@freezed
abstract class CalendarDayDetailModel with _$CalendarDayDetailModel {
  const factory CalendarDayDetailModel({
    required CalendarDayModel day,

    /// Changes to this employee's records on this date, newest first.
    @Default(<AuditEntryModel>[]) List<AuditEntryModel> history,
  }) = _CalendarDayDetailModel;

  factory CalendarDayDetailModel.fromJson(Map<String, dynamic> json) =>
      _$CalendarDayDetailModelFromJson(json);
}
