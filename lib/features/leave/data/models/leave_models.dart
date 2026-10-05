import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kc_admin_portal/shared/models/employee_summary_model.dart';
import 'package:kc_admin_portal/shared/models/holiday_model.dart';
import 'package:kc_admin_portal/shared/models/job_role.dart';
import 'package:kc_admin_portal/shared/models/json_converters.dart';
import 'package:kc_admin_portal/shared/models/leave_balance_model.dart';
import 'package:kc_admin_portal/shared/models/named_ref.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

part 'leave_models.freezed.dart';
part 'leave_models.g.dart';

/// A leave type from `GET /leave-types`: Casual (paid) and Unpaid
/// (approved 2026-10-05; Sick and Earned are retired).
@freezed
abstract class LeaveTypeModel with _$LeaveTypeModel {
  const factory LeaveTypeModel({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,

    /// False for types not limited by a balance (Unpaid).
    @Default(true) bool hasBalance,

    /// Paid leave (Casual) uses the monthly balance; Unpaid doesn't.
    @Default(true) bool isPaid,
  }) = _LeaveTypeModel;

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveTypeModelFromJson(json);
}

/// A leave record.
@freezed
abstract class LeaveModel with _$LeaveModel {
  const factory LeaveModel({
    @JsonKey(fromJson: idFromJson) required String id,
    required EmployeeSummaryModel employee,
    required NamedRef leaveType,
    @DateOnlyConverter() required DateTime startDate,
    @DateOnlyConverter() required DateTime endDate,

    /// Counted by the backend (weekly offs and holidays excluded).
    required double days,
    @Default(false) bool isHalfDay,
    @JsonKey(unknownEnumValue: LeaveReason.other) required LeaveReason reason,
    String? remarks,
    @JsonKey(unknownEnumValue: LeaveStatus.unknown) required LeaveStatus status,

    /// Who created it, as shown in the design: "Admin" or "Employee request".
    String? addedBy,

    /// Paid (Casual) or Unpaid, from the leave type.
    @Default(true) bool isPaid,

    /// Casual days left after this leave, counting leave in date order.
    /// Only on paid leave that counts (approved or pending).
    double? balanceAfter,

    /// When a request was split, the Unpaid leave saved with it.
    String? unpaidPartId,
  }) = _LeaveModel;

  const LeaveModel._();

  factory LeaveModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveModelFromJson(json);

  /// Pending requests can be approved or rejected (design board 08).
  bool get canDecide => status == LeaveStatus.pending;

  /// Only pending leave can be edited (approved 2026-09-30). The backend
  /// enforces it (409 `LEAVE_NOT_EDITABLE`); this only shapes the UI.
  bool get canEdit => status == LeaveStatus.pending;

  /// Pending and approved leave can be cancelled; it stays in the history.
  bool get canCancel =>
      status == LeaveStatus.pending || status == LeaveStatus.approved;
}

/// Reason chips from the design's Add leave drawer.
@JsonEnum(fieldRename: FieldRename.snake)
enum LeaveReason {
  personalWork('Personal work'),
  familyFunction('Family function'),
  medical('Medical'),
  travel('Travel'),
  other('Other');

  const LeaveReason(this.label);

  final String label;
}

/// Counts for the design's status tabs.
@freezed
abstract class LeaveStatusCounts with _$LeaveStatusCounts {
  const factory LeaveStatusCounts({
    required int all,
    required int pending,
    required int approved,
    required int rejected,
    required int cancelled,
  }) = _LeaveStatusCounts;

  const LeaveStatusCounts._();

  factory LeaveStatusCounts.fromJson(Map<String, dynamic> json) =>
      _$LeaveStatusCountsFromJson(json);

  int of(LeaveStatus? status) => switch (status) {
    null => all,
    LeaveStatus.pending => pending,
    LeaveStatus.approved => approved,
    LeaveStatus.rejected => rejected,
    LeaveStatus.cancelled => cancelled,
    LeaveStatus.unknown => 0,
  };
}

/// Response of `GET /leaves`: one page plus the tab counts.
@freezed
abstract class LeaveListModel with _$LeaveListModel {
  const factory LeaveListModel({
    required List<LeaveModel> items,
    required int total,
    required int page,
    required int pageSize,
    required LeaveStatusCounts counts,
  }) = _LeaveListModel;

  factory LeaveListModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveListModelFromJson(json);
}

/// Tab, search, filters and page of the leave list.
@freezed
abstract class LeaveQuery with _$LeaveQuery {
  const factory LeaveQuery({
    /// `null` = "All" tab.
    LeaveStatus? status,
    @Default('') String search,
    DateTime? from,
    DateTime? to,
    String? leaveTypeId,
    JobRole? department,
    @Default(1) int page,
    @Default(LeaveQuery.defaultPageSize) int pageSize,
  }) = _LeaveQuery;

  const LeaveQuery._();

  static const int defaultPageSize = 10;

  bool get hasFilters =>
      search.isNotEmpty ||
      from != null ||
      leaveTypeId != null ||
      department != null;

  Map<String, Object?> toQueryParameters() => {
    'status': ?status?.name,
    if (search.isNotEmpty) 'search': search,
    if (from != null) 'from': dateToJson(from!),
    if (to != null) 'to': dateToJson(to!),
    'leaveTypeId': ?leaveTypeId,
    'department': ?department?.code,
    'page': page,
    'pageSize': pageSize,
  };
}

/// Body of `POST /leaves` and `PATCH /leaves/:id`.
@freezed
abstract class LeaveFormData with _$LeaveFormData {
  const factory LeaveFormData({
    required String employeeId,
    required String leaveTypeId,
    @JsonKey(toJson: dateToJson) required DateTime startDate,
    @JsonKey(toJson: dateToJson) required DateTime endDate,
    required bool isHalfDay,
    required LeaveReason reason,
    String? remarks,

    /// The design lets the admin save as Approved or Pending.
    required LeaveStatus status,

    /// Casual leave beyond the available balance is saved as a separate
    /// Unpaid leave (the latest days). Without this, such a request is
    /// refused with `INSUFFICIENT_LEAVE_BALANCE`.
    @JsonKey(includeIfNull: false) bool? splitExcessAsUnpaid,
  }) = _LeaveFormData;

  factory LeaveFormData.fromJson(Map<String, dynamic> json) =>
      _$LeaveFormDataFromJson(json);
}

/// Request of `POST /leaves/preview`: what the drawer would save.
@freezed
abstract class LeavePreviewRequest with _$LeavePreviewRequest {
  const factory LeavePreviewRequest({
    required String employeeId,
    required String leaveTypeId,
    @JsonKey(toJson: dateToJson) required DateTime startDate,
    @JsonKey(toJson: dateToJson) required DateTime endDate,
    required bool isHalfDay,

    /// When editing, the leave being changed (its days are given back first).
    String? leaveId,
  }) = _LeavePreviewRequest;

  factory LeavePreviewRequest.fromJson(Map<String, dynamic> json) =>
      _$LeavePreviewRequestFromJson(json);
}

/// The backend's calculation for the drawer: how many days, and how many
/// of them Casual leave can cover now ([paidDays]); the rest would be
/// Unpaid ([unpaidDays]) if the admin agrees to split.
@freezed
abstract class LeavePreviewModel with _$LeavePreviewModel {
  const factory LeavePreviewModel({
    required double days,
    @Default(0) double paidDays,
    @Default(0) double unpaidDays,

    /// Casual days available for these dates; null for Unpaid leave.
    double? availableCasual,
  }) = _LeavePreviewModel;

  const LeavePreviewModel._();

  factory LeavePreviewModel.fromJson(Map<String, dynamic> json) =>
      _$LeavePreviewModelFromJson(json);

  /// Casual leave that doesn't fit the balance.
  bool get needsSplit => availableCasual != null && unpaidDays > 0;
}

/// Non-working days of a month for one employee's date picker
/// (`GET /leave-calendar?month=YYYY-MM&employeeId=…`): company holidays and
/// that employee's weekly offs.
@freezed
abstract class LeaveCalendarModel with _$LeaveCalendarModel {
  const factory LeaveCalendarModel({
    @DateOnlyConverter() required DateTime month,
    @Default(<HolidayModel>[]) List<HolidayModel> holidays,

    /// The employee's weekly offs as ISO weekdays (Monday = 1 … Sunday = 7),
    /// from the schedule in effect on the 1st. Empty without an employee.
    @Default(<int>[]) List<int> weeklyOffDays,

    /// The exact weekly-off dates of the month, which also covers a schedule
    /// that changes mid-month. Preferred over [weeklyOffDays] when present.
    @DateOnlyConverter() @Default(<DateTime>[]) List<DateTime> weekOffDates,
  }) = _LeaveCalendarModel;

  const LeaveCalendarModel._();

  /// Whether [day] is one of the employee's weekly offs.
  bool isWeekOff(DateTime day) => weekOffDates.isNotEmpty
      ? weekOffDates.contains(DateTime(day.year, day.month, day.day))
      : weeklyOffDays.contains(day.weekday);

  factory LeaveCalendarModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveCalendarModelFromJson(json);
}

/// One row of `GET /leave-balances`: an active employee and their Casual
/// balance, calculated like `GET /employees/{id}/leave-balance`.
@freezed
abstract class EmployeeLeaveBalanceModel with _$EmployeeLeaveBalanceModel {
  const factory EmployeeLeaveBalanceModel({
    required EmployeeSummaryModel employee,
    required LeaveBalanceModel balance,
  }) = _EmployeeLeaveBalanceModel;

  factory EmployeeLeaveBalanceModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeLeaveBalanceModelFromJson(json);
}

/// Sums over **every** employee matching the filters (not just one page),
/// for the Leave page's summary.
@freezed
abstract class LeaveBalanceTotalsModel with _$LeaveBalanceTotalsModel {
  const factory LeaveBalanceTotalsModel({
    required int employees,
    required double accrued,
    required double used,
    @Default(0) double pending,
    required double remaining,
    @Default(0) double unpaidTaken,
  }) = _LeaveBalanceTotalsModel;

  factory LeaveBalanceTotalsModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveBalanceTotalsModelFromJson(json);
}

/// `GET /leave-balances`: one page of employees, sorted by name.
@freezed
abstract class LeaveBalanceListModel with _$LeaveBalanceListModel {
  const factory LeaveBalanceListModel({
    required List<EmployeeLeaveBalanceModel> items,
    required int total,
    required int page,
    required int pageSize,
    required LeaveBalanceTotalsModel summary,
  }) = _LeaveBalanceListModel;

  factory LeaveBalanceListModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveBalanceListModelFromJson(json);
}

/// Search, department and page of the Balances tab.
@freezed
abstract class LeaveBalanceQuery with _$LeaveBalanceQuery {
  const factory LeaveBalanceQuery({
    @Default('') String search,
    JobRole? department,
    @Default(1) int page,
    @Default(LeaveQuery.defaultPageSize) int pageSize,
  }) = _LeaveBalanceQuery;

  const LeaveBalanceQuery._();

  bool get hasFilters => search.isNotEmpty || department != null;

  Map<String, Object?> toQueryParameters() => {
    if (search.isNotEmpty) 'search': search,
    'department': ?department?.code,
    'page': page,
    'pageSize': pageSize,
  };
}
