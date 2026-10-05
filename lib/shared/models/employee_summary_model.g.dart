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
  department: $enumDecodeNullable(
    _$JobRoleEnumMap,
    json['department'],
    unknownValue: JobRole.unknown,
  ),
  position: $enumDecodeNullable(
    _$JobRoleEnumMap,
    json['position'],
    unknownValue: JobRole.unknown,
  ),
);

Map<String, dynamic> _$EmployeeSummaryModelToJson(
  _EmployeeSummaryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'ecNumber': instance.ecNumber,
  'department': _$JobRoleEnumMap[instance.department],
  'position': _$JobRoleEnumMap[instance.position],
};

const _$JobRoleEnumMap = {
  JobRole.accountant: 'accountant',
  JobRole.graphicDesigner: 'graphic_designer',
  JobRole.tailor: 'tailor',
  JobRole.unknown: 'unknown',
};
