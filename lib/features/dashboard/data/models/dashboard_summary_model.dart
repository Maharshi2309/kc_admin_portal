import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kc_admin_portal/shared/models/employee_summary_model.dart';
import 'package:kc_admin_portal/shared/models/holiday_model.dart';

import 'package:kc_admin_portal/shared/models/json_converters.dart';

part 'dashboard_summary_model.freezed.dart';
part 'dashboard_summary_model.g.dart';

/// Response of `GET /dashboard/summary?date=YYYY-MM-DD`.
///
/// All numbers, percentages included, are calculated by the backend; the
/// app only displays them. Optional values are hidden when absent.
///
/// V2 (approved 2026-09-30): holidays and weekly offs are never counted as
/// absences, and today's figures cover only employees scheduled to work.
///
/// Leave statistics are [LeaveUsageModel] (Casual and Unpaid kept apart,
/// 2026-10-05).
///
/// TODO — REQUIREMENT CONFIRMATION REQUIRED: the requirement document also
/// lists Total Working Employees, Leave Percentage and more charts (Present
/// vs Absent, Leave utilization) which the design does not show. Add them
/// here once the final dashboard content is confirmed.
@freezed
abstract class DashboardSummaryModel with _$DashboardSummaryModel {
  const factory DashboardSummaryModel({
    @DateOnlyConverter() required DateTime date,
    required int totalEmployees,

    /// Active employees expected at work today (V2): today is a working day
    /// on their schedule, not a company holiday or their weekly off. Present,
    /// on leave and absent are counted among them only, and the percentages
    /// are shares of this number. Null from an older backend.
    int? scheduledToday,
    required int presentToday,
    required int onLeaveToday,
    required int absentToday,
    double? presentPercent,
    double? onLeavePercent,
    double? absentPercent,

    /// Today's company holiday, if any (V2): nobody is absent on it.
    HolidayModel? holiday,

    /// Active employees whose weekly off is today, working or not (V2).
    @Default(0) int weekOffToday,

    /// Employees working today on a company holiday or on their weekly off
    /// (V2). Their hours count as overtime.
    @Default(0) int holidayWorkedToday,
    @Default(0) int weekOffWorkedToday,

    /// Overtime of all employees from the 1st of the month to [date], in
    /// minutes (V2). Null when the caller lacks `overtime.view`.
    int? overtimeMinutesThisMonth,

    /// How many employees have any overtime this month (V2).
    int? overtimeEmployeesThisMonth,
    @Default(<AttentionItemModel>[]) List<AttentionItemModel> attention,

    /// A short preview; [notPunchedInTotal] is the full count.
    @Default(<EmployeeSummaryModel>[]) List<EmployeeSummaryModel> notPunchedIn,
    @Default(0) int notPunchedInTotal,

    /// A short preview; [onLeaveToday] is the full count.
    @Default(<LeaveTodayModel>[]) List<LeaveTodayModel> onLeave,
    LeaveUsageModel? leaveUsage,
  }) = _DashboardSummaryModel;

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryModelFromJson(json);
}

/// Kinds of "Needs your attention" items. The backend decides which apply
/// (e.g. "late" depends on attendance rules still to be confirmed); unknown
/// kinds from a newer backend are ignored.
@JsonEnum(fieldRename: FieldRename.snake)
enum AttentionKind { notPunchedIn, pendingLeave, lateArrival, unknown }

@freezed
abstract class AttentionItemModel with _$AttentionItemModel {
  const factory AttentionItemModel({
    @JsonKey(unknownEnumValue: AttentionKind.unknown)
    required AttentionKind kind,
    required int count,
  }) = _AttentionItemModel;

  factory AttentionItemModel.fromJson(Map<String, dynamic> json) =>
      _$AttentionItemModelFromJson(json);
}

/// An employee on leave today.
@freezed
abstract class LeaveTodayModel with _$LeaveTodayModel {
  const factory LeaveTodayModel({
    required EmployeeSummaryModel employee,

    /// Display name of the leave type, as defined on the backend.
    required String leaveType,
    @DateOnlyConverter() required DateTime endDate,

    /// Leave length in days as counted by the backend (may be fractional).
    required double days,
    @Default(false) bool isHalfDay,
  }) = _LeaveTodayModel;

  factory LeaveTodayModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveTodayModelFromJson(json);
}

/// Organisation-wide leave figures (changed 2026-10-05): Casual (paid) and
/// Unpaid are kept apart, and Unpaid never counts as remaining paid leave.
@freezed
abstract class LeaveUsageModel with _$LeaveUsageModel {
  const factory LeaveUsageModel({
    required int year,

    /// Casual days left today, summed over active employees.
    required double casualRemainingDays,

    /// Approved Casual days dated in [year].
    required double casualTakenDays,

    /// Approved Unpaid days dated in [year].
    required double unpaidTakenDays,

    /// Leave requests whose dates overlap the current month, by status.
    @Default(0) int approvedThisMonth,
    @Default(0) int pendingThisMonth,
    @Default(0) int rejectedThisMonth,
  }) = _LeaveUsageModel;

  factory LeaveUsageModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveUsageModelFromJson(json);
}
