import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kc_admin_portal/shared/models/json_converters.dart';

part 'holiday_model.freezed.dart';
part 'holiday_model.g.dart';

/// A company holiday: applies to every employee, is never counted as a
/// working day or an absence, and is not counted in leave days.
@freezed
abstract class HolidayModel with _$HolidayModel {
  const factory HolidayModel({
    @JsonKey(fromJson: idFromJson) required String id,
    @DateOnlyConverter() required DateTime date,
    required String name,
    String? description,
  }) = _HolidayModel;

  factory HolidayModel.fromJson(Map<String, dynamic> json) =>
      _$HolidayModelFromJson(json);
}

/// Body of `POST /holidays` and `PATCH /holidays/{id}`.
@freezed
abstract class HolidayInput with _$HolidayInput {
  const factory HolidayInput({
    @DateOnlyConverter() required DateTime date,
    required String name,
    String? description,
  }) = _HolidayInput;

  factory HolidayInput.fromJson(Map<String, dynamic> json) =>
      _$HolidayInputFromJson(json);
}
