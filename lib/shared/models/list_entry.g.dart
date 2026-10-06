// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ListEntry _$ListEntryFromJson(Map<String, dynamic> json) => _ListEntry(
  id: idFromJson(json['id']),
  code: json['code'] as String,
  name: json['name'] as String,
  employeeCount: (json['employeeCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ListEntryToJson(_ListEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'employeeCount': instance.employeeCount,
    };
