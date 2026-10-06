import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/network/session_events.dart';
import 'package:kc_admin_portal/features/auth/data/models/user_model.dart';
import 'package:kc_admin_portal/features/auth/data/repositories/auth_repository_impl.dart';

/// The single source of truth for "who is signed in".
///
/// - loading: restoring a stored session at start-up
/// - data(null): signed out
/// - data(user): signed in
/// - error: the stored session could not be checked (e.g. offline)
///
/// The router redirects based on this state.
class AuthController extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    final events = ref.watch(sessionEventsProvider);
    final expired = events.onExpired.listen(
      (reason) => unawaited(_onSessionExpired(reason)),
    );
    final forbidden = events.onForbidden.listen((_) => unawaited(refresh()));
    ref
      ..onDispose(expired.cancel)
      ..onDispose(forbidden.cancel);

    return ref.read(authRepositoryProvider).restoreSession();
  }

  /// Throws an `AppException` on failure; the login form shows it.
  Future<void> signIn({
    required String email,
    required String password,
    bool keepSignedIn = true,
  }) async {
    final user = await ref
        .read(authRepositoryProvider)
        .signIn(email: email, password: password, keepSignedIn: keepSignedIn);
    if (!ref.mounted) return;
    ref.read(sessionExpiredNoticeProvider.notifier).dismiss();
    signedOutByUser = false;
    state = AsyncData(user);
  }

  /// Works in another of the user's organizations. Every data provider
  /// watches the active organization, so all data reloads for it.
  /// Throws an `AppException` on failure; the current organization stays.
  Future<void> switchOrganization(String organizationId) async {
    final user = await ref
        .read(authRepositoryProvider)
        .switchOrganization(organizationId);
    if (!ref.mounted) return;
    state = AsyncData(user);
  }

  /// Verifies a new account's email and starts its session.
  Future<void> verifyEmail({
    required String email,
    required String code,
    bool keepSignedIn = true,
  }) async {
    final user = await ref
        .read(authRepositoryProvider)
        .verifyEmail(email: email, code: code, keepSignedIn: keepSignedIn);
    if (!ref.mounted) return;
    signedOutByUser = false;
    state = AsyncData(user);
  }

  /// Creates an organization and works in it (the app opens its home page).
  Future<void> createOrganization({
    required String name,
    required String timezone,
    bool paidLeave = true,
  }) async {
    final user = await ref
        .read(authRepositoryProvider)
        .createOrganization(
          name: name,
          timezone: timezone,
          paidLeave: paidLeave,
        );
    if (!ref.mounted) return;
    state = AsyncData(user);
  }

  /// Joins an organization by invitation and works in it.
  Future<void> acceptInvitation(String id) async {
    final user = await ref.read(authRepositoryProvider).acceptInvitation(id);
    if (!ref.mounted) return;
    state = AsyncData(user);
  }

  /// True after the user signed out themselves (not an expired session).
  /// Then the next person to sign in starts on their own home page instead
  /// of returning to the page the previous user was on.
  bool signedOutByUser = false;

  Future<void> signOut() async {
    signedOutByUser = true;
    await ref.read(authRepositoryProvider).signOut();
    if (!ref.mounted) return;
    state = const AsyncData(null);
  }

  Future<void>? _refreshing;

  /// Reloads the signed-in user, so permission changes made by an admin
  /// (or by the user on their own role) take effect without signing out.
  /// Called after a 403, when the app returns to the foreground, and after
  /// access changes. Offline or server errors keep the current user.
  Future<void> refresh() =>
      _refreshing ??= _refresh().whenComplete(() => _refreshing = null);

  Future<void> _refresh() async {
    if (state.value == null) return;
    try {
      final user = await ref.read(authRepositoryProvider).restoreSession();
      if (!ref.mounted || state.value == null) return;
      if (user == null) {
        ref.read(sessionExpiredNoticeProvider.notifier).show();
        state = const AsyncData(null);
      } else if (user != state.value) {
        state = AsyncData(user);
      }
    } on AppException {
      // Keep the current user; the next refresh tries again.
    }
  }

  Future<void> _onSessionExpired(String? reason) async {
    if (state.value == null) return;
    await ref.read(authRepositoryProvider).clearSession();
    if (!ref.mounted) return;
    ref.read(sessionExpiredNoticeProvider.notifier).show(reason);
    state = const AsyncData(null);
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, UserModel?>(
      AuthController.new,
      // A failed session check is shown with a manual retry, not retried
      // automatically.
      retry: (_, _) => null,
    );

/// Set after the server ended the session, so the login screen can explain
/// why the user is back there: the server's reason (e.g. a deactivated
/// role) or a general "session expired". Null when there is nothing to say.
class SessionExpiredNotice extends Notifier<String?> {
  static const String defaultMessage =
      'Your session has expired. Please sign in again.';

  @override
  String? build() => null;

  void show([String? reason]) => state = reason ?? defaultMessage;

  void dismiss() => state = null;
}

final sessionExpiredNoticeProvider =
    NotifierProvider<SessionExpiredNotice, String?>(SessionExpiredNotice.new);
