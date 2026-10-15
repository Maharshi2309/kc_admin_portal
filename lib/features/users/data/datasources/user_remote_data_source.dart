import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/network/api_client.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/organization_providers.dart';
import 'package:kc_admin_portal/features/users/data/models/user_account_models.dart';
import 'package:kc_admin_portal/shared/mock/mock_tenant.dart';

/// Staff login accounts over the API. Throws an `AppException` on failure.
abstract interface class UserRemoteDataSource {
  Future<UserAccountListModel> list(UserQuery query);

  Future<UserAccountModel> getById(String id);

  Future<UserAccountModel> create(UserAccountInput input);

  Future<UserAccountModel> update(String id, UserAccountUpdate input);

  /// Replaces the user's permissions with [keys].
  Future<UserAccountModel> setPermissions(String id, List<String> keys);

  /// Cancels the pending invitation [id]; the user is removed.
  Future<void> cancelInvitation(String id);

  /// Emails the pending invitation [id] again.
  Future<void> resendInvitation(String id);
}

class UserApiDataSource implements UserRemoteDataSource {
  UserApiDataSource(this._client);

  final ApiClient _client;

  static UserAccountModel _user(Object? json) =>
      UserAccountModel.fromJson(json! as Map<String, dynamic>);

  @override
  Future<UserAccountListModel> list(UserQuery query) => _client.get(
    ApiConstants.users,
    query: query.toQueryParameters(),
    parse: (json) =>
        UserAccountListModel.fromJson(json! as Map<String, dynamic>),
  );

  @override
  Future<UserAccountModel> getById(String id) =>
      _client.get(ApiConstants.user(id), parse: _user);

  @override
  Future<UserAccountModel> create(UserAccountInput input) =>
      _client.post(ApiConstants.users, body: input.toJson(), parse: _user);

  @override
  Future<UserAccountModel> update(String id, UserAccountUpdate input) =>
      _client.patch(ApiConstants.user(id), body: input.toJson(), parse: _user);

  @override
  Future<UserAccountModel> setPermissions(String id, List<String> keys) =>
      _client.put(
        ApiConstants.userPermissions(id),
        body: {'permissions': keys},
        parse: _user,
      );

  @override
  Future<void> cancelInvitation(String id) => _client.delete(
    ApiConstants.userInvitation(id),
    parse: ApiClient.ignoreBody,
  );

  @override
  Future<void> resendInvitation(String id) => _client.post(
    ApiConstants.resendUserInvitation(id),
    parse: ApiClient.ignoreBody,
  );
}

final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  if (ref.watch(envProvider).useMockApi) {
    return ref.watch(mockActiveTenantProvider).users;
  }
  // A new organization means new data: rebuild (docs/ARCHITECTURE_MULTI_ORG.md §C).
  ref.watch(activeOrganizationScopeProvider);
  return UserApiDataSource(ref.watch(apiClientProvider));
});
