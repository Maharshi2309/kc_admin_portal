import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kc_admin_portal/shared/models/json_converters.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

part 'overtime_models.freezed.dart';
part 'overtime_models.g.dart';

/// An employee's overtime for a date range
/// (`GET /employees/{id}/overtime?from=…&to=…`). All values are whole
/// minutes, computed by the backend.
///
/// Rules (approved 2026-09-30): overtime = worked − expected on working days
/// (never negative, not netted across days); all work on a holiday or weekly
/// off is overtime.
@freezed
abstract class OvertimeReportModel with _$OvertimeReportModel {
  const factory OvertimeReportModel({
    @DateOnlyConverter() required DateTime from,
    @DateOnlyConverter() required DateTime to,
    required int totalMinutes,

    /// Working hours in the range, up to today (V2 profile): what the
    /// schedule expected and what was worked, holidays and weekly offs
    /// included. Null from an older backend.
    int? expectedMinutes,
    int? workedMinutes,

    /// Expected minutes of one working day under the current schedule; the
    /// basis for showing [totalMinutes] as days.
    required int dayBasisMinutes,

    /// True when the schedule changed inside the range, so the day
    /// conversion of the total is approximate.
    @Default(false) bool scheduleChanged,

    /// Every month of the range up to today, oldest first.
    required List<OvertimeMonthModel> months,
    required List<OvertimeDayModel> days,
  }) = _OvertimeReportModel;

  factory OvertimeReportModel.fromJson(Map<String, dynamic> json) =>
      _$OvertimeReportModelFromJson(json);
}

@freezed
abstract class OvertimeMonthModel with _$OvertimeMonthModel {
  const factory OvertimeMonthModel({
    @DateOnlyConverter() required DateTime month,

    /// Overtime in the month (inside the range).
    required int minutes,

    /// Working hours in the month (inside the range, up to today).
    int? expectedMinutes,
    int? workedMinutes,
  }) = _OvertimeMonthModel;

  factory OvertimeMonthModel.fromJson(Map<String, dynamic> json) =>
      _$OvertimeMonthModelFromJson(json);
}

/// A date with overtime. [expectedMinutes] is that date's own schedule,
/// used to show this day's overtime as a share of a day.
@freezed
abstract class OvertimeDayModel with _$OvertimeDayModel {
  const factory OvertimeDayModel({
    @DateOnlyConverter() required DateTime date,
    @JsonKey(unknownEnumValue: AttendanceDayKind.unknown)
    required AttendanceDayKind dayKind,
    required int expectedMinutes,
    required int workedMinutes,
    required int overtimeMinutes,

    /// Expected minutes of a working day under this date's schedule (the
    /// day basis, also on holidays and weekly offs where expected is 0).
    required int dayBasisMinutes,
  }) = _OvertimeDayModel;

  factory OvertimeDayModel.fromJson(Map<String, dynamic> json) =>
      _$OvertimeDayModelFromJson(json);
}
