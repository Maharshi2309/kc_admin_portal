// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PermissionModuleModel _$PermissionModuleModelFromJson(
  Map<String, dynamic> json,
) => _PermissionModuleModel(
  module: json['module'] as String,
  label: json['label'] as String,
  permissions: (json['permissions'] as List<dynamic>)
      .map((e) => PermissionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PermissionModuleModelToJson(
  _PermissionModuleModel instance,
) => <String, dynamic>{
  'module': instance.module,
  'label': instance.label,
  'permissions': instance.permissions.map((e) => e.toJson()).toList(),
};

_PermissionModel _$PermissionModelFromJson(Map<String, dynamic> json) =>
    _PermissionModel(
      key: json['key'] as String,
      action: json['action'] as String,
      label: json['label'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$PermissionModelToJson(_PermissionModel instance) =>
    <String, dynamic>{
      'key': instance.key,
      'action': instance.action,
      'label': instance.label,
      'description': instance.description,
    };
