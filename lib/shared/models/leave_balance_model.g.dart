// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_balance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaveBalanceModel _$LeaveBalanceModelFromJson(Map<String, dynamic> json) =>
    _LeaveBalanceModel(
      asOf: const DateOnlyConverter().fromJson(json['asOf'] as String),
      accrued: (json['accrued'] as num).toDouble(),
      used: (json['used'] as num).toDouble(),
      pending: (json['pending'] as num?)?.toDouble() ?? 0,
      remaining: (json['remaining'] as num).toDouble(),
      unpaidTaken: (json['unpaidTaken'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$LeaveBalanceModelToJson(_LeaveBalanceModel instance) =>
    <String, dynamic>{
      'asOf': const DateOnlyConverter().toJson(instance.asOf),
      'accrued': instance.accrued,
      'used': instance.used,
      'pending': instance.pending,
      'remaining': instance.remaining,
      'unpaidTaken': instance.unpaidTaken,
    };
