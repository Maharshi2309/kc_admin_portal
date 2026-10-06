import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/app.dart';
import 'package:kc_admin_portal/app/router/app_router.dart';
import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/config/mock_latency.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/responsive/layout_mode.dart';
import 'package:kc_admin_portal/core/storage/local_storage.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/features/auth/data/models/user_model.dart';
import 'package:kc_admin_portal/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:kc_admin_portal/features/auth/domain/repositories/auth_repository.dart';
import 'package:kc_admin_portal/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:kc_admin_portal/shared/models/organization_model.dart';

import 'fake_dashboard.dart';

/// A signed-in admin with every permission. Tests of restricted users
/// build their own with `testUser.copyWith(permissions: [...])`.
final testUser = UserModel(
  id: '1',
  name: 'Test Admin',
  email: 'admin@example.com',
  permissions: [for (final p in AppPermission.values) p.key],
);

/// Mock API on, so features without a fake repository use the in-memory
/// dev data sources (with no simulated delay, see [pumpFullApp]).
const testEnv = Env(
  environment: AppEnvironment.dev,
  apiBaseUrl: 'http://localhost:3000/api',
  apiTimeout: Duration(seconds: 30),
  useMockApi: true,
);

/// In-memory [AuthRepository]. Accepts [validPassword]; anything else fails
/// like the server would.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.sessionUser, this.restoreError});

  /// User restored at start-up (`null` = signed out).
  UserModel? sessionUser;

  /// Thrown by [restoreSession] when set (e.g. offline at start-up).
  AppException? restoreError;

  static const String validPassword = 'correct-password';
  int signOutCalls = 0;

  /// The "Keep me signed in" choice of the last sign-in.
  bool? lastKeepSignedIn;

  @override
  Future<UserModel?> restoreSession() async {
    if (restoreError != null) throw restoreError!;
    return sessionUser;
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
    bool keepSignedIn = true,
  }) async {
    lastKeepSignedIn = keepSignedIn;
    if (password != validPassword) {
      throw const UnauthorizedException('Incorrect email or password.');
    }
    return sessionUser = testUser.copyWith(email: email);
  }

  /// Only changes the user: the dev mock's own session stays as it is, so
  /// tests of switching use the mock auth (see `pumpFullApp`'s `mockAuth`).
  @override
  Future<UserModel> switchOrganization(String organizationId) async {
    final user = sessionUser!;
    final membership = user.memberships!.firstWhere(
      (m) => m.organizationId == organizationId,
    );
    return sessionUser = user.copyWith(
      organization: OrganizationModel(
        id: membership.organizationId,
        name: membership.name,
      ),
    );
  }

  @override
  Future<void> signOut() async {
    signOutCalls++;
    sessionUser = null;
  }

  @override
  Future<void> clearSession() async => sessionUser = null;

  // Sign-up and organizations: simple stand-ins. Tests of these flows use
  // the dev mock's auth (`pumpFullApp(repository: null)`).

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {}

  @override
  Future<UserModel> verifyEmail({
    required String email,
    required String code,
    bool keepSignedIn = true,
  }) async => sessionUser = testUser.copyWith(email: email);

  @override
  Future<void> resendVerification(String email) async {}

  @override
  Future<void> forgotPassword(String email) async {}

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String password,
  }) async {}

  @override
  Future<UserModel> createOrganization({
    required String name,
    required String timezone,
    bool paidLeave = true,
  }) async {
    final organization = OrganizationModel(
      id: 'new',
      name: name,
      timezone: timezone,
    );
    return sessionUser = sessionUser!.copyWith(
      organization: organization,
      memberships: [
        ...?sessionUser!.memberships,
        MembershipModel(organizationId: 'new', name: name),
      ],
    );
  }

  @override
  Future<List<InvitationModel>> invitations() async => const [];

  @override
  Future<UserModel> acceptInvitation(String id) =>
      throw const NotFoundException('This invitation was not found.');

  @override
  Future<void> declineInvitation(String id) async {}
}

/// Pumps the whole app with fake auth and dashboard data (and a fixed clock)
/// and returns its router.
Future<GoRouter> pumpFullApp(
  WidgetTester tester, {

  /// The fake auth; null uses the dev mock's own sign-in (signed out at
  /// start), for tests that need the mock server's session, e.g. switching
  /// organization.
  required FakeAuthRepository? repository,
  FakeDashboardRepository? dashboard,

  /// Use the dashboard dev mock (linked to the attendance mock) instead of
  /// a fixed fake, for tests where dashboard and attendance interact.
  bool mockDashboard = false,
  Size size = const Size(1440, 1000),
  Env env = testEnv,
  List<Override> overrides = const [],
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final container = ProviderContainer(
    overrides: [
      envProvider.overrideWithValue(env),
      if (repository != null)
        authRepositoryProvider.overrideWithValue(repository)
      else
        tokenStorageProvider.overrideWithValue(MemoryTokenStorage()),
      if (!mockDashboard)
        dashboardRepositoryProvider.overrideWithValue(
          dashboard ?? FakeDashboardRepository(),
        ),
      clockProvider.overrideWithValue(() => testNow),
      mockLatencyProvider.overrideWithValue(Duration.zero),
      ...overrides,
    ],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const KeshavAdminApp(),
    ),
  );
  await tester.pumpAndSettle();
  return container.read(routerProvider);
}

String currentLocation(GoRouter router) =>
    router.routerDelegate.currentConfiguration.uri.toString();

/// A provider container wired like [pumpFullApp] (dev mock API, fixed
/// clock, no simulated latency) for testing providers without widgets.
ProviderContainer createTestContainer({List<Override> overrides = const []}) {
  final container = ProviderContainer(
    overrides: [
      envProvider.overrideWithValue(testEnv),
      clockProvider.overrideWithValue(() => testNow),
      mockLatencyProvider.overrideWithValue(Duration.zero),
      ...overrides,
    ],
  );
  addTearDown(container.dispose);
  return container;
}

/// Token storage without the platform plugin, for widget tests.
class MemoryTokenStorage implements TokenStorage {
  String? _token;

  @override
  Future<String?> readToken() async => _token;

  @override
  Future<void> writeToken(String token, {bool persist = true}) async =>
      _token = token;

  @override
  Future<void> replaceToken(String token) async => _token = token;

  @override
  Future<void> clear() async => _token = null;
}

/// A layout choice kept in memory, starting at [saved].
class MemoryLayoutModeStore implements LayoutModeStore {
  MemoryLayoutModeStore([this.saved]);

  LayoutMode? saved;

  @override
  Future<LayoutMode?> read() async => saved;

  @override
  Future<void> write(LayoutMode mode) async => saved = mode;
}
