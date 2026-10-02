import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/network/session_events.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_access_store.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_permission_catalogue.dart';

/// DEV ONLY (`USE_MOCK_API=true`): the backend's request check
/// (docs/DATABASE_V2.md §4.2), run by every mock endpoint so the dev app
/// behaves like the real API:
///
/// - no session, or the user or their role deactivated → 401, and the
///   session ends (like the API interceptor does on a real 401);
/// - a missing permission → 403 `PERMISSION_DENIED`.
class MockGuard {
  MockGuard({required MockAccessStore this._store, this._sessionEvents});

  /// No checks: for tests of a single mock that are not about access.
  const MockGuard.allowAll() : _store = null, _sessionEvents = null;

  final MockAccessStore? _store;
  final SessionEvents? _sessionEvents;

  static final Map<String, String> _labels = {
    for (final module in mockPermissionCatalogue)
      for (final p in module.permissions) p.key: p.label,
  };

  /// Any signed-in user with a valid session (e.g. `GET /departments`).
  void signedIn() {
    final store = _store;
    if (store == null) return;
    final problem = store.sessionProblem();
    if (problem != null) {
      _sessionEvents?.notifyExpired(problem);
      throw UnauthorizedException(problem);
    }
  }

  void require(AppPermission permission) => requireAny([permission]);

  /// Whether the user holds [permission], for responses that leave out
  /// parts the role may not see (e.g. a day's change history).
  bool has(AppPermission permission) {
    final store = _store;
    if (store == null) return true;
    final id = store.currentUserId;
    return id != null && store.permissionsOf(id).contains(permission.key);
  }

  /// Passes when the user has at least one of [permissions].
  void requireAny(List<AppPermission> permissions) {
    final store = _store;
    if (store == null) return;
    signedIn();
    final held = store.permissionsOf(store.currentUserId!);
    if (permissions.any((p) => held.contains(p.key))) return;
    _sessionEvents?.notifyForbidden();
    final label = _labels[permissions.first.key] ?? permissions.first.key;
    throw ForbiddenException(
      'You do not have permission to '
      '${label[0].toLowerCase()}${label.substring(1)}.',
      ApiConstants.permissionDeniedCode,
    );
  }
}

final mockGuardProvider = Provider<MockGuard>(
  (ref) => MockGuard(
    store: ref.watch(mockAccessStoreProvider),
    sessionEvents: ref.watch(sessionEventsProvider),
  ),
);
