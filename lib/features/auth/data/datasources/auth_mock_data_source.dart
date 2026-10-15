import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/utils/phone_utils.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_access_store.dart';
import 'package:kc_admin_portal/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:kc_admin_portal/features/auth/data/models/login_response_model.dart';
import 'package:kc_admin_portal/features/auth/data/models/user_model.dart';
import 'package:kc_admin_portal/shared/mock/mock_directory.dart';
import 'package:kc_admin_portal/shared/mock/mock_session.dart';
import 'package:kc_admin_portal/shared/models/organization_model.dart';

/// DEV ONLY (`USE_MOCK_API=true`): lets the app be used before the backend
/// exists. Signs in as one of the sample accounts (e.g. `admin@keshav.in`,
/// `nisha.solanki@keshav.in` or `ravi.mehta@sunrise.in`) with the password
/// [password], or as a new account made with "Create an account" (every
/// emailed code is [MockDirectory.verificationCode]). Answers with the
/// user's organizations and their own permissions in the active one. Never
/// enabled in production builds (see `Env.fromEnvironment`).
///
/// Like the real backend (docs/ARCHITECTURE_MULTI_ORG.md §C), the token
/// names the user **and** the active organization; switching, creating or
/// joining an organization issues a new token.
class AuthMockDataSource implements AuthRemoteDataSource {
  /// Either one organization's [store] (tests), or [accessOf] for every
  /// organization (the app). [accessOf] also serves organizations created
  /// later, so it creates their store on first use.
  AuthMockDataSource({
    MockAccessStore? store,
    MockAccessStore? Function(String organizationId)? accessOf,
    MockDirectory? directory,
    this.readToken,
    this.latency = Duration.zero,
  }) : assert(store != null || accessOf != null),
       directory = directory ?? MockDirectory(),
       _accessOf =
           accessOf ?? ((id) => id == store!.organizationId ? store : null),
       _fixedSession = store?.session;

  final MockAccessStore? Function(String organizationId) _accessOf;
  final MockDirectory directory;
  final MockSession? _fixedSession;

  /// The saved session token, so a restarted app restores the same user.
  final Future<String?> Function()? readToken;
  final Duration latency;

  static const String password = MockDirectory.samplePassword;

  /// Tokens are `mock-dev-token.<userId>[.<organizationId>]`.
  static const String _tokenPrefix = 'mock-dev-token.';

  static String _token(String userId, String? organizationId) =>
      '$_tokenPrefix$userId${organizationId == null ? '' : '.$organizationId'}';

  /// The organizations with their member stores.
  Iterable<(OrganizationModel, MockAccessStore)> get _stores sync* {
    for (final organization in directory.organizations) {
      final store = _accessOf(organization.id);
      if (store != null) yield (organization, store);
    }
  }

  MockSession get session => _fixedSession ?? _stores.first.$2.session;

  MockAccessStore _store(String organizationId) {
    final store = _accessOf(organizationId);
    if (store == null) {
      throw const NotFoundException('This organization was not found.');
    }
    return store;
  }

  /// Where [userId] can work: their active memberships.
  List<OrganizationModel> _organizationsOf(String userId) => [
    for (final (organization, store) in _stores)
      if (store.isActiveMember(userId)) organization,
  ];

  Future<void> _wait() => Future<void>.delayed(latency);

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    await _wait();
    final account = directory.accountByEmail(email);
    if (account == null || password != account.password) {
      throw const UnauthorizedException(
        'Incorrect email or password. (Mock API: sign in as a sample user, '
        'e.g. admin@keshav.in, with the password "password", or create an '
        'account)',
      );
    }
    if (!account.verified) {
      throw const ForbiddenException(
        'Verify your email address first: enter the code we emailed you.',
        ApiConstants.emailNotVerifiedCode,
      );
    }
    final organizations = _organizationsOf(account.id);
    if (organizations.isEmpty &&
        _stores.any((s) => s.$2.isDeactivatedMember(account.id))) {
      throw const UnauthorizedException('This account has been deactivated.');
    }
    // The server picks the organization last used; the mock, the first.
    // None yet: signed in, to create or join one.
    final organization = organizations.firstOrNull;
    if (organization != null) {
      final store = _store(organization.id)..signIn(account.id);
      _checkSession(store);
    } else {
      session.start(account.id, null);
    }
    return _response(account.id, organization?.id);
  }

  /// A token without an organization (or older dev tokens) restores the
  /// user's first organization, or none for a new account.
  @override
  Future<UserModel> me() async {
    await _wait();
    final token = await readToken?.call();
    final parts = token != null && token.startsWith(_tokenPrefix)
        ? token.substring(_tokenPrefix.length).split('.')
        : const <String>[];
    final userId = parts.isNotEmpty ? parts.first : session.userId;
    if (userId == null || directory.account(userId) == null) {
      throw const UnauthorizedException();
    }
    final organizationId = parts.length > 1
        ? parts[1]
        : _organizationsOf(userId).firstOrNull?.id ??
              (parts.isEmpty ? session.organizationId : null);
    if (organizationId == null) {
      session.start(userId, null);
      return _user(userId, null);
    }
    final MockAccessStore store;
    try {
      store = _store(organizationId)..resume(userId);
    } on NotFoundException {
      throw const UnauthorizedException();
    }
    _checkSession(store);
    return _user(userId, organizationId);
  }

  @override
  Future<LoginResponseModel> switchOrganization(String organizationId) async {
    await _wait();
    final userId = _signedInUser();
    final store = _accessOf(organizationId);
    // Not a member: as if the organization didn't exist (§H).
    if (store == null || !store.isActiveMember(userId)) {
      throw const NotFoundException('This organization was not found.');
    }
    store.resume(userId);
    return _response(userId, organizationId);
  }

  @override
  Future<void> logout() async => session.end();

  // Accounts

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _wait();
    directory.register(name: name, email: email, password: password);
  }

  @override
  Future<LoginResponseModel> verifyEmail({
    required String email,
    required String code,
  }) async {
    await _wait();
    final account = directory.verify(email, code);
    final organization = _organizationsOf(account.id).firstOrNull;
    session.start(account.id, organization?.id);
    return _response(account.id, organization?.id);
  }

  @override
  Future<void> resendVerification(String email) => _wait();

  @override
  Future<void> forgotPassword(String email) => _wait();

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String password,
  }) async {
    await _wait();
    directory.resetPassword(email, code, password);
  }

  // Organizations and invitations

  @override
  Future<LoginResponseModel> createOrganization({
    required String name,
    required String timezone,
    bool paidLeave = true,
    String defaultCountry = PhoneUtils.defaultCountry,
  }) async {
    await _wait();
    final account = directory.account(_signedInUser())!;
    final organization = directory.createOrganization(
      name: name,
      timezone: timezone,
      paidLeave: paidLeave,
      defaultCountry: defaultCountry,
    );
    _store(
      organization.id,
    ).addOwner(userId: account.id, name: account.name, email: account.email);
    session.start(account.id, organization.id);
    return _response(account.id, organization.id);
  }

  @override
  Future<List<InvitationModel>> invitations() async {
    await _wait();
    final account = directory.account(_signedInUser())!;
    return [
      for (final (organization, store) in _stores)
        if (store.invitationFor(account.email) case final invitation?)
          InvitationModel(
            id: invitation.id,
            organization: organization,
            invitedBy: _ownerName(store),
          ),
    ];
  }

  /// Someone who manages the organization, to say who invited.
  static String? _ownerName(MockAccessStore store) => store.users
      .where(
        (u) =>
            u.isActive &&
            !u.invitationPending &&
            u.permissions.contains('permission.manage'),
      )
      .firstOrNull
      ?.name;

  (OrganizationModel, MockAccessStore) _invitation(String id) {
    final account = directory.account(_signedInUser())!;
    for (final (organization, store) in _stores) {
      if (store.invitationFor(account.email)?.id == id) {
        return (organization, store);
      }
    }
    throw const NotFoundException('This invitation is no longer valid.');
  }

  @override
  Future<LoginResponseModel> acceptInvitation(String id) async {
    await _wait();
    final userId = _signedInUser();
    final (organization, store) = _invitation(id);
    store.acceptInvitation(id, userId: userId);
    session.start(userId, organization.id);
    return _response(userId, organization.id);
  }

  @override
  Future<void> declineInvitation(String id) async {
    await _wait();
    final (_, store) = _invitation(id);
    store.declineInvitation(id);
  }

  // Helpers

  String _signedInUser() {
    final userId = session.userId;
    if (userId == null) throw const UnauthorizedException();
    return userId;
  }

  /// A deactivated user can't sign in (§4.2).
  void _checkSession(MockAccessStore store) {
    final problem = store.sessionProblem();
    if (problem != null) {
      store.signOut();
      throw UnauthorizedException(problem);
    }
  }

  LoginResponseModel _response(String userId, String? organizationId) =>
      LoginResponseModel(
        accessToken: _token(userId, organizationId),
        user: _user(userId, organizationId),
      );

  UserModel _user(String id, String? organizationId) {
    final account = directory.account(id);
    final store = organizationId == null ? null : _store(organizationId);
    final member = store?.user(id);
    return UserModel(
      id: id,
      name: account?.name ?? member!.name,
      email: account?.email ?? member!.email,
      permissions: store?.permissionsOf(id) ?? const [],
      organization: organizationId == null
          ? null
          : directory.organization(organizationId),
      memberships: [
        for (final organization in _organizationsOf(id))
          MembershipModel(
            organizationId: organization.id,
            name: organization.name,
            logoUrl: organization.logoUrl,
          ),
      ],
    );
  }
}
