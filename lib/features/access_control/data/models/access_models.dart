import 'package:freezed_annotation/freezed_annotation.dart';

part 'access_models.freezed.dart';
part 'access_models.g.dart';

/// The permission catalogue (`GET /permissions`), grouped by module for the
/// matrix rows.
@freezed
abstract class PermissionModuleModel with _$PermissionModuleModel {
  const factory PermissionModuleModel({
    /// e.g. `employee`.
    required String module,

    /// e.g. "Employees".
    required String label,
    required List<PermissionModel> permissions,
  }) = _PermissionModuleModel;

  factory PermissionModuleModel.fromJson(Map<String, dynamic> json) =>
      _$PermissionModuleModelFromJson(json);
}

@freezed
abstract class PermissionModel with _$PermissionModel {
  const factory PermissionModel({
    /// e.g. `employee.edit`.
    required String key,

    /// The matrix column, e.g. `edit` (view, create, edit, delete, …).
    required String action,

    /// e.g. "Edit employees".
    required String label,
    String? description,
  }) = _PermissionModel;

  factory PermissionModel.fromJson(Map<String, dynamic> json) =>
      _$PermissionModelFromJson(json);
}
