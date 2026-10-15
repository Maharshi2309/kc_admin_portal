import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/storage/local_storage.dart';
import 'package:kc_admin_portal/core/utils/phone_utils.dart';
import 'package:kc_admin_portal/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:kc_admin_portal/features/auth/data/models/login_response_model.dart';
import 'package:kc_admin_portal/features/auth/data/models/user_model.dart';
import 'package:kc_admin_portal/features/auth/domain/repositories/auth_repository.dart';
import 'package:kc_admin_portal/shared/models/organization_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.remote, required this.tokenStorage});

  final AuthRemoteDataSource remote;
  final TokenStorage tokenStorage;

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
    bool keepSignedIn = true,
  }) async {
    final response = await remote.login(email: email, password: password);
    await tokenStorage.writeToken(response.accessToken, persist: keepSignedIn);
    return response.user;
  }

  @override
  Future<UserModel?> restoreSession() async {
    final token = await tokenStorage.readToken();
    if (token == null || token.isEmpty) return null;

    try {
      return await remote.me();
    } on UnauthorizedException {
      await tokenStorage.clear();
      return null;
    }
    // Other errors (offline, server down) propagate so the app can offer a
    // retry instead of silently signing the user out.
  }

  @override
  Future<UserModel> switchOrganization(String organizationId) async =>
      _continueWith(await remote.switchOrganization(organizationId));

  @override
  Future<void> signOut() async {
    try {
      await remote.logout();
    } on AppException {
      // Signing out locally must always succeed, even offline.
    } finally {
      await tokenStorage.clear();
    }
  }

  @override
  Future<void> clearSession() => tokenStorage.clear();

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) => remote.register(
    name: name.trim(),
    email: email.trim(),
    password: password,
  );

  @override
  Future<UserModel> verifyEmail({
    required String email,
    required String code,
    bool keepSignedIn = true,
  }) async {
    final response = await remote.verifyEmail(
      email: email.trim(),
      code: code.trim(),
    );
    await tokenStorage.writeToken(response.accessToken, persist: keepSignedIn);
    return response.user;
  }

  @override
  Future<void> resendVerification(String email) =>
      remote.resendVerification(email.trim());

  @override
  Future<void> forgotPassword(String email) =>
      remote.forgotPassword(email.trim());

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String password,
  }) => remote.resetPassword(
    email: email.trim(),
    code: code.trim(),
    password: password,
  );

  /// A new token for the same session, kept like the current one.
  Future<UserModel> _continueWith(LoginResponseModel response) async {
    await tokenStorage.replaceToken(response.accessToken);
    return response.user;
  }

  @override
  Future<UserModel> createOrganization({
    required String name,
    required String timezone,
    bool paidLeave = true,
    String defaultCountry = PhoneUtils.defaultCountry,
  }) async => _continueWith(
    await remote.createOrganization(
      name: name.trim(),
      timezone: timezone,
      paidLeave: paidLeave,
      defaultCountry: defaultCountry,
    ),
  );

  @override
  Future<List<InvitationModel>> invitations() => remote.invitations();

  @override
  Future<UserModel> acceptInvitation(String id) async =>
      _continueWith(await remote.acceptInvitation(id));

  @override
  Future<void> declineInvitation(String id) => remote.declineInvitation(id);
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    remote: ref.watch(authRemoteDataSourceProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  ),
);
