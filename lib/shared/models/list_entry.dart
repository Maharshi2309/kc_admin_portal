import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kc_admin_portal/shared/models/json_converters.dart';

part 'list_entry.freezed.dart';
part 'list_entry.g.dart';

/// One item from `GET /departments` or `GET /positions`.
///
/// Codes are stable snake_case strings (e.g. `graphic_designer`). Names are
/// the human-readable labels shown in dropdowns and tables. Both lists are
/// fetched once after sign-in and kept for the session.
@freezed
abstract class ListEntry with _$ListEntry {
  const factory ListEntry({
    @JsonKey(fromJson: idFromJson) required String id,
    required String code,
    required String name,
    @Default(0) int employeeCount,
  }) = _ListEntry;

  const ListEntry._();

  factory ListEntry.fromJson(Map<String, dynamic> json) =>
      _$ListEntryFromJson(json);

  /// Humanises an unknown code for display: `store_keeper` → "Store keeper".
  static String humanise(String code) {
    if (code.isEmpty) return code;
    return code.replaceAll('_', ' ')[0].toUpperCase() +
        code.replaceAll('_', ' ').substring(1);
  }
}

/// Resolves a code to its display name using [entries] from the API.
/// Falls back to [ListEntry.humanise] for unknown codes.
String resolveEntryName(String? code, List<ListEntry> entries) {
  if (code == null || code.isEmpty) return '';
  try {
    return entries.firstWhere((e) => e.code == code).name;
  } on StateError {
    return ListEntry.humanise(code);
  }
}
