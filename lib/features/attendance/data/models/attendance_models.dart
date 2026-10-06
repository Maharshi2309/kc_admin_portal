import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kc_admin_portal/core/utils/duration_format.dart';
import 'package:kc_admin_portal/shared/models/employee_summary_model.dart';
import 'package:kc_admin_portal/shared/models/json_converters.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/models/work_schedule_model.dart';

part 'attendance_models.freezed.dart';
part 'attendance_models.g.dart';

/// One employee's attendance on one date.
///
/// Status, worked time and notes such as "23 min late" are decided by the
/// backend (confirmed default 2026-09-30); the app only displays them.
@freezed
abstract class AttendanceRecordModel with _$AttendanceRecordModel {
  const factory AttendanceRecordModel({
    /// `null` when nothing is recorded yet (not punched in).
    @JsonKey(fromJson: _optionalId) String? id,
    required EmployeeSummaryModel employee,
    @DateOnlyConverter() required DateTime date,
    @CompanyDateTimeConverter() DateTime? punchIn,
    @CompanyDateTimeConverter() DateTime? punchOut,
    int? workedMinutes,

    /// Share of the shift worked, 0–100, for the progress bar.
    double? workedPercent,
    @JsonKey(unknownEnumValue: AttendanceDayStatus.unknown)
    required AttendanceDayStatus status,

    /// Short explanation from the backend, e.g. "Leave 2nd half". Never a
    /// duration: those come as numbers (e.g. [lateMinutes]) and are
    /// formatted by the app.
    String? note,

    /// How late the punch-in was, after the grace period's start time; null
    /// when on time.
    int? lateMinutes,
    String? correctedBy,
    @CompanyDateTimeConverter() DateTime? correctedAt,

    /// Work on a holiday or weekly off is recorded as its own kind.
    @JsonKey(unknownEnumValue: AttendanceDayKind.unknown)
    @Default(AttendanceDayKind.working)
    AttendanceDayKind dayKind,

    /// The employee's schedule on [date]; null on holidays and weekly offs.
    ScheduleSnapshotModel? schedule,

    /// 0 on holidays and weekly offs; halved on half-day leave.
    int? expectedMinutes,
    int? overtimeMinutes,
  }) = _AttendanceRecordModel;

  const AttendanceRecordModel._();

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRecordModelFromJson(json);

  /// What to show under the status: "Late by 3 Hours 53 Minutes", else the
  /// backend's [note].
  String? get displayNote {
    final late = lateMinutes;
    return late != null && late > 0
        ? 'Late by ${DurationFormat.full(late)}'
        : note;
  }
}

String? _optionalId(Object? value) => value?.toString();

/// Counts and shift for one date (the status tiles).
@freezed
abstract class AttendanceDaySummaryModel with _$AttendanceDaySummaryModel {
  const factory AttendanceDaySummaryModel({
    @DateOnlyConverter() required DateTime date,

    /// "09:30"; shown only when the backend sends it.
    String? shiftStart,
    String? shiftEnd,
    required int totalEmployees,
    required int present,
    required int late,
    required int onLeave,
    required int absent,

    /// Active employees with no punch-in yet (for the reminder banner).
    required int notPunchedIn,
  }) = _AttendanceDaySummaryModel;

  factory AttendanceDaySummaryModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceDaySummaryModelFromJson(json);
}

/// Response of `GET /attendance`: the day's summary plus one page of rows.
@freezed
abstract class AttendanceDayModel with _$AttendanceDayModel {
  const factory AttendanceDayModel({
    required AttendanceDaySummaryModel summary,
    required List<AttendanceRecordModel> items,
    required int total,
    required int page,
    required int pageSize,
  }) = _AttendanceDayModel;

  const AttendanceDayModel._();

  factory AttendanceDayModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceDayModelFromJson(json);

  bool get hasMore => page * pageSize < total;
}

/// Status tiles, which double as the list filter.
enum AttendanceFilter {
  all('All employees', 'Everyone'),
  present('Present', 'Present'),
  late('Late', 'Late'),
  onLeave('On leave', 'On leave'),
  absent('Absent', 'Absent');

  const AttendanceFilter(this.label, this.listTitle);

  final String label;
  final String listTitle;

  /// Value of the `status` query parameter.
  String? get apiValue => switch (this) {
    all => null,
    present => 'present',
    late => 'late',
    onLeave => 'on_leave',
    absent => 'absent',
  };

  int countIn(AttendanceDaySummaryModel summary) => switch (this) {
    all => summary.totalEmployees,
    present => summary.present,
    late => summary.late,
    onLeave => summary.onLeave,
    absent => summary.absent,
  };
}

@freezed
abstract class AttendanceQuery with _$AttendanceQuery {
  const factory AttendanceQuery({
    @DateOnlyConverter() required DateTime date,
    @Default(AttendanceFilter.all) AttendanceFilter filter,
    @Default('') String search,
    String? department,
  }) = _AttendanceQuery;

  const AttendanceQuery._();

  static const int pageSize = 20;

  Map<String, Object?> toQueryParameters(int page) => {
    'date': dateToJson(date),
    'status': ?filter.apiValue,
    if (search.isNotEmpty) 'search': search,
    'department': ?department,
    'page': page,
    'pageSize': pageSize,
  };
}

/// Why an admin changed a record.
///
/// TODO — REQUIREMENT CONFIRMATION REQUIRED: the list comes from the design;
/// it may move to the backend.
@JsonEnum(fieldRename: FieldRename.snake)
enum CorrectionReason {
  forgotToPunch('Forgot to punch'),
  deviceIssue('Device issue'),
  onFieldDuty('On field duty'),
  wrongTimeRecorded('Wrong time recorded'),
  other('Other');

  const CorrectionReason(this.label);

  final String label;
}

/// Body of `PATCH /attendance/:id` (correction) and `POST /attendance`
/// (adding a missing record).
@freezed
abstract class AttendanceCorrectionData with _$AttendanceCorrectionData {
  const factory AttendanceCorrectionData({
    /// Only for a new record.
    String? employeeId,
    @JsonKey(toJson: dateToJson) @DateOnlyConverter() required DateTime date,
    @CompanyDateTimeConverter() required DateTime punchIn,
    @CompanyDateTimeConverter() DateTime? punchOut,
    required CorrectionReason reason,
    String? remarks,
  }) = _AttendanceCorrectionData;

  factory AttendanceCorrectionData.fromJson(Map<String, dynamic> json) =>
      _$AttendanceCorrectionDataFromJson(json);
}
