import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kc_admin_portal/shared/models/clock_time.dart';
import 'package:kc_admin_portal/shared/models/json_converters.dart';
import 'package:kc_admin_portal/shared/models/named_ref.dart';

part 'work_schedule_model.freezed.dart';
part 'work_schedule_model.g.dart';

/// One version of an employee's working schedule. A change creates a new
/// version from its `effectiveFrom` date, so past days keep the schedule
/// they were worked under.
///
/// `expectedMinutes` = end − start − break, computed by the backend.
@freezed
abstract class WorkScheduleModel with _$WorkScheduleModel {
  const factory WorkScheduleModel({
    @JsonKey(fromJson: idFromJson) required String id,
    @DateOnlyConverter() required DateTime effectiveFrom,

    /// Null while this version is current.
    @DateOnlyConverter() DateTime? effectiveTo,
    @ClockTimeConverter() required ClockTime startTime,
    @ClockTimeConverter() required ClockTime endTime,
    required int breakMinutes,
    @ClockTimeConverter() ClockTime? breakStart,
    @ClockTimeConverter() ClockTime? breakEnd,

    /// ISO weekdays: 1 = Monday … 7 = Sunday.
    required List<int> weeklyOffDays,
    required int expectedMinutes,
    NamedRef? createdBy,
    @CompanyDateTimeConverter() DateTime? createdAt,
  }) = _WorkScheduleModel;

  factory WorkScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$WorkScheduleModelFromJson(json);
}

/// The schedule that applied on one date, as embedded in attendance records
/// and calendar days.
@freezed
abstract class ScheduleSnapshotModel with _$ScheduleSnapshotModel {
  const factory ScheduleSnapshotModel({
    @ClockTimeConverter() required ClockTime startTime,
    @ClockTimeConverter() required ClockTime endTime,
    required int expectedMinutes,
  }) = _ScheduleSnapshotModel;

  factory ScheduleSnapshotModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleSnapshotModelFromJson(json);
}

/// Body of `POST /employees/{id}/schedules`, and `schedule` inside
/// `POST /employees`. The backend computes the expected minutes.
@freezed
abstract class WorkScheduleInput with _$WorkScheduleInput {
  const factory WorkScheduleInput({
    @DateOnlyConverter() required DateTime effectiveFrom,
    @ClockTimeConverter() required ClockTime startTime,
    @ClockTimeConverter() required ClockTime endTime,
    required int breakMinutes,
    @ClockTimeConverter() ClockTime? breakStart,
    @ClockTimeConverter() ClockTime? breakEnd,
    required List<int> weeklyOffDays,
  }) = _WorkScheduleInput;

  factory WorkScheduleInput.fromJson(Map<String, dynamic> json) =>
      _$WorkScheduleInputFromJson(json);
}
