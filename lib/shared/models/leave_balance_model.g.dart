// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_balance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaveBalanceModel _$LeaveBalanceModelFromJson(Map<String, dynamic> json) =>
    _LeaveBalanceModel(
      leaveTypeId: json['leaveTypeId'] as String?,
      leaveType: json['leaveType'] as String,
      quota: (json['quota'] as num?)?.toDouble(),
      used: (json['used'] as num).toDouble(),
      remaining: (json['remaining'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$LeaveBalanceModelToJson(_LeaveBalanceModel instance) =>
    <String, dynamic>{
      'leaveTypeId': instance.leaveTypeId,
      'leaveType': instance.leaveType,
      'quota': instance.quota,
      'used': instance.used,
      'remaining': instance.remaining,
    };
