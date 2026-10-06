// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrganizationModel _$OrganizationModelFromJson(Map<String, dynamic> json) =>
    _OrganizationModel(
      id: idFromJson(json['id']),
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String?,
      timezone: json['timezone'] as String?,
    );

Map<String, dynamic> _$OrganizationModelToJson(_OrganizationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logoUrl': instance.logoUrl,
      'timezone': instance.timezone,
    };

_MembershipModel _$MembershipModelFromJson(Map<String, dynamic> json) =>
    _MembershipModel(
      organizationId: idFromJson(json['organizationId']),
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String?,
    );

Map<String, dynamic> _$MembershipModelToJson(_MembershipModel instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'name': instance.name,
      'logoUrl': instance.logoUrl,
    };

_InvitationModel _$InvitationModelFromJson(Map<String, dynamic> json) =>
    _InvitationModel(
      id: idFromJson(json['id']),
      organization: OrganizationModel.fromJson(
        json['organization'] as Map<String, dynamic>,
      ),
      invitedBy: json['invitedBy'] as String?,
    );

Map<String, dynamic> _$InvitationModelToJson(_InvitationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organization': instance.organization.toJson(),
      'invitedBy': instance.invitedBy,
    };
