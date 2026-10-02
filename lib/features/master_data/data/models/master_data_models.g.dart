// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_data_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DepartmentModel _$DepartmentModelFromJson(Map<String, dynamic> json) =>
    _DepartmentModel(
      id: idFromJson(json['id']),
      name: json['name'] as String,
      employeeCount: (json['employeeCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DepartmentModelToJson(_DepartmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'employeeCount': instance.employeeCount,
    };

_DesignationModel _$DesignationModelFromJson(Map<String, dynamic> json) =>
    _DesignationModel(id: idFromJson(json['id']), name: json['name'] as String);

Map<String, dynamic> _$DesignationModelToJson(_DesignationModel instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
