import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kc_admin_portal/shared/models/json_converters.dart';

part 'leave_balance_model.freezed.dart';
part 'leave_balance_model.g.dart';

/// An employee's paid (Casual) leave balance, calculated by the backend
/// from the leave records, never stored (approved 2026-10-05):
///
/// - 1 Casual day is earned each month, carried forward without limit;
/// - leave can't use a future month's day;
/// - Unpaid leave has no balance; [unpaidTaken] only counts it.
///
/// `remaining = accrued − used − pending`.
@freezed
abstract class LeaveBalanceModel with _$LeaveBalanceModel {
  const factory LeaveBalanceModel({
    /// The day the figures are for (today, company time).
    @DateOnlyConverter() required DateTime asOf,

    /// Casual days earned up to and including the current month.
    required double accrued,

    /// Approved Casual days (including leave booked for later dates).
    required double used,

    /// Pending Casual days: reserved until approved or rejected.
    @Default(0) double pending,
    required double remaining,

    /// Approved Unpaid days.
    @Default(0) double unpaidTaken,
  }) = _LeaveBalanceModel;

  factory LeaveBalanceModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveBalanceModelFromJson(json);
}
