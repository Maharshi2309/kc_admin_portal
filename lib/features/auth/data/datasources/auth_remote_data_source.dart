import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/config/mock_latency.dart';
import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/network/api_client.dart';
import 'package:kc_admin_portal/core/storage/local_storage.dart';
import 'package:kc_admin_portal/core/utils/phone_utils.dart';
import 'package:kc_admin_portal/features/auth/data/datasources/auth_mock_data_source.dart';
import 'package:kc_admin_portal/features/auth/data/models/login_response_model.dart';
import 'package:kc_admin_portal/features/auth/data/models/user_model.dart';
import 'package:kc_admin_portal/shared/mock/mock_tenant.dart';
import 'package:kc_admin_portal/shared/models/organization_model.dart';

/// Auth endpoints of the REST API.
abstract interface class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });

  /// The user the current token belongs to, in its organization.
  Future<UserModel> me();

  /// Works in another of the user's organizations from now on: a new token
  /// for that organization, and the user with their permissions there.
  Future<LoginResponseModel> switchOrganization(String organizationId);

  Future<void> logout();

  // Accounts and organizations (2026-10-06, docs/ARCHITECTURE_MULTI_ORG.md)

  /// A new account; a code is emailed to verify the address.
  Future<void> register({
    required String name,
    required String email,
    required String password,
  });

  /// Verifies the address with the emailed code and signs in.
  Future<LoginResponseModel> verifyEmail({
    required String email,
    required String code,
  });

  Future<void> resendVerification(String email);

  /// Emails a code to reset the password (always succeeds, so nobody can
  /// find out which emails have accounts).
  Future<void> forgotPassword(String email);

  Future<void> resetPassword({
    required String email,
    required String code,
    required String password,
  });

  /// Creates an organization with the caller as owner, and works in it.
  Future<LoginResponseModel> createOrganization({
    required String name,
    required String timezone,
    bool paidLeave = true,
    String defaultCountry = PhoneUtils.defaultCountry,
  });

  Future<List<InvitationModel>> invitations();

  /// Joins the organization and works in it.
  Future<LoginResponseModel> acceptInvitation(String id);

  Future<void> declineInvitation(String id);
}

class AuthApiDataSource implements AuthRemoteDataSource {
  AuthApiDataSource(this._client);

  final ApiClient _client;

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) => _client.post(
    ApiConstants.login,
    body: {'email': email, 'password': password},
    parse: (json) => LoginResponseModel.fromJson(json! as Map<String, dynamic>),
  );

  @override
  Future<UserModel> me() => _client.get(
    ApiConstants.me,
    parse: (json) => UserModel.fromJson(json! as Map<String, dynamic>),
  );

  @override
  Future<LoginResponseModel> switchOrganization(String organizationId) =>
      _client.post(
        ApiConstants.switchOrganization,
        body: {'organizationId': organizationId},
        parse: (json) =>
            LoginResponseModel.fromJson(json! as Map<String, dynamic>),
      );

  @override
  Future<void> logout() =>
      _client.post(ApiConstants.logout, parse: ApiClient.ignoreBody);

  static LoginResponseModel _session(Object? json) =>
      LoginResponseModel.fromJson(json! as Map<String, dynamic>);

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) => _client.post(
    ApiConstants.register,
    body: {'name': name, 'email': email, 'password': password},
    parse: ApiClient.ignoreBody,
  );

  @override
  Future<LoginResponseModel> verifyEmail({
    required String email,
    required String code,
  }) => _client.post(
    ApiConstants.verifyEmail,
    body: {'email': email, 'code': code},
    parse: _session,
  );

  @override
  Future<void> resendVerification(String email) => _client.post(
    ApiConstants.resendVerification,
    body: {'email': email},
    parse: ApiClient.ignoreBody,
  );

  @override
  Future<void> forgotPassword(String email) => _client.post(
    ApiConstants.forgotPassword,
    body: {'email': email},
    parse: ApiClient.ignoreBody,
  );

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String password,
  }) => _client.post(
    ApiConstants.resetPassword,
    body: {'email': email, 'code': code, 'password': password},
    parse: ApiClient.ignoreBody,
  );

  @override
  Future<LoginResponseModel> createOrganization({
    required String name,
    required String timezone,
    bool paidLeave = true,
    String defaultCountry = PhoneUtils.defaultCountry,
  }) => _client.post(
    ApiConstants.organizations,
    body: {
      'name': name,
      'timezone': timezone,
      'paidLeave': paidLeave,
      'defaultCountry': defaultCountry,
    },
    parse: _session,
  );

  @override
  Future<List<InvitationModel>> invitations() => _client.get(
    ApiConstants.invitations,
    parse: (json) => [
      for (final item in json! as List<Object?>)
        InvitationModel.fromJson(item! as Map<String, dynamic>),
    ],
  );

  @override
  Future<LoginResponseModel> acceptInvitation(String id) =>
      _client.post(ApiConstants.acceptInvitation(id), parse: _session);

  @override
  Future<void> declineInvitation(String id) => _client.post(
    ApiConstants.declineInvitation(id),
    parse: ApiClient.ignoreBody,
  );
}

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final env = ref.watch(envProvider);
  if (env.useMockApi) {
    final directory = ref.watch(mockDirectoryProvider);
    // Each organization's members, read when needed: watching the active
    // organization here would loop back through the signed-in user.
    return AuthMockDataSource(
      accessOf: (id) => directory.organization(id) == null
          ? null
          : ref.read(mockTenantProvider(id)).access,
      directory: directory,
      readToken: ref.watch(tokenStorageProvider).readToken,
      latency: ref.watch(mockLatencyProvider),
    );
  }
  return AuthApiDataSource(ref.watch(apiClientProvider));
});
