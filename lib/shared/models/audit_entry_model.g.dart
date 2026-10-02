// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuditEntryModel _$AuditEntryModelFromJson(Map<String, dynamic> json) =>
    _AuditEntryModel(
      id: idFromJson(json['id']),
      action: json['action'] as String,
      summary: json['summary'] as String,
      actor: NamedRef.fromJson(json['actor'] as Map<String, dynamic>),
      createdAt: const CompanyDateTimeConverter().fromJson(
        json['createdAt'] as String,
      ),
      changes:
          (json['changes'] as List<dynamic>?)
              ?.map((e) => AuditChangeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <AuditChangeModel>[],
      reason: json['reason'] as String?,
      remarks: json['remarks'] as String?,
    );

Map<String, dynamic> _$AuditEntryModelToJson(_AuditEntryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'action': instance.action,
      'summary': instance.summary,
      'actor': instance.actor.toJson(),
      'createdAt': const CompanyDateTimeConverter().toJson(instance.createdAt),
      'changes': instance.changes.map((e) => e.toJson()).toList(),
      'reason': instance.reason,
      'remarks': instance.remarks,
    };

_AuditChangeModel _$AuditChangeModelFromJson(Map<String, dynamic> json) =>
    _AuditChangeModel(
      field: json['field'] as String,
      label: json['label'] as String,
      before: json['before'] as String?,
      after: json['after'] as String?,
    );

Map<String, dynamic> _$AuditChangeModelToJson(_AuditChangeModel instance) =>
    <String, dynamic>{
      'field': instance.field,
      'label': instance.label,
      'before': instance.before,
      'after': instance.after,
    };
