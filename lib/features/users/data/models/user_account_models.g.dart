// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_account_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserAccountModel _$UserAccountModelFromJson(Map<String, dynamic> json) =>
    _UserAccountModel(
      id: idFromJson(json['id']),
      name: json['name'] as String,
      email: json['email'] as String,
      permissions:
          (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      employee: json['employee'] == null
          ? null
          : EmployeeSummaryModel.fromJson(
              json['employee'] as Map<String, dynamic>,
            ),
      isActive: json['isActive'] as bool? ?? true,
      lastSignInAt: _$JsonConverterFromJson<String, DateTime>(
        json['lastSignInAt'],
        const CompanyDateTimeConverter().fromJson,
      ),
      invitationPending: json['invitationPending'] as bool? ?? false,
    );

Map<String, dynamic> _$UserAccountModelToJson(_UserAccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'permissions': instance.permissions,
      'employee': instance.employee?.toJson(),
      'isActive': instance.isActive,
      'lastSignInAt': _$JsonConverterToJson<String, DateTime>(
        instance.lastSignInAt,
        const CompanyDateTimeConverter().toJson,
      ),
      'invitationPending': instance.invitationPending,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_UserAccountListModel _$UserAccountListModelFromJson(
  Map<String, dynamic> json,
) => _UserAccountListModel(
  items: (json['items'] as List<dynamic>)
      .map((e) => UserAccountModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
);

Map<String, dynamic> _$UserAccountListModelToJson(
  _UserAccountListModel instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'total': instance.total,
  'page': instance.page,
  'pageSize': instance.pageSize,
};

_UserAccountInput _$UserAccountInputFromJson(Map<String, dynamic> json) =>
    _UserAccountInput(
      name: json['name'] as String,
      email: json['email'] as String,
      employeeId: json['employeeId'] as String?,
      permissions:
          (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$UserAccountInputToJson(_UserAccountInput instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'employeeId': ?instance.employeeId,
      'permissions': instance.permissions,
    };

_UserAccountUpdate _$UserAccountUpdateFromJson(Map<String, dynamic> json) =>
    _UserAccountUpdate(
      name: json['name'] as String,
      email: json['email'] as String,
      employeeId: json['employeeId'] as String?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$UserAccountUpdateToJson(_UserAccountUpdate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'employeeId': instance.employeeId,
      'isActive': ?instance.isActive,
    };
