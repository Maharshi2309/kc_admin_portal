// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaveTypeModel _$LeaveTypeModelFromJson(Map<String, dynamic> json) =>
    _LeaveTypeModel(
      id: idFromJson(json['id']),
      name: json['name'] as String,
      hasBalance: json['hasBalance'] as bool? ?? true,
    );

Map<String, dynamic> _$LeaveTypeModelToJson(_LeaveTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'hasBalance': instance.hasBalance,
    };

_LeaveModel _$LeaveModelFromJson(Map<String, dynamic> json) => _LeaveModel(
  id: idFromJson(json['id']),
  employee: EmployeeSummaryModel.fromJson(
    json['employee'] as Map<String, dynamic>,
  ),
  leaveType: NamedRef.fromJson(json['leaveType'] as Map<String, dynamic>),
  startDate: const DateOnlyConverter().fromJson(json['startDate'] as String),
  endDate: const DateOnlyConverter().fromJson(json['endDate'] as String),
  days: (json['days'] as num).toDouble(),
  isHalfDay: json['isHalfDay'] as bool? ?? false,
  reason: $enumDecode(
    _$LeaveReasonEnumMap,
    json['reason'],
    unknownValue: LeaveReason.other,
  ),
  remarks: json['remarks'] as String?,
  status: $enumDecode(
    _$LeaveStatusEnumMap,
    json['status'],
    unknownValue: LeaveStatus.unknown,
  ),
  addedBy: json['addedBy'] as String?,
);

Map<String, dynamic> _$LeaveModelToJson(_LeaveModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employee': instance.employee.toJson(),
      'leaveType': instance.leaveType.toJson(),
      'startDate': const DateOnlyConverter().toJson(instance.startDate),
      'endDate': const DateOnlyConverter().toJson(instance.endDate),
      'days': instance.days,
      'isHalfDay': instance.isHalfDay,
      'reason': _$LeaveReasonEnumMap[instance.reason]!,
      'remarks': instance.remarks,
      'status': _$LeaveStatusEnumMap[instance.status]!,
      'addedBy': instance.addedBy,
    };

const _$LeaveReasonEnumMap = {
  LeaveReason.personalWork: 'personal_work',
  LeaveReason.familyFunction: 'family_function',
  LeaveReason.medical: 'medical',
  LeaveReason.travel: 'travel',
  LeaveReason.other: 'other',
};

const _$LeaveStatusEnumMap = {
  LeaveStatus.pending: 'pending',
  LeaveStatus.approved: 'approved',
  LeaveStatus.rejected: 'rejected',
  LeaveStatus.cancelled: 'cancelled',
  LeaveStatus.unknown: 'unknown',
};

_LeaveStatusCounts _$LeaveStatusCountsFromJson(Map<String, dynamic> json) =>
    _LeaveStatusCounts(
      all: (json['all'] as num).toInt(),
      pending: (json['pending'] as num).toInt(),
      approved: (json['approved'] as num).toInt(),
      rejected: (json['rejected'] as num).toInt(),
      cancelled: (json['cancelled'] as num).toInt(),
    );

Map<String, dynamic> _$LeaveStatusCountsToJson(_LeaveStatusCounts instance) =>
    <String, dynamic>{
      'all': instance.all,
      'pending': instance.pending,
      'approved': instance.approved,
      'rejected': instance.rejected,
      'cancelled': instance.cancelled,
    };

_LeaveListModel _$LeaveListModelFromJson(Map<String, dynamic> json) =>
    _LeaveListModel(
      items: (json['items'] as List<dynamic>)
          .map((e) => LeaveModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      counts: LeaveStatusCounts.fromJson(
        json['counts'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$LeaveListModelToJson(_LeaveListModel instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'page': instance.page,
      'pageSize': instance.pageSize,
      'counts': instance.counts.toJson(),
    };

_LeaveFormData _$LeaveFormDataFromJson(Map<String, dynamic> json) =>
    _LeaveFormData(
      employeeId: json['employeeId'] as String,
      leaveTypeId: json['leaveTypeId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isHalfDay: json['isHalfDay'] as bool,
      reason: $enumDecode(_$LeaveReasonEnumMap, json['reason']),
      remarks: json['remarks'] as String?,
      status: $enumDecode(_$LeaveStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$LeaveFormDataToJson(_LeaveFormData instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeId,
      'leaveTypeId': instance.leaveTypeId,
      'startDate': dateToJson(instance.startDate),
      'endDate': dateToJson(instance.endDate),
      'isHalfDay': instance.isHalfDay,
      'reason': _$LeaveReasonEnumMap[instance.reason]!,
      'remarks': instance.remarks,
      'status': _$LeaveStatusEnumMap[instance.status]!,
    };

_LeavePreviewRequest _$LeavePreviewRequestFromJson(Map<String, dynamic> json) =>
    _LeavePreviewRequest(
      employeeId: json['employeeId'] as String,
      leaveTypeId: json['leaveTypeId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isHalfDay: json['isHalfDay'] as bool,
      leaveId: json['leaveId'] as String?,
    );

Map<String, dynamic> _$LeavePreviewRequestToJson(
  _LeavePreviewRequest instance,
) => <String, dynamic>{
  'employeeId': instance.employeeId,
  'leaveTypeId': instance.leaveTypeId,
  'startDate': dateToJson(instance.startDate),
  'endDate': dateToJson(instance.endDate),
  'isHalfDay': instance.isHalfDay,
  'leaveId': instance.leaveId,
};

_LeavePreviewModel _$LeavePreviewModelFromJson(Map<String, dynamic> json) =>
    _LeavePreviewModel(
      days: (json['days'] as num).toDouble(),
      balanceBefore: (json['balanceBefore'] as num?)?.toDouble(),
      balanceAfter: (json['balanceAfter'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$LeavePreviewModelToJson(_LeavePreviewModel instance) =>
    <String, dynamic>{
      'days': instance.days,
      'balanceBefore': instance.balanceBefore,
      'balanceAfter': instance.balanceAfter,
    };

_LeaveCalendarModel _$LeaveCalendarModelFromJson(Map<String, dynamic> json) =>
    _LeaveCalendarModel(
      month: const DateOnlyConverter().fromJson(json['month'] as String),
      holidays:
          (json['holidays'] as List<dynamic>?)
              ?.map((e) => HolidayModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <HolidayModel>[],
      weeklyOffDays:
          (json['weeklyOffDays'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
      weekOffDates:
          (json['weekOffDates'] as List<dynamic>?)
              ?.map((e) => const DateOnlyConverter().fromJson(e as String))
              .toList() ??
          const <DateTime>[],
    );

Map<String, dynamic> _$LeaveCalendarModelToJson(_LeaveCalendarModel instance) =>
    <String, dynamic>{
      'month': const DateOnlyConverter().toJson(instance.month),
      'holidays': instance.holidays.map((e) => e.toJson()).toList(),
      'weeklyOffDays': instance.weeklyOffDays,
      'weekOffDates': instance.weekOffDates
          .map(const DateOnlyConverter().toJson)
          .toList(),
    };
