// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holiday_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HolidayModel _$HolidayModelFromJson(Map<String, dynamic> json) =>
    _HolidayModel(
      id: idFromJson(json['id']),
      date: const DateOnlyConverter().fromJson(json['date'] as String),
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$HolidayModelToJson(_HolidayModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': const DateOnlyConverter().toJson(instance.date),
      'name': instance.name,
      'description': instance.description,
    };

_HolidayInput _$HolidayInputFromJson(Map<String, dynamic> json) =>
    _HolidayInput(
      date: const DateOnlyConverter().fromJson(json['date'] as String),
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$HolidayInputToJson(_HolidayInput instance) =>
    <String, dynamic>{
      'date': const DateOnlyConverter().toJson(instance.date),
      'name': instance.name,
      'description': instance.description,
    };
