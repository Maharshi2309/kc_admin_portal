// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CatalogItemModel _$CatalogItemModelFromJson(Map<String, dynamic> json) =>
    _CatalogItemModel(
      id: idFromJson(json['id']),
      name: json['name'] as String,
      isActive: json['isActive'] as bool? ?? true,
      employeeCount: (json['employeeCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CatalogItemModelToJson(_CatalogItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isActive': instance.isActive,
      'employeeCount': instance.employeeCount,
    };

_OrganizationSettingsModel _$OrganizationSettingsModelFromJson(
  Map<String, dynamic> json,
) => _OrganizationSettingsModel(
  ecNumberPrefix: json['ecNumberPrefix'] as String,
  lateGraceMinutes: (json['lateGraceMinutes'] as num).toInt(),
  defaultSchedule: DefaultScheduleModel.fromJson(
    json['defaultSchedule'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$OrganizationSettingsModelToJson(
  _OrganizationSettingsModel instance,
) => <String, dynamic>{
  'ecNumberPrefix': instance.ecNumberPrefix,
  'lateGraceMinutes': instance.lateGraceMinutes,
  'defaultSchedule': instance.defaultSchedule.toJson(),
};

_DefaultScheduleModel _$DefaultScheduleModelFromJson(
  Map<String, dynamic> json,
) => _DefaultScheduleModel(
  startTime: const ClockTimeConverter().fromJson(json['startTime'] as String),
  endTime: const ClockTimeConverter().fromJson(json['endTime'] as String),
  breakMinutes: (json['breakMinutes'] as num).toInt(),
  breakStart: _$JsonConverterFromJson<String, ClockTime>(
    json['breakStart'],
    const ClockTimeConverter().fromJson,
  ),
  weeklyOffDays: (json['weeklyOffDays'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$DefaultScheduleModelToJson(
  _DefaultScheduleModel instance,
) => <String, dynamic>{
  'startTime': const ClockTimeConverter().toJson(instance.startTime),
  'endTime': const ClockTimeConverter().toJson(instance.endTime),
  'breakMinutes': instance.breakMinutes,
  'breakStart': _$JsonConverterToJson<String, ClockTime>(
    instance.breakStart,
    const ClockTimeConverter().toJson,
  ),
  'weeklyOffDays': instance.weeklyOffDays,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_LeavePolicyModel _$LeavePolicyModelFromJson(Map<String, dynamic> json) =>
    _LeavePolicyModel(
      paidLeaveEnabled: json['paidLeaveEnabled'] as bool,
      paidLeaveName: json['paidLeaveName'] as String,
      unpaidLeaveName: json['unpaidLeaveName'] as String,
      daysPerMonth: (json['daysPerMonth'] as num).toDouble(),
      carryForwardCap: (json['carryForwardCap'] as num?)?.toDouble(),
      accrualStartMonth: const DateOnlyConverter().fromJson(
        json['accrualStartMonth'] as String,
      ),
    );

Map<String, dynamic> _$LeavePolicyModelToJson(_LeavePolicyModel instance) =>
    <String, dynamic>{
      'paidLeaveEnabled': instance.paidLeaveEnabled,
      'paidLeaveName': instance.paidLeaveName,
      'unpaidLeaveName': instance.unpaidLeaveName,
      'daysPerMonth': instance.daysPerMonth,
      'carryForwardCap': instance.carryForwardCap,
      'accrualStartMonth': const DateOnlyConverter().toJson(
        instance.accrualStartMonth,
      ),
    };
