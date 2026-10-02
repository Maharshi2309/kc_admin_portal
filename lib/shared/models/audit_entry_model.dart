import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kc_admin_portal/shared/models/json_converters.dart';
import 'package:kc_admin_portal/shared/models/named_ref.dart';

part 'audit_entry_model.freezed.dart';
part 'audit_entry_model.g.dart';

/// One recorded change, e.g. a corrected punch-in, shown in a day's history.
@freezed
abstract class AuditEntryModel with _$AuditEntryModel {
  const factory AuditEntryModel({
    @JsonKey(fromJson: idFromJson) required String id,

    /// Machine-readable, e.g. `attendance.correct`.
    required String action,

    /// Display text from the backend, e.g. "Corrected punch in".
    required String summary,
    required NamedRef actor,
    @CompanyDateTimeConverter() required DateTime createdAt,
    @Default(<AuditChangeModel>[]) List<AuditChangeModel> changes,
    String? reason,
    String? remarks,
  }) = _AuditEntryModel;

  factory AuditEntryModel.fromJson(Map<String, dynamic> json) =>
      _$AuditEntryModelFromJson(json);
}

/// One changed field, already formatted for display by the backend
/// ("Punch in": "—" → "09:35").
@freezed
abstract class AuditChangeModel with _$AuditChangeModel {
  const factory AuditChangeModel({
    required String field,
    required String label,
    String? before,
    String? after,
  }) = _AuditChangeModel;

  factory AuditChangeModel.fromJson(Map<String, dynamic> json) =>
      _$AuditChangeModelFromJson(json);
}
