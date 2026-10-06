import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kc_admin_portal/shared/models/json_converters.dart';
import 'package:kc_admin_portal/shared/models/named_ref.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/models/work_schedule_model.dart';

part 'employee_models.freezed.dart';
part 'employee_models.g.dart';

/// An employee record. Fields are the design's final set (confirmed
/// 2026-09-29).
@freezed
abstract class EmployeeModel with _$EmployeeModel {
  const factory EmployeeModel({
    @JsonKey(fromJson: idFromJson) required String id,

    /// The organization's prefix followed by digits, e.g. "KC1001".
    required String ecNumber,
    required String name,

    /// 10 digits without the country code, e.g. "9825011234".
    required String mobile,

    /// The organization's own department and position (2026-10-06).
    required NamedRef department,
    required NamedRef position,
    @DateOnlyConverter() required DateTime joiningDate,
    @JsonKey(unknownEnumValue: EmployeeStatus.unknown)
    required EmployeeStatus status,

    /// Today's attendance, when the list endpoint includes it.
    @JsonKey(unknownEnumValue: AttendanceDayStatus.unknown)
    AttendanceDayStatus? todayStatus,
    @CompanyDateTimeConverter() DateTime? updatedAt,
    String? updatedBy,

    /// The schedule in effect today (history: `GET /employees/{id}/schedules`).
    WorkScheduleModel? schedule,

    /// Overtime from 1 January of the current year (company time) to today,
    /// in minutes, calculated by the backend from the attendance records.
    /// Null when the caller lacks `overtime.view`, or from an older backend.
    int? overtimeMinutesThisYear,
  }) = _EmployeeModel;

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);
}

/// Body of `POST /employees` and `PATCH /employees/:id`.
@freezed
abstract class EmployeeFormData with _$EmployeeFormData {
  const factory EmployeeFormData({
    required String ecNumber,
    required String name,
    required String mobile,

    /// Ids from the organization's lists (`GET /departments`,
    /// `GET /positions`).
    required String departmentId,
    required String positionId,
    @JsonKey(toJson: dateToJson) required DateTime joiningDate,
    required EmployeeStatus status,

    /// Only when creating; later changes add a schedule version instead.
    @JsonKey(includeIfNull: false) WorkScheduleInput? schedule,
  }) = _EmployeeFormData;

  factory EmployeeFormData.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFormDataFromJson(json);
}

/// Response of `GET /employees`: one page plus the active / inactive
/// totals for the page subtitle ("124 active · 4 inactive").
@freezed
abstract class EmployeeListModel with _$EmployeeListModel {
  const factory EmployeeListModel({
    required List<EmployeeModel> items,
    required int total,
    required int page,
    required int pageSize,

    /// Totals for the current search and filters, ignoring the status
    /// filter. Optional: the subtitle falls back to [total] without it.
    EmployeeStatusCounts? counts,
  }) = _EmployeeListModel;

  factory EmployeeListModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeListModelFromJson(json);
}

@freezed
abstract class EmployeeStatusCounts with _$EmployeeStatusCounts {
  const factory EmployeeStatusCounts({
    required int active,
    required int inactive,
  }) = _EmployeeStatusCounts;

  factory EmployeeStatusCounts.fromJson(Map<String, dynamic> json) =>
      _$EmployeeStatusCountsFromJson(json);
}

/// Search, filters and page of the employee list.
@freezed
abstract class EmployeeQuery with _$EmployeeQuery {
  const factory EmployeeQuery({
    @Default('') String search,
    String? departmentId,
    String? positionId,

    /// "Joined" filter (design board 03): joining date within this range.
    @DateOnlyConverter() DateTime? joinedFrom,
    @DateOnlyConverter() DateTime? joinedTo,

    /// The design opens the list filtered to active employees.
    @Default(EmployeeStatus.active) EmployeeStatus? status,
    @Default(1) int page,
    @Default(EmployeeQuery.defaultPageSize) int pageSize,
  }) = _EmployeeQuery;

  const EmployeeQuery._();

  static const int defaultPageSize = 10;

  bool get hasFilters =>
      search.isNotEmpty ||
      departmentId != null ||
      positionId != null ||
      joinedFrom != null ||
      status != EmployeeStatus.active;

  Map<String, Object?> toQueryParameters() => {
    if (search.isNotEmpty) 'search': search,
    'departmentId': ?departmentId,
    'positionId': ?positionId,
    if (joinedFrom != null) 'joinedFrom': dateToJson(joinedFrom!),
    if (joinedTo != null) 'joinedTo': dateToJson(joinedTo!),
    'status': ?status?.name,
    'page': page,
    'pageSize': pageSize,
  };
}

/// One leave in an employee's history (`GET /employees/:id/leaves`).
@freezed
abstract class LeaveHistoryItemModel with _$LeaveHistoryItemModel {
  const factory LeaveHistoryItemModel({
    @JsonKey(fromJson: idFromJson) required String id,
    @DateOnlyConverter() required DateTime startDate,
    @DateOnlyConverter() required DateTime endDate,
    required String leaveType,
    required double days,
    String? reason,
    @JsonKey(unknownEnumValue: LeaveStatus.unknown) required LeaveStatus status,

    /// Paid (Casual) or Unpaid.
    @Default(true) bool isPaid,

    /// Casual days left after this leave (date order); null for unpaid or
    /// rejected / cancelled leave.
    double? balanceAfter,
  }) = _LeaveHistoryItemModel;

  factory LeaveHistoryItemModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveHistoryItemModelFromJson(json);
}
