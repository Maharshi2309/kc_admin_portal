import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/shared/models/json_converters.dart';
import 'package:kc_admin_portal/shared/models/organization_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// The signed-in staff member, the organization they are working in, and
/// their permissions there.
///
/// [permissions] only shape the UI (hide or disable actions). The backend
/// checks every request itself and answers 403 when a permission is missing.
@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,
    required String email,

    /// Permission keys from the API, e.g. `employee.edit`: the user's
    /// permissions in [organization] (they differ per organization).
    @Default(<String>[]) List<String> permissions,

    /// The active organization; null only from a server older than the
    /// multi-organization change.
    OrganizationModel? organization,

    /// Every organization the user belongs to, the active one included.
    /// Empty for a new account that hasn't created or joined one yet; null
    /// only from a server older than the multi-organization change.
    List<MembershipModel>? memberships,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// The permissions this app version knows; unknown keys are ignored.
  Set<AppPermission> get grants => AppPermission.parseAll(permissions);

  bool can(AppPermission permission) => permissions.contains(permission.key);

  /// Belongs to more than one organization, so can switch.
  bool get canSwitchOrganization => (memberships?.length ?? 0) > 1;

  /// Signed in, but not working in any organization yet: the app shows the
  /// welcome page (create one, or join by invitation) and nothing else.
  bool get needsOrganization => memberships != null && organization == null;

  /// Has every permission this app knows.
  bool get hasFullAccess => grants.length == AppPermission.values.length;
}
