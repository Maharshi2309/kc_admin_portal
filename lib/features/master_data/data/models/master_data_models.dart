import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kc_admin_portal/shared/models/json_converters.dart';

part 'master_data_models.freezed.dart';
part 'master_data_models.g.dart';

/// A department, from `GET /departments`.
@freezed
abstract class DepartmentModel with _$DepartmentModel {
  const factory DepartmentModel({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,

    /// Shown as "18 people" in the department picker when sent.
    int? employeeCount,
  }) = _DepartmentModel;

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentModelFromJson(json);
}

/// A designation within a department, from
/// `GET /departments/:id/designations`.
@freezed
abstract class DesignationModel with _$DesignationModel {
  const factory DesignationModel({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,
  }) = _DesignationModel;

  factory DesignationModel.fromJson(Map<String, dynamic> json) =>
      _$DesignationModelFromJson(json);
}
