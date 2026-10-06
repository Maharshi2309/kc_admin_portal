import 'package:kc_admin_portal/core/constants/app_constants.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/shared/mock/mock_session.dart';
import 'package:kc_admin_portal/shared/models/organization_model.dart';

/// DEV ONLY: a platform-wide login account (docs/ARCHITECTURE_MULTI_ORG.md
/// §A). Membership of organizations lives in each organization's
/// `MockAccessStore`.
class MockAccount {
  MockAccount({
    required this.id,
    required this.name,
    required this.email,
    this.password = MockDirectory.samplePassword,
    this.verified = true,
  });

  final String id;
  String name;
  final String email;
  String password;
  bool verified;
}

/// DEV ONLY (`USE_MOCK_API=true`): the platform level of the mock server:
/// accounts (sign-up, email verification, password reset) and the
/// organizations that exist. Like the real backend, accounts don't belong to
/// an organization; anyone may sign up free and create one (2026-10-06).
///
/// Emails aren't sent: every code is [verificationCode].
class MockDirectory {
  MockDirectory() {
    organizations.addAll(MockSession.sampleOrganizations);
    accounts.addAll([
      for (final (id, name, email) in _sampleAccounts)
        MockAccount(id: id, name: name, email: email),
    ]);
  }

  /// The sample accounts' password.
  static const String samplePassword = 'password';

  /// The code "emailed" for verification and password reset.
  static const String verificationCode = '123456';

  static const int passwordMinLength = AppConstants.passwordMinLength;

  static const List<(String, String, String)> _sampleAccounts = [
    ('u1', 'Admin', 'admin@keshav.in'),
    ('u2', 'Mansi Rao', 'mansi.rao@keshav.in'),
    ('u3', 'Nisha Solanki', 'nisha.solanki@keshav.in'),
    ('u4', 'Kunal Desai', 'kunal.desai@keshav.in'),
    ('u5', 'Arjun Joshi', 'arjun.joshi@keshav.in'),
    ('u20', 'Ravi Mehta', 'ravi.mehta@sunrise.in'),
    ('u21', 'Farah Khan', 'farah.khan@sunrise.in'),
  ];

  final List<OrganizationModel> organizations = [];
  final List<MockAccount> accounts = [];
  int _nextAccount = 1;
  int _nextOrganization = 1;

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String normalised(String email) => email.trim().toLowerCase();

  MockAccount? accountByEmail(String email) {
    final wanted = normalised(email);
    return accounts.where((a) => a.email == wanted).firstOrNull;
  }

  MockAccount? account(String id) =>
      accounts.where((a) => a.id == id).firstOrNull;

  OrganizationModel? organization(String id) =>
      organizations.where((o) => o.id == id).firstOrNull;

  /// `POST /auth/register`: a new, unverified account. Registering again
  /// before verifying replaces the name and password.
  MockAccount register({
    required String name,
    required String email,
    required String password,
  }) {
    final address = normalised(email);
    final existing = accountByEmail(address);
    final errors = {
      if (name.trim().isEmpty) 'name': 'Enter your name',
      if (address.isEmpty)
        'email': 'Enter your email address'
      else if (!_emailPattern.hasMatch(address))
        'email': 'Enter a valid email address'
      else if (existing != null && existing.verified)
        'email': 'An account with this email already exists. Sign in instead.',
      if (password.length < passwordMinLength)
        'password': 'Use at least $passwordMinLength characters',
    };
    if (errors.isNotEmpty) {
      throw ValidationException(errors.values.first, fieldErrors: errors);
    }
    if (existing != null) {
      return existing
        ..name = name.trim()
        ..password = password;
    }
    final account = MockAccount(
      id: 'a${_nextAccount++}',
      name: name.trim(),
      email: address,
      password: password,
      verified: false,
    );
    accounts.add(account);
    return account;
  }

  static void _checkCode(String code) {
    if (code.trim() != verificationCode) {
      throw const ValidationException(
        'This code is not right. Check the latest email, or send a new code.',
        fieldErrors: {
          'code':
              'This code is not right. Check the latest email, or send a '
              'new code.',
        },
      );
    }
  }

  /// `POST /auth/verify-email`.
  MockAccount verify(String email, String code) {
    final account = accountByEmail(email);
    _checkCode(code);
    if (account == null) throw const UnauthorizedException();
    return account..verified = true;
  }

  /// `POST /auth/reset-password`. Also verifies the email: the code
  /// proves the person reads it.
  void resetPassword(String email, String code, String password) {
    _checkCode(code);
    if (password.length < passwordMinLength) {
      throw const ValidationException(
        'Use at least $passwordMinLength characters',
        fieldErrors: {'password': 'Use at least $passwordMinLength characters'},
      );
    }
    final account = accountByEmail(email);
    if (account == null) throw const UnauthorizedException();
    account
      ..password = password
      ..verified = true;
  }

  /// `POST /organizations`: a new, empty organization.
  OrganizationModel createOrganization({
    required String name,
    required String timezone,
    bool paidLeave = true,
  }) {
    final trimmed = name.trim();
    final errors = {
      if (trimmed.isEmpty) 'name': 'Enter the organization name',
      if (trimmed.length > organizationNameMaxLength)
        'name': 'Use at most $organizationNameMaxLength characters',
      if (timezone.trim().isEmpty) 'timezone': 'Choose a time zone',
    };
    if (errors.isNotEmpty) {
      throw ValidationException(errors.values.first, fieldErrors: errors);
    }
    final organization = OrganizationModel(
      id: 'org-new-${_nextOrganization++}',
      name: trimmed,
      timezone: timezone,
    );
    organizations.add(organization);
    _paidLeave[organization.id] = paidLeave;
    return organization;
  }

  static const int organizationNameMaxLength = 100;

  /// The leave choice made when an organization was created.
  final Map<String, bool> _paidLeave = {};

  /// Whether a new organization chose the paid leave preset.
  bool paidLeaveFor(String organizationId) =>
      _paidLeave[organizationId] ?? true;
}
