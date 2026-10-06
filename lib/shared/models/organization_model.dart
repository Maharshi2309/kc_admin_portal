import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kc_admin_portal/shared/models/json_converters.dart';

part 'organization_model.freezed.dart';
part 'organization_model.g.dart';

/// The organization the signed-in user is working in (one company's
/// separate workspace, docs/ARCHITECTURE_MULTI_ORG.md §A). The server
/// decides it from the session; the app never sends its id with data
/// requests.
@freezed
abstract class OrganizationModel with _$OrganizationModel {
  const factory OrganizationModel({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,
    String? logoUrl,

    /// IANA time zone, e.g. `Asia/Kolkata`: "today" and month boundaries
    /// follow it.
    String? timezone,
  }) = _OrganizationModel;

  factory OrganizationModel.fromJson(Map<String, dynamic> json) =>
      _$OrganizationModelFromJson(json);
}

/// One organization the user belongs to, for "Your organizations".
@freezed
abstract class MembershipModel with _$MembershipModel {
  const factory MembershipModel({
    @JsonKey(fromJson: idFromJson) required String organizationId,
    required String name,
    String? logoUrl,
  }) = _MembershipModel;

  factory MembershipModel.fromJson(Map<String, dynamic> json) =>
      _$MembershipModelFromJson(json);
}

/// An invitation to join an organization, waiting for the signed-in
/// person (`GET /invitations`, matched by their verified email).
@freezed
abstract class InvitationModel with _$InvitationModel {
  const factory InvitationModel({
    @JsonKey(fromJson: idFromJson) required String id,
    required OrganizationModel organization,

    /// Who sent it, e.g. "Ravi Mehta".
    String? invitedBy,
  }) = _InvitationModel;

  factory InvitationModel.fromJson(Map<String, dynamic> json) =>
      _$InvitationModelFromJson(json);
}
