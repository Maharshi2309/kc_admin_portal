import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/shared/models/json_converters.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// The signed-in staff member and their permissions.
///
/// [permissions] only shape the UI (hide or disable actions). The backend
/// checks every request itself and answers 403 when a permission is missing.
@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,
    required String email,

    /// Permission keys from the API, e.g. `employee.edit`.
    @Default(<String>[]) List<String> permissions,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// The permissions this app version knows; unknown keys are ignored.
  Set<AppPermission> get grants => AppPermission.parseAll(permissions);

  bool can(AppPermission permission) => permissions.contains(permission.key);

  /// Has every permission this app knows.
  bool get hasFullAccess => grants.length == AppPermission.values.length;
}
