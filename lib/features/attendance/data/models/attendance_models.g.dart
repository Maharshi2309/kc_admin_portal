// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceRecordModel _$AttendanceRecordModelFromJson(
  Map<String, dynamic> json,
) => _AttendanceRecordModel(
  id: _optionalId(json['id']),
  employee: EmployeeSummaryModel.fromJson(
    json['employee'] as Map<String, dynamic>,
  ),
  date: const DateOnlyConverter().fromJson(json['date'] as String),
  punchIn: _$JsonConverterFromJson<String, DateTime>(
    json['punchIn'],
    const CompanyDateTimeConverter().fromJson,
  ),
  punchOut: _$JsonConverterFromJson<String, DateTime>(
    json['punchOut'],
    const CompanyDateTimeConverter().fromJson,
  ),
  workedMinutes: (json['workedMinutes'] as num?)?.toInt(),
  workedPercent: (json['workedPercent'] as num?)?.toDouble(),
  status: $enumDecode(
    _$AttendanceDayStatusEnumMap,
    json['status'],
    unknownValue: AttendanceDayStatus.unknown,
  ),
  note: json['note'] as String?,
  lateMinutes: (json['lateMinutes'] as num?)?.toInt(),
  correctedBy: json['correctedBy'] as String?,
  correctedAt: _$JsonConverterFromJson<String, DateTime>(
    json['correctedAt'],
    const CompanyDateTimeConverter().fromJson,
  ),
  dayKind:
      $enumDecodeNullable(
        _$AttendanceDayKindEnumMap,
        json['dayKind'],
        unknownValue: AttendanceDayKind.unknown,
      ) ??
      AttendanceDayKind.working,
  schedule: json['schedule'] == null
      ? null
      : ScheduleSnapshotModel.fromJson(
          json['schedule'] as Map<String, dynamic>,
        ),
  expectedMinutes: (json['expectedMinutes'] as num?)?.toInt(),
  overtimeMinutes: (json['overtimeMinutes'] as num?)?.toInt(),
);

Map<String, dynamic> _$AttendanceRecordModelToJson(
  _AttendanceRecordModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'employee': instance.employee.toJson(),
  'date': const DateOnlyConverter().toJson(instance.date),
  'punchIn': _$JsonConverterToJson<String, DateTime>(
    instance.punchIn,
    const CompanyDateTimeConverter().toJson,
  ),
  'punchOut': _$JsonConverterToJson<String, DateTime>(
    instance.punchOut,
    const CompanyDateTimeConverter().toJson,
  ),
  'workedMinutes': instance.workedMinutes,
  'workedPercent': instance.workedPercent,
  'status': _$AttendanceDayStatusEnumMap[instance.status]!,
  'note': instance.note,
  'lateMinutes': instance.lateMinutes,
  'correctedBy': instance.correctedBy,
  'correctedAt': _$JsonConverterToJson<String, DateTime>(
    instance.correctedAt,
    const CompanyDateTimeConverter().toJson,
  ),
  'dayKind': _$AttendanceDayKindEnumMap[instance.dayKind]!,
  'schedule': instance.schedule?.toJson(),
  'expectedMinutes': instance.expectedMinutes,
  'overtimeMinutes': instance.overtimeMinutes,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

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

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_AttendanceDaySummaryModel _$AttendanceDaySummaryModelFromJson(
  Map<String, dynamic> json,
) => _AttendanceDaySummaryModel(
  date: const DateOnlyConverter().fromJson(json['date'] as String),
  shiftStart: json['shiftStart'] as String?,
  shiftEnd: json['shiftEnd'] as String?,
  totalEmployees: (json['totalEmployees'] as num).toInt(),
  present: (json['present'] as num).toInt(),
  late: (json['late'] as num).toInt(),
  onLeave: (json['onLeave'] as num).toInt(),
  absent: (json['absent'] as num).toInt(),
  notPunchedIn: (json['notPunchedIn'] as num).toInt(),
);

Map<String, dynamic> _$AttendanceDaySummaryModelToJson(
  _AttendanceDaySummaryModel instance,
) => <String, dynamic>{
  'date': const DateOnlyConverter().toJson(instance.date),
  'shiftStart': instance.shiftStart,
  'shiftEnd': instance.shiftEnd,
  'totalEmployees': instance.totalEmployees,
  'present': instance.present,
  'late': instance.late,
  'onLeave': instance.onLeave,
  'absent': instance.absent,
  'notPunchedIn': instance.notPunchedIn,
};

_AttendanceDayModel _$AttendanceDayModelFromJson(Map<String, dynamic> json) =>
    _AttendanceDayModel(
      summary: AttendanceDaySummaryModel.fromJson(
        json['summary'] as Map<String, dynamic>,
      ),
      items: (json['items'] as List<dynamic>)
          .map((e) => AttendanceRecordModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
    );

Map<String, dynamic> _$AttendanceDayModelToJson(_AttendanceDayModel instance) =>
    <String, dynamic>{
      'summary': instance.summary.toJson(),
      'items': instance.items.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };

_AttendanceCorrectionData _$AttendanceCorrectionDataFromJson(
  Map<String, dynamic> json,
) => _AttendanceCorrectionData(
  employeeId: json['employeeId'] as String?,
  date: const DateOnlyConverter().fromJson(json['date'] as String),
  punchIn: const CompanyDateTimeConverter().fromJson(json['punchIn'] as String),
  punchOut: _$JsonConverterFromJson<String, DateTime>(
    json['punchOut'],
    const CompanyDateTimeConverter().fromJson,
  ),
  reason: $enumDecode(_$CorrectionReasonEnumMap, json['reason']),
  remarks: json['remarks'] as String?,
);

Map<String, dynamic> _$AttendanceCorrectionDataToJson(
  _AttendanceCorrectionData instance,
) => <String, dynamic>{
  'employeeId': instance.employeeId,
  'date': dateToJson(instance.date),
  'punchIn': const CompanyDateTimeConverter().toJson(instance.punchIn),
  'punchOut': _$JsonConverterToJson<String, DateTime>(
    instance.punchOut,
    const CompanyDateTimeConverter().toJson,
  ),
  'reason': _$CorrectionReasonEnumMap[instance.reason]!,
  'remarks': instance.remarks,
};

const _$CorrectionReasonEnumMap = {
  CorrectionReason.forgotToPunch: 'forgot_to_punch',
  CorrectionReason.deviceIssue: 'device_issue',
  CorrectionReason.onFieldDuty: 'on_field_duty',
  CorrectionReason.wrongTimeRecorded: 'wrong_time_recorded',
  CorrectionReason.other: 'other',
};
