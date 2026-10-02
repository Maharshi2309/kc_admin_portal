// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkScheduleModel _$WorkScheduleModelFromJson(Map<String, dynamic> json) =>
    _WorkScheduleModel(
      id: idFromJson(json['id']),
      effectiveFrom: const DateOnlyConverter().fromJson(
        json['effectiveFrom'] as String,
      ),
      effectiveTo: _$JsonConverterFromJson<String, DateTime>(
        json['effectiveTo'],
        const DateOnlyConverter().fromJson,
      ),
      startTime: const ClockTimeConverter().fromJson(
        json['startTime'] as String,
      ),
      endTime: const ClockTimeConverter().fromJson(json['endTime'] as String),
      breakMinutes: (json['breakMinutes'] as num).toInt(),
      breakStart: _$JsonConverterFromJson<String, ClockTime>(
        json['breakStart'],
        const ClockTimeConverter().fromJson,
      ),
      breakEnd: _$JsonConverterFromJson<String, ClockTime>(
        json['breakEnd'],
        const ClockTimeConverter().fromJson,
      ),
      weeklyOffDays: (json['weeklyOffDays'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      expectedMinutes: (json['expectedMinutes'] as num).toInt(),
      createdBy: json['createdBy'] == null
          ? null
          : NamedRef.fromJson(json['createdBy'] as Map<String, dynamic>),
      createdAt: _$JsonConverterFromJson<String, DateTime>(
        json['createdAt'],
        const CompanyDateTimeConverter().fromJson,
      ),
    );

Map<String, dynamic> _$WorkScheduleModelToJson(_WorkScheduleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'effectiveFrom': const DateOnlyConverter().toJson(instance.effectiveFrom),
      'effectiveTo': _$JsonConverterToJson<String, DateTime>(
        instance.effectiveTo,
        const DateOnlyConverter().toJson,
      ),
      'startTime': const ClockTimeConverter().toJson(instance.startTime),
      'endTime': const ClockTimeConverter().toJson(instance.endTime),
      'breakMinutes': instance.breakMinutes,
      'breakStart': _$JsonConverterToJson<String, ClockTime>(
        instance.breakStart,
        const ClockTimeConverter().toJson,
      ),
      'breakEnd': _$JsonConverterToJson<String, ClockTime>(
        instance.breakEnd,
        const ClockTimeConverter().toJson,
      ),
      'weeklyOffDays': instance.weeklyOffDays,
      'expectedMinutes': instance.expectedMinutes,
      'createdBy': instance.createdBy?.toJson(),
      'createdAt': _$JsonConverterToJson<String, DateTime>(
        instance.createdAt,
        const CompanyDateTimeConverter().toJson,
      ),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_ScheduleSnapshotModel _$ScheduleSnapshotModelFromJson(
  Map<String, dynamic> json,
) => _ScheduleSnapshotModel(
  startTime: const ClockTimeConverter().fromJson(json['startTime'] as String),
  endTime: const ClockTimeConverter().fromJson(json['endTime'] as String),
  expectedMinutes: (json['expectedMinutes'] as num).toInt(),
);

Map<String, dynamic> _$ScheduleSnapshotModelToJson(
  _ScheduleSnapshotModel instance,
) => <String, dynamic>{
  'startTime': const ClockTimeConverter().toJson(instance.startTime),
  'endTime': const ClockTimeConverter().toJson(instance.endTime),
  'expectedMinutes': instance.expectedMinutes,
};

_WorkScheduleInput _$WorkScheduleInputFromJson(Map<String, dynamic> json) =>
    _WorkScheduleInput(
      effectiveFrom: const DateOnlyConverter().fromJson(
        json['effectiveFrom'] as String,
      ),
      startTime: const ClockTimeConverter().fromJson(
        json['startTime'] as String,
      ),
      endTime: const ClockTimeConverter().fromJson(json['endTime'] as String),
      breakMinutes: (json['breakMinutes'] as num).toInt(),
      breakStart: _$JsonConverterFromJson<String, ClockTime>(
        json['breakStart'],
        const ClockTimeConverter().fromJson,
      ),
      breakEnd: _$JsonConverterFromJson<String, ClockTime>(
        json['breakEnd'],
        const ClockTimeConverter().fromJson,
      ),
      weeklyOffDays: (json['weeklyOffDays'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$WorkScheduleInputToJson(_WorkScheduleInput instance) =>
    <String, dynamic>{
      'effectiveFrom': const DateOnlyConverter().toJson(instance.effectiveFrom),
      'startTime': const ClockTimeConverter().toJson(instance.startTime),
      'endTime': const ClockTimeConverter().toJson(instance.endTime),
      'breakMinutes': instance.breakMinutes,
      'breakStart': _$JsonConverterToJson<String, ClockTime>(
        instance.breakStart,
        const ClockTimeConverter().toJson,
      ),
      'breakEnd': _$JsonConverterToJson<String, ClockTime>(
        instance.breakEnd,
        const ClockTimeConverter().toJson,
      ),
      'weeklyOffDays': instance.weeklyOffDays,
    };
