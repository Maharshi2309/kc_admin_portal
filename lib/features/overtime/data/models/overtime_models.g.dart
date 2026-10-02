// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overtime_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OvertimeReportModel _$OvertimeReportModelFromJson(Map<String, dynamic> json) =>
    _OvertimeReportModel(
      from: const DateOnlyConverter().fromJson(json['from'] as String),
      to: const DateOnlyConverter().fromJson(json['to'] as String),
      totalMinutes: (json['totalMinutes'] as num).toInt(),
      expectedMinutes: (json['expectedMinutes'] as num?)?.toInt(),
      workedMinutes: (json['workedMinutes'] as num?)?.toInt(),
      dayBasisMinutes: (json['dayBasisMinutes'] as num).toInt(),
      scheduleChanged: json['scheduleChanged'] as bool? ?? false,
      months: (json['months'] as List<dynamic>)
          .map((e) => OvertimeMonthModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      days: (json['days'] as List<dynamic>)
          .map((e) => OvertimeDayModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OvertimeReportModelToJson(
  _OvertimeReportModel instance,
) => <String, dynamic>{
  'from': const DateOnlyConverter().toJson(instance.from),
  'to': const DateOnlyConverter().toJson(instance.to),
  'totalMinutes': instance.totalMinutes,
  'expectedMinutes': instance.expectedMinutes,
  'workedMinutes': instance.workedMinutes,
  'dayBasisMinutes': instance.dayBasisMinutes,
  'scheduleChanged': instance.scheduleChanged,
  'months': instance.months.map((e) => e.toJson()).toList(),
  'days': instance.days.map((e) => e.toJson()).toList(),
};

_OvertimeMonthModel _$OvertimeMonthModelFromJson(Map<String, dynamic> json) =>
    _OvertimeMonthModel(
      month: const DateOnlyConverter().fromJson(json['month'] as String),
      minutes: (json['minutes'] as num).toInt(),
      expectedMinutes: (json['expectedMinutes'] as num?)?.toInt(),
      workedMinutes: (json['workedMinutes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OvertimeMonthModelToJson(_OvertimeMonthModel instance) =>
    <String, dynamic>{
      'month': const DateOnlyConverter().toJson(instance.month),
      'minutes': instance.minutes,
      'expectedMinutes': instance.expectedMinutes,
      'workedMinutes': instance.workedMinutes,
    };

_OvertimeDayModel _$OvertimeDayModelFromJson(Map<String, dynamic> json) =>
    _OvertimeDayModel(
      date: const DateOnlyConverter().fromJson(json['date'] as String),
      dayKind: $enumDecode(
        _$AttendanceDayKindEnumMap,
        json['dayKind'],
        unknownValue: AttendanceDayKind.unknown,
      ),
      expectedMinutes: (json['expectedMinutes'] as num).toInt(),
      workedMinutes: (json['workedMinutes'] as num).toInt(),
      overtimeMinutes: (json['overtimeMinutes'] as num).toInt(),
      dayBasisMinutes: (json['dayBasisMinutes'] as num).toInt(),
    );

Map<String, dynamic> _$OvertimeDayModelToJson(_OvertimeDayModel instance) =>
    <String, dynamic>{
      'date': const DateOnlyConverter().toJson(instance.date),
      'dayKind': _$AttendanceDayKindEnumMap[instance.dayKind]!,
      'expectedMinutes': instance.expectedMinutes,
      'workedMinutes': instance.workedMinutes,
      'overtimeMinutes': instance.overtimeMinutes,
      'dayBasisMinutes': instance.dayBasisMinutes,
    };

const _$AttendanceDayKindEnumMap = {
  AttendanceDayKind.working: 'working',
  AttendanceDayKind.holidayWorked: 'holiday_worked',
  AttendanceDayKind.weekOffWorked: 'week_off_worked',
  AttendanceDayKind.unknown: 'unknown',
};
