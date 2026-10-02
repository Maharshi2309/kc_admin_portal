import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kc_admin_portal/shared/models/json_converters.dart';

part 'employee_summary_model.freezed.dart';
part 'employee_summary_model.g.dart';

/// The few employee fields shown wherever an employee is listed inside
/// another record (dashboard lists, attendance rows, leave rows).
@freezed
abstract class EmployeeSummaryModel with _$EmployeeSummaryModel {
  const factory EmployeeSummaryModel({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,
    required String ecNumber,
    String? department,
    String? designation,
  }) = _EmployeeSummaryModel;

  factory EmployeeSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeSummaryModelFromJson(json);
}
