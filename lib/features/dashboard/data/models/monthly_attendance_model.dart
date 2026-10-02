import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kc_admin_portal/shared/models/json_converters.dart';

part 'monthly_attendance_model.freezed.dart';
part 'monthly_attendance_model.g.dart';

/// Response of `GET /dashboard/attendance-chart?month=YYYY-MM`: the daily
/// attendance percentage for each working day recorded so far.
@freezed
abstract class MonthlyAttendanceModel with _$MonthlyAttendanceModel {
  const factory MonthlyAttendanceModel({
    @DateOnlyConverter() required DateTime month,
    double? averagePercent,
    @Default(<DailyAttendanceModel>[]) List<DailyAttendanceModel> days,
  }) = _MonthlyAttendanceModel;

  factory MonthlyAttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyAttendanceModelFromJson(json);
}

@freezed
abstract class DailyAttendanceModel with _$DailyAttendanceModel {
  const factory DailyAttendanceModel({
    @DateOnlyConverter() required DateTime date,

    /// 0–100, calculated by the backend: employees present as a share of
    /// those scheduled to work that day (V2). Days nobody was scheduled
    /// (company holidays, everyone's weekly off) are left out of [days].
    required double percent,
  }) = _DailyAttendanceModel;

  factory DailyAttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$DailyAttendanceModelFromJson(json);
}
