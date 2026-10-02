import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kc_admin_portal/shared/models/json_converters.dart';

part 'named_ref.freezed.dart';
part 'named_ref.g.dart';

/// A reference to another record by id with its display name, e.g. an
/// employee's department `{ "id": "3", "name": "IT" }`.
@freezed
abstract class NamedRef with _$NamedRef {
  const factory NamedRef({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,
  }) = _NamedRef;

  factory NamedRef.fromJson(Map<String, dynamic> json) =>
      _$NamedRefFromJson(json);
}
