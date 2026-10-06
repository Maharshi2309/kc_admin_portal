// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: idFromJson(json['id']),
  name: json['name'] as String,
  email: json['email'] as String,
  permissions:
      (json['permissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  organization: json['organization'] == null
      ? null
      : OrganizationModel.fromJson(
          json['organization'] as Map<String, dynamic>,
        ),
  memberships: (json['memberships'] as List<dynamic>?)
      ?.map((e) => MembershipModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'permissions': instance.permissions,
      'organization': instance.organization?.toJson(),
      'memberships': instance.memberships?.map((e) => e.toJson()).toList(),
    };
