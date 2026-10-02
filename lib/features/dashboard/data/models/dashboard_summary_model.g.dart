// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardSummaryModel _$DashboardSummaryModelFromJson(
  Map<String, dynamic> json,
) => _DashboardSummaryModel(
  date: const DateOnlyConverter().fromJson(json['date'] as String),
  totalEmployees: (json['totalEmployees'] as num).toInt(),
  scheduledToday: (json['scheduledToday'] as num?)?.toInt(),
  presentToday: (json['presentToday'] as num).toInt(),
  onLeaveToday: (json['onLeaveToday'] as num).toInt(),
  absentToday: (json['absentToday'] as num).toInt(),
  presentPercent: (json['presentPercent'] as num?)?.toDouble(),
  onLeavePercent: (json['onLeavePercent'] as num?)?.toDouble(),
  absentPercent: (json['absentPercent'] as num?)?.toDouble(),
  holiday: json['holiday'] == null
      ? null
      : HolidayModel.fromJson(json['holiday'] as Map<String, dynamic>),
  weekOffToday: (json['weekOffToday'] as num?)?.toInt() ?? 0,
  holidayWorkedToday: (json['holidayWorkedToday'] as num?)?.toInt() ?? 0,
  weekOffWorkedToday: (json['weekOffWorkedToday'] as num?)?.toInt() ?? 0,
  overtimeMinutesThisMonth: (json['overtimeMinutesThisMonth'] as num?)?.toInt(),
  overtimeEmployeesThisMonth: (json['overtimeEmployeesThisMonth'] as num?)
      ?.toInt(),
  attention:
      (json['attention'] as List<dynamic>?)
          ?.map((e) => AttentionItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AttentionItemModel>[],
  notPunchedIn:
      (json['notPunchedIn'] as List<dynamic>?)
          ?.map((e) => EmployeeSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <EmployeeSummaryModel>[],
  notPunchedInTotal: (json['notPunchedInTotal'] as num?)?.toInt() ?? 0,
  onLeave:
      (json['onLeave'] as List<dynamic>?)
          ?.map((e) => LeaveTodayModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <LeaveTodayModel>[],
  leaveUsage: json['leaveUsage'] == null
      ? null
      : LeaveUsageModel.fromJson(json['leaveUsage'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DashboardSummaryModelToJson(
  _DashboardSummaryModel instance,
) => <String, dynamic>{
  'date': const DateOnlyConverter().toJson(instance.date),
  'totalEmployees': instance.totalEmployees,
  'scheduledToday': instance.scheduledToday,
  'presentToday': instance.presentToday,
  'onLeaveToday': instance.onLeaveToday,
  'absentToday': instance.absentToday,
  'presentPercent': instance.presentPercent,
  'onLeavePercent': instance.onLeavePercent,
  'absentPercent': instance.absentPercent,
  'holiday': instance.holiday?.toJson(),
  'weekOffToday': instance.weekOffToday,
  'holidayWorkedToday': instance.holidayWorkedToday,
  'weekOffWorkedToday': instance.weekOffWorkedToday,
  'overtimeMinutesThisMonth': instance.overtimeMinutesThisMonth,
  'overtimeEmployeesThisMonth': instance.overtimeEmployeesThisMonth,
  'attention': instance.attention.map((e) => e.toJson()).toList(),
  'notPunchedIn': instance.notPunchedIn.map((e) => e.toJson()).toList(),
  'notPunchedInTotal': instance.notPunchedInTotal,
  'onLeave': instance.onLeave.map((e) => e.toJson()).toList(),
  'leaveUsage': instance.leaveUsage?.toJson(),
};

_AttentionItemModel _$AttentionItemModelFromJson(Map<String, dynamic> json) =>
    _AttentionItemModel(
      kind: $enumDecode(
        _$AttentionKindEnumMap,
        json['kind'],
        unknownValue: AttentionKind.unknown,
      ),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$AttentionItemModelToJson(_AttentionItemModel instance) =>
    <String, dynamic>{
      'kind': _$AttentionKindEnumMap[instance.kind]!,
      'count': instance.count,
    };

const _$AttentionKindEnumMap = {
  AttentionKind.notPunchedIn: 'not_punched_in',
  AttentionKind.pendingLeave: 'pending_leave',
  AttentionKind.lateArrival: 'late_arrival',
  AttentionKind.unknown: 'unknown',
};

_LeaveTodayModel _$LeaveTodayModelFromJson(Map<String, dynamic> json) =>
    _LeaveTodayModel(
      employee: EmployeeSummaryModel.fromJson(
        json['employee'] as Map<String, dynamic>,
      ),
      leaveType: json['leaveType'] as String,
      endDate: const DateOnlyConverter().fromJson(json['endDate'] as String),
      days: (json['days'] as num).toDouble(),
      isHalfDay: json['isHalfDay'] as bool? ?? false,
    );

Map<String, dynamic> _$LeaveTodayModelToJson(_LeaveTodayModel instance) =>
    <String, dynamic>{
      'employee': instance.employee.toJson(),
      'leaveType': instance.leaveType,
      'endDate': const DateOnlyConverter().toJson(instance.endDate),
      'days': instance.days,
      'isHalfDay': instance.isHalfDay,
    };

_LeaveUsageModel _$LeaveUsageModelFromJson(Map<String, dynamic> json) =>
    _LeaveUsageModel(
      year: (json['year'] as num).toInt(),
      usedPercent: (json['usedPercent'] as num).toDouble(),
      takenDays: (json['takenDays'] as num).toDouble(),
      remainingDays: (json['remainingDays'] as num).toDouble(),
    );

Map<String, dynamic> _$LeaveUsageModelToJson(_LeaveUsageModel instance) =>
    <String, dynamic>{
      'year': instance.year,
      'usedPercent': instance.usedPercent,
      'takenDays': instance.takenDays,
      'remainingDays': instance.remainingDays,
    };
