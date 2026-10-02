// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EmployeeSummaryModel _$EmployeeSummaryModelFromJson(
  Map<String, dynamic> json,
) => _EmployeeSummaryModel(
  id: idFromJson(json['id']),
  name: json['name'] as String,
  ecNumber: json['ecNumber'] as String,
  department: json['department'] as String?,
  designation: json['designation'] as String?,
);

Map<String, dynamic> _$EmployeeSummaryModelToJson(
  _EmployeeSummaryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'ecNumber': instance.ecNumber,
  'department': instance.department,
  'designation': instance.designation,
};
