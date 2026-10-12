import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_access_store.dart';
import 'package:kc_admin_portal/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:kc_admin_portal/features/auth/data/models/login_response_model.dart';
import 'package:kc_admin_portal/features/auth/data/models/user_model.dart';

/// DEV ONLY (`USE_MOCK_API=true`): lets the app be used before the backend
/// exists. Signs in as one of the mock staff users ([MockAccessStore], e.g.
/// `admin@keshav.in` or `nisha.solanki@keshav.in`) with the password
/// [password], or a user added in Access control with the password set for
/// them, and answers with that user's own permissions, so the app
/// can be tried with different access. Never enabled in production builds (see
/// `Env.fromEnvironment`).
class AuthMockDataSource implements AuthRemoteDataSource {
  AuthMockDataSource({
    required this.store,
    this.readToken,
    this.latency = Duration.zero,
  });

  final MockAccessStore store;

  /// The saved session token, so a restarted app restores the same user.
  final Future<String?> Function()? readToken;
  final Duration latency;

  static const String password = MockAccessStore.seedPassword;

  /// Tokens are `mock-dev-token.<userId>`.
  static const String _tokenPrefix = 'mock-dev-token.';

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(latency);
    final account = store.userByEmail(email);
    if (account == null || !store.passwordMatches(account.id, password)) {
      throw const UnauthorizedException(
        'Incorrect email or password. (Mock API: sign in as a user from '
        'Access control › Users, e.g. admin@keshav.in with the password '
        '"password", or a user you added with the password you set)',
      );
    }
    if (!account.isActive) {
      throw const UnauthorizedException('This account has been deactivated.');
    }
    store.signIn(account.id);
    _checkSession();
    return LoginResponseModel(
      accessToken: '$_tokenPrefix${account.id}',
      user: _user(account.id),
    );
  }

  /// Older dev tokens carry no user id; they restore the current mock user.
  @override
  Future<UserModel> me() async {
    await Future<void>.delayed(latency);
    final token = await readToken?.call();
    final id = token != null && token.startsWith(_tokenPrefix)
        ? token.substring(_tokenPrefix.length)
        : store.currentUserId;
    if (id == null) throw const UnauthorizedException();
    try {
      store.resume(id);
    } on NotFoundException {
      throw const UnauthorizedException();
    }
    _checkSession();
    return _user(id);
  }

  @override
  Future<void> logout() async {
    store.signOut();
  }

  /// A deactivated user can't sign in (§4.2).
  void _checkSession() {
    final problem = store.sessionProblem();
    if (problem != null) {
      store.signOut();
      throw UnauthorizedException(problem);
    }
  }

  UserModel _user(String id) {
    final account = store.user(id);
    return UserModel(
      id: account.id,
      name: account.name,
      email: account.email,
      permissions: store.permissionsOf(id),
    );
  }
}
