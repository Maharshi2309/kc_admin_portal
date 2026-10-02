// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MonthlyAttendanceModel _$MonthlyAttendanceModelFromJson(
  Map<String, dynamic> json,
) => _MonthlyAttendanceModel(
  month: const DateOnlyConverter().fromJson(json['month'] as String),
  averagePercent: (json['averagePercent'] as num?)?.toDouble(),
  days:
      (json['days'] as List<dynamic>?)
          ?.map((e) => DailyAttendanceModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <DailyAttendanceModel>[],
);

Map<String, dynamic> _$MonthlyAttendanceModelToJson(
  _MonthlyAttendanceModel instance,
) => <String, dynamic>{
  'month': const DateOnlyConverter().toJson(instance.month),
  'averagePercent': instance.averagePercent,
  'days': instance.days.map((e) => e.toJson()).toList(),
};

_DailyAttendanceModel _$DailyAttendanceModelFromJson(
  Map<String, dynamic> json,
) => _DailyAttendanceModel(
  date: const DateOnlyConverter().fromJson(json['date'] as String),
  percent: (json['percent'] as num).toDouble(),
);

Map<String, dynamic> _$DailyAttendanceModelToJson(
  _DailyAttendanceModel instance,
) => <String, dynamic>{
  'date': const DateOnlyConverter().toJson(instance.date),
  'percent': instance.percent,
};
