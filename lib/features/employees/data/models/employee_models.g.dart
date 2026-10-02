// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EmployeeModel _$EmployeeModelFromJson(
  Map<String, dynamic> json,
) => _EmployeeModel(
  id: idFromJson(json['id']),
  ecNumber: json['ecNumber'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  mobile: json['mobile'] as String,
  department: NamedRef.fromJson(json['department'] as Map<String, dynamic>),
  designation: NamedRef.fromJson(json['designation'] as Map<String, dynamic>),
  joiningDate: const DateOnlyConverter().fromJson(
    json['joiningDate'] as String,
  ),
  status: $enumDecode(
    _$EmployeeStatusEnumMap,
    json['status'],
    unknownValue: EmployeeStatus.unknown,
  ),
  todayStatus: $enumDecodeNullable(
    _$AttendanceDayStatusEnumMap,
    json['todayStatus'],
    unknownValue: AttendanceDayStatus.unknown,
  ),
  updatedAt: _$JsonConverterFromJson<String, DateTime>(
    json['updatedAt'],
    const CompanyDateTimeConverter().fromJson,
  ),
  updatedBy: json['updatedBy'] as String?,
  schedule: json['schedule'] == null
      ? null
      : WorkScheduleModel.fromJson(json['schedule'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EmployeeModelToJson(_EmployeeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ecNumber': instance.ecNumber,
      'name': instance.name,
      'email': instance.email,
      'mobile': instance.mobile,
      'department': instance.department.toJson(),
      'designation': instance.designation.toJson(),
      'joiningDate': const DateOnlyConverter().toJson(instance.joiningDate),
      'status': _$EmployeeStatusEnumMap[instance.status]!,
      'todayStatus': _$AttendanceDayStatusEnumMap[instance.todayStatus],
      'updatedAt': _$JsonConverterToJson<String, DateTime>(
        instance.updatedAt,
        const CompanyDateTimeConverter().toJson,
      ),
      'updatedBy': instance.updatedBy,
      'schedule': instance.schedule?.toJson(),
    };

const _$EmployeeStatusEnumMap = {
  EmployeeStatus.active: 'active',
  EmployeeStatus.inactive: 'inactive',
  EmployeeStatus.unknown: 'unknown',
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

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_EmployeeFormData _$EmployeeFormDataFromJson(Map<String, dynamic> json) =>
    _EmployeeFormData(
      ecNumber: json['ecNumber'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      mobile: json['mobile'] as String,
      departmentId: json['departmentId'] as String,
      designationId: json['designationId'] as String,
      joiningDate: DateTime.parse(json['joiningDate'] as String),
      status: $enumDecode(_$EmployeeStatusEnumMap, json['status']),
      schedule: json['schedule'] == null
          ? null
          : WorkScheduleInput.fromJson(
              json['schedule'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$EmployeeFormDataToJson(_EmployeeFormData instance) =>
    <String, dynamic>{
      'ecNumber': instance.ecNumber,
      'name': instance.name,
      'email': instance.email,
      'mobile': instance.mobile,
      'departmentId': instance.departmentId,
      'designationId': instance.designationId,
      'joiningDate': dateToJson(instance.joiningDate),
      'status': _$EmployeeStatusEnumMap[instance.status]!,
      'schedule': ?instance.schedule?.toJson(),
    };

_EmployeeListModel _$EmployeeListModelFromJson(Map<String, dynamic> json) =>
    _EmployeeListModel(
      items: (json['items'] as List<dynamic>)
          .map((e) => EmployeeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      counts: json['counts'] == null
          ? null
          : EmployeeStatusCounts.fromJson(
              json['counts'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$EmployeeListModelToJson(_EmployeeListModel instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'page': instance.page,
      'pageSize': instance.pageSize,
      'counts': instance.counts?.toJson(),
    };

_EmployeeStatusCounts _$EmployeeStatusCountsFromJson(
  Map<String, dynamic> json,
) => _EmployeeStatusCounts(
  active: (json['active'] as num).toInt(),
  inactive: (json['inactive'] as num).toInt(),
);

Map<String, dynamic> _$EmployeeStatusCountsToJson(
  _EmployeeStatusCounts instance,
) => <String, dynamic>{
  'active': instance.active,
  'inactive': instance.inactive,
};

_LeaveHistoryItemModel _$LeaveHistoryItemModelFromJson(
  Map<String, dynamic> json,
) => _LeaveHistoryItemModel(
  id: idFromJson(json['id']),
  startDate: const DateOnlyConverter().fromJson(json['startDate'] as String),
  endDate: const DateOnlyConverter().fromJson(json['endDate'] as String),
  leaveType: json['leaveType'] as String,
  days: (json['days'] as num).toDouble(),
  reason: json['reason'] as String?,
  status: $enumDecode(
    _$LeaveStatusEnumMap,
    json['status'],
    unknownValue: LeaveStatus.unknown,
  ),
);

Map<String, dynamic> _$LeaveHistoryItemModelToJson(
  _LeaveHistoryItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'startDate': const DateOnlyConverter().toJson(instance.startDate),
  'endDate': const DateOnlyConverter().toJson(instance.endDate),
  'leaveType': instance.leaveType,
  'days': instance.days,
  'reason': instance.reason,
  'status': _$LeaveStatusEnumMap[instance.status]!,
};

const _$LeaveStatusEnumMap = {
  LeaveStatus.pending: 'pending',
  LeaveStatus.approved: 'approved',
  LeaveStatus.rejected: 'rejected',
  LeaveStatus.cancelled: 'cancelled',
  LeaveStatus.unknown: 'unknown',
};
