// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_import_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ImportCountsModel _$ImportCountsModelFromJson(Map<String, dynamic> json) =>
    _ImportCountsModel(
      valid: (json['valid'] as num?)?.toInt() ?? 0,
      warnings: (json['warnings'] as num?)?.toInt() ?? 0,
      errors: (json['errors'] as num?)?.toInt() ?? 0,
      skipped: (json['skipped'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ImportCountsModelToJson(_ImportCountsModel instance) =>
    <String, dynamic>{
      'valid': instance.valid,
      'warnings': instance.warnings,
      'errors': instance.errors,
      'skipped': instance.skipped,
    };

_ImportResultModel _$ImportResultModelFromJson(Map<String, dynamic> json) =>
    _ImportResultModel(
      imported: (json['imported'] as num?)?.toInt() ?? 0,
      updated: (json['updated'] as num?)?.toInt() ?? 0,
      skipped: (json['skipped'] as num?)?.toInt() ?? 0,
      failed: (json['failed'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ImportResultModelToJson(_ImportResultModel instance) =>
    <String, dynamic>{
      'imported': instance.imported,
      'updated': instance.updated,
      'skipped': instance.skipped,
      'failed': instance.failed,
    };

_EmployeeImportModel _$EmployeeImportModelFromJson(
  Map<String, dynamic> json,
) => _EmployeeImportModel(
  id: idFromJson(json['id']),
  fileName: json['fileName'] as String,
  status: $enumDecode(
    _$ImportStatusEnumMap,
    json['status'],
    unknownValue: ImportStatus.unknown,
  ),
  headers: (json['headers'] as List<dynamic>).map((e) => e as String).toList(),
  sampleRows:
      (json['sampleRows'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList() ??
      const <List<String>>[],
  rowCount: (json['rowCount'] as num).toInt(),
  suggestedMapping:
      (json['suggestedMapping'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String?),
      ) ??
      const <String, String?>{},
  mapping: (json['mapping'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String?),
  ),
  duplicateStrategy: $enumDecodeNullable(
    _$DuplicateStrategyEnumMap,
    json['duplicateStrategy'],
    unknownValue: DuplicateStrategy.skip,
  ),
  createMissing: json['createMissing'] as bool? ?? false,
  assignEcNumbers: json['assignEcNumbers'] as bool? ?? false,
  counts: json['counts'] == null
      ? null
      : ImportCountsModel.fromJson(json['counts'] as Map<String, dynamic>),
  processed: (json['processed'] as num?)?.toInt() ?? 0,
  result: json['result'] == null
      ? null
      : ImportResultModel.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EmployeeImportModelToJson(
  _EmployeeImportModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'fileName': instance.fileName,
  'status': _$ImportStatusEnumMap[instance.status]!,
  'headers': instance.headers,
  'sampleRows': instance.sampleRows,
  'rowCount': instance.rowCount,
  'suggestedMapping': instance.suggestedMapping,
  'mapping': instance.mapping,
  'duplicateStrategy': _$DuplicateStrategyEnumMap[instance.duplicateStrategy],
  'createMissing': instance.createMissing,
  'assignEcNumbers': instance.assignEcNumbers,
  'counts': instance.counts?.toJson(),
  'processed': instance.processed,
  'result': instance.result?.toJson(),
};

const _$ImportStatusEnumMap = {
  ImportStatus.uploaded: 'uploaded',
  ImportStatus.validated: 'validated',
  ImportStatus.importing: 'importing',
  ImportStatus.completed: 'completed',
  ImportStatus.failed: 'failed',
  ImportStatus.unknown: 'unknown',
};

const _$DuplicateStrategyEnumMap = {
  DuplicateStrategy.skip: 'skip',
  DuplicateStrategy.update: 'update',
};

_ImportOptionsModel _$ImportOptionsModelFromJson(Map<String, dynamic> json) =>
    _ImportOptionsModel(
      mapping: Map<String, String?>.from(json['mapping'] as Map),
      duplicateStrategy: $enumDecode(
        _$DuplicateStrategyEnumMap,
        json['duplicateStrategy'],
      ),
      createMissing: json['createMissing'] as bool? ?? false,
      assignEcNumbers: json['assignEcNumbers'] as bool? ?? false,
    );

Map<String, dynamic> _$ImportOptionsModelToJson(
  _ImportOptionsModel instance,
) => <String, dynamic>{
  'mapping': instance.mapping,
  'duplicateStrategy': _$DuplicateStrategyEnumMap[instance.duplicateStrategy]!,
  'createMissing': instance.createMissing,
  'assignEcNumbers': instance.assignEcNumbers,
};

_ImportChangeModel _$ImportChangeModelFromJson(Map<String, dynamic> json) =>
    _ImportChangeModel(
      field: json['field'] as String,
      before: json['before'] as String?,
      after: json['after'] as String?,
    );

Map<String, dynamic> _$ImportChangeModelToJson(_ImportChangeModel instance) =>
    <String, dynamic>{
      'field': instance.field,
      'before': instance.before,
      'after': instance.after,
    };

_ImportRowModel _$ImportRowModelFromJson(
  Map<String, dynamic> json,
) => _ImportRowModel(
  rowNumber: (json['rowNumber'] as num).toInt(),
  status: $enumDecode(
    _$ImportRowStatusEnumMap,
    json['status'],
    unknownValue: ImportRowStatus.unknown,
  ),
  ecNumber: json['ecNumber'] as String?,
  name: json['name'] as String?,
  messages:
      (json['messages'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  changes:
      (json['changes'] as List<dynamic>?)
          ?.map((e) => ImportChangeModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ImportChangeModel>[],
);

Map<String, dynamic> _$ImportRowModelToJson(_ImportRowModel instance) =>
    <String, dynamic>{
      'rowNumber': instance.rowNumber,
      'status': _$ImportRowStatusEnumMap[instance.status]!,
      'ecNumber': instance.ecNumber,
      'name': instance.name,
      'messages': instance.messages,
      'changes': instance.changes.map((e) => e.toJson()).toList(),
    };

const _$ImportRowStatusEnumMap = {
  ImportRowStatus.valid: 'valid',
  ImportRowStatus.warning: 'warning',
  ImportRowStatus.error: 'error',
  ImportRowStatus.imported: 'imported',
  ImportRowStatus.updated: 'updated',
  ImportRowStatus.skipped: 'skipped',
  ImportRowStatus.failed: 'failed',
  ImportRowStatus.unknown: 'unknown',
};

_ImportRowsPageModel _$ImportRowsPageModelFromJson(Map<String, dynamic> json) =>
    _ImportRowsPageModel(
      items: (json['items'] as List<dynamic>)
          .map((e) => ImportRowModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
    );

Map<String, dynamic> _$ImportRowsPageModelToJson(
  _ImportRowsPageModel instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'total': instance.total,
  'page': instance.page,
  'pageSize': instance.pageSize,
};
