// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EmployeeCalendarModel _$EmployeeCalendarModelFromJson(
  Map<String, dynamic> json,
) => _EmployeeCalendarModel(
  month: const DateOnlyConverter().fromJson(json['month'] as String),
  days: (json['days'] as List<dynamic>)
      .map((e) => CalendarDayModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  summary: CalendarSummaryModel.fromJson(
    json['summary'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$EmployeeCalendarModelToJson(
  _EmployeeCalendarModel instance,
) => <String, dynamic>{
  'month': const DateOnlyConverter().toJson(instance.month),
  'days': instance.days.map((e) => e.toJson()).toList(),
  'summary': instance.summary.toJson(),
};

_CalendarDayModel _$CalendarDayModelFromJson(Map<String, dynamic> json) =>
    _CalendarDayModel(
      date: const DateOnlyConverter().fromJson(json['date'] as String),
      dayType: $enumDecode(
        _$CalendarDayTypeEnumMap,
        json['dayType'],
        unknownValue: CalendarDayType.unknown,
      ),
      holidayName: json['holidayName'] as String?,
      schedule: json['schedule'] == null
          ? null
          : ScheduleSnapshotModel.fromJson(
              json['schedule'] as Map<String, dynamic>,
            ),
      attendance: json['attendance'] == null
          ? null
          : CalendarAttendanceModel.fromJson(
              json['attendance'] as Map<String, dynamic>,
            ),
      leaves:
          (json['leaves'] as List<dynamic>?)
              ?.map(
                (e) => CalendarLeaveModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <CalendarLeaveModel>[],
      overtimeMinutes: (json['overtimeMinutes'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CalendarDayModelToJson(_CalendarDayModel instance) =>
    <String, dynamic>{
      'date': const DateOnlyConverter().toJson(instance.date),
      'dayType': _$CalendarDayTypeEnumMap[instance.dayType]!,
      'holidayName': instance.holidayName,
      'schedule': instance.schedule?.toJson(),
      'attendance': instance.attendance?.toJson(),
      'leaves': instance.leaves.map((e) => e.toJson()).toList(),
      'overtimeMinutes': instance.overtimeMinutes,
    };

const _$CalendarDayTypeEnumMap = {
  CalendarDayType.working: 'working',
  CalendarDayType.weekOff: 'week_off',
  CalendarDayType.holiday: 'holiday',
  CalendarDayType.unknown: 'unknown',
};

_CalendarAttendanceModel _$CalendarAttendanceModelFromJson(
  Map<String, dynamic> json,
) => _CalendarAttendanceModel(
  id: _optionalId(json['id']),
  status: $enumDecode(
    _$AttendanceDayStatusEnumMap,
    json['status'],
    unknownValue: AttendanceDayStatus.unknown,
  ),
  dayKind:
      $enumDecodeNullable(
        _$AttendanceDayKindEnumMap,
        json['dayKind'],
        unknownValue: AttendanceDayKind.unknown,
      ) ??
      AttendanceDayKind.working,
  punchIn: _$JsonConverterFromJson<String, DateTime>(
    json['punchIn'],
    const CompanyDateTimeConverter().fromJson,
  ),
  punchOut: _$JsonConverterFromJson<String, DateTime>(
    json['punchOut'],
    const CompanyDateTimeConverter().fromJson,
  ),
  workedMinutes: (json['workedMinutes'] as num?)?.toInt(),
  corrected: json['corrected'] as bool? ?? false,
);

Map<String, dynamic> _$CalendarAttendanceModelToJson(
  _CalendarAttendanceModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': _$AttendanceDayStatusEnumMap[instance.status]!,
  'dayKind': _$AttendanceDayKindEnumMap[instance.dayKind]!,
  'punchIn': _$JsonConverterToJson<String, DateTime>(
    instance.punchIn,
    const CompanyDateTimeConverter().toJson,
  ),
  'punchOut': _$JsonConverterToJson<String, DateTime>(
    instance.punchOut,
    const CompanyDateTimeConverter().toJson,
  ),
  'workedMinutes': instance.workedMinutes,
  'corrected': instance.corrected,
};

const _$AttendanceDayStatusEnumMap = {
  AttendanceDayStatus.present: 'present',
  AttendanceDayStatus.late: 'late',
  AttendanceDayStatus.halfDay: 'half_day',
  AttendanceDayStatus.onLeave: 'on_leave',
  AttendanceDayStatus.absent: 'absent',
  AttendanceDayStatus.weeklyOff: 'weekly_off',
  AttendanceDayStatus.holiday: 'holiday',
  AttendanceDayStatus.unknown: 'unknown',
};

const _$AttendanceDayKindEnumMap = {
  AttendanceDayKind.working: 'working',
  AttendanceDayKind.holidayWorked: 'holiday_worked',
  AttendanceDayKind.weekOffWorked: 'week_off_worked',
  AttendanceDayKind.unknown: 'unknown',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_CalendarLeaveModel _$CalendarLeaveModelFromJson(Map<String, dynamic> json) =>
    _CalendarLeaveModel(
      id: idFromJson(json['id']),
      leaveType: NamedRef.fromJson(json['leaveType'] as Map<String, dynamic>),
      status: $enumDecode(
        _$LeaveStatusEnumMap,
        json['status'],
        unknownValue: LeaveStatus.unknown,
      ),
      isHalfDay: json['isHalfDay'] as bool? ?? false,
    );

Map<String, dynamic> _$CalendarLeaveModelToJson(_CalendarLeaveModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'leaveType': instance.leaveType.toJson(),
      'status': _$LeaveStatusEnumMap[instance.status]!,
      'isHalfDay': instance.isHalfDay,
    };

const _$LeaveStatusEnumMap = {
  LeaveStatus.pending: 'pending',
  LeaveStatus.approved: 'approved',
  LeaveStatus.rejected: 'rejected',
  LeaveStatus.cancelled: 'cancelled',
  LeaveStatus.unknown: 'unknown',
};

_CalendarSummaryModel _$CalendarSummaryModelFromJson(
  Map<String, dynamic> json,
) => _CalendarSummaryModel(
  workingDays: (json['workingDays'] as num).toInt(),
  present: (json['present'] as num).toInt(),
  absent: (json['absent'] as num).toInt(),
  leaveDays: (json['leaveDays'] as num).toDouble(),
  holidays: (json['holidays'] as num).toInt(),
  weekOffs: (json['weekOffs'] as num).toInt(),
  holidayWorked: (json['holidayWorked'] as num).toInt(),
  weekOffWorked: (json['weekOffWorked'] as num).toInt(),
  expectedMinutes: (json['expectedMinutes'] as num).toInt(),
  workedMinutes: (json['workedMinutes'] as num).toInt(),
  overtimeMinutes: (json['overtimeMinutes'] as num).toInt(),
);

Map<String, dynamic> _$CalendarSummaryModelToJson(
  _CalendarSummaryModel instance,
) => <String, dynamic>{
  'workingDays': instance.workingDays,
  'present': instance.present,
  'absent': instance.absent,
  'leaveDays': instance.leaveDays,
  'holidays': instance.holidays,
  'weekOffs': instance.weekOffs,
  'holidayWorked': instance.holidayWorked,
  'weekOffWorked': instance.weekOffWorked,
  'expectedMinutes': instance.expectedMinutes,
  'workedMinutes': instance.workedMinutes,
  'overtimeMinutes': instance.overtimeMinutes,
};

_CalendarDayDetailModel _$CalendarDayDetailModelFromJson(
  Map<String, dynamic> json,
) => _CalendarDayDetailModel(
  day: CalendarDayModel.fromJson(json['day'] as Map<String, dynamic>),
  history:
      (json['history'] as List<dynamic>?)
          ?.map((e) => AuditEntryModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AuditEntryModel>[],
);

Map<String, dynamic> _$CalendarDayDetailModelToJson(
  _CalendarDayDetailModel instance,
) => <String, dynamic>{
  'day': instance.day.toJson(),
  'history': instance.history.map((e) => e.toJson()).toList(),
};
