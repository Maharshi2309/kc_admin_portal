import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_balance_model.freezed.dart';
part 'leave_balance_model.g.dart';

/// An employee's balance for one leave type, calculated by the backend.
///
/// TODO — REQUIREMENT CONFIRMATION REQUIRED: leave types, yearly quotas and
/// pro-rating rules are not final; the app only displays these values.
@freezed
abstract class LeaveBalanceModel with _$LeaveBalanceModel {
  const factory LeaveBalanceModel({
    /// Matches `LeaveTypeModel.id`, so the leave drawer can show each
    /// type's balance.
    String? leaveTypeId,
    required String leaveType,

    /// Days allowed per year; `null` when the type is not limited by a
    /// balance (e.g. unpaid leave).
    double? quota,
    required double used,
    double? remaining,
  }) = _LeaveBalanceModel;

  factory LeaveBalanceModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveBalanceModelFromJson(json);
}
