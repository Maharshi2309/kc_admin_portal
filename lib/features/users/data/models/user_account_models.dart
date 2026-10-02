import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kc_admin_portal/shared/models/employee_summary_model.dart';
import 'package:kc_admin_portal/shared/models/json_converters.dart';

part 'user_account_models.freezed.dart';
part 'user_account_models.g.dart';

/// A staff login account: staff only, optionally linked to an employee
/// record. Each user has their own permissions (no roles, changed
/// 2026-10-02 at the client's request).
@freezed
abstract class UserAccountModel with _$UserAccountModel {
  const factory UserAccountModel({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,
    required String email,

    /// Permission keys, e.g. `employee.edit`.
    @Default(<String>[]) List<String> permissions,
    EmployeeSummaryModel? employee,
    @Default(true) bool isActive,
    @CompanyDateTimeConverter() DateTime? lastSignInAt,
  }) = _UserAccountModel;

  factory UserAccountModel.fromJson(Map<String, dynamic> json) =>
      _$UserAccountModelFromJson(json);
}

/// Response of `GET /users`.
@freezed
abstract class UserAccountListModel with _$UserAccountListModel {
  const factory UserAccountListModel({
    required List<UserAccountModel> items,
    required int total,
    required int page,
    required int pageSize,
  }) = _UserAccountListModel;

  factory UserAccountListModel.fromJson(Map<String, dynamic> json) =>
      _$UserAccountListModelFromJson(json);
}

/// Body of `POST /users`. The backend sends the new user an invitation to
/// set their own password; the app never handles other people's passwords.
/// A new user starts with [permissions] (often none, chosen next).
@freezed
abstract class UserAccountInput with _$UserAccountInput {
  const factory UserAccountInput({
    required String name,
    required String email,
    @JsonKey(includeIfNull: false) String? employeeId,
    @Default(<String>[]) List<String> permissions,
  }) = _UserAccountInput;

  factory UserAccountInput.fromJson(Map<String, dynamic> json) =>
      _$UserAccountInputFromJson(json);
}

/// Body of `PATCH /users/{id}`. `employeeId: null` unlinks the employee.
/// Permissions are changed separately (`PUT /users/{id}/permissions`).
@freezed
abstract class UserAccountUpdate with _$UserAccountUpdate {
  const factory UserAccountUpdate({
    required String name,
    required String email,
    String? employeeId,

    /// Only sent when changing it (deactivate / reactivate).
    @JsonKey(includeIfNull: false) bool? isActive,
  }) = _UserAccountUpdate;

  factory UserAccountUpdate.fromJson(Map<String, dynamic> json) =>
      _$UserAccountUpdateFromJson(json);
}

/// Search and page of the users list.
@freezed
abstract class UserQuery with _$UserQuery {
  const factory UserQuery({
    @Default('') String search,
    @Default(1) int page,
    @Default(UserQuery.defaultPageSize) int pageSize,
  }) = _UserQuery;

  const UserQuery._();

  static const int defaultPageSize = 10;

  bool get hasFilters => search.isNotEmpty;

  Map<String, Object?> toQueryParameters() => {
    if (search.isNotEmpty) 'search': search,
    'page': page,
    'pageSize': pageSize,
  };
}
