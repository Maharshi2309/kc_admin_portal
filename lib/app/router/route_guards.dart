import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/features/auth/data/models/user_model.dart';

enum AuthStatus {
  /// Still restoring the stored session, or it could not be checked.
  unknown,
  signedIn,
  signedOut,
}

/// Loading without a previous value, or an error (the session could not be
/// checked), is [AuthStatus.unknown]; the splash screen shows progress or a
/// retry for those.
AuthStatus authStatusOf(AsyncValue<UserModel?> auth) {
  if (auth.hasError || !auth.hasValue) return AuthStatus.unknown;
  return auth.value == null ? AuthStatus.signedOut : AuthStatus.signedIn;
}

/// Paths reachable without signing in.
const Set<String> _publicPaths = {
  AppRoutePaths.login,
  AppRoutePaths.splash,
  AppRoutePaths.devComponents,
  ..._accountPaths,
};

/// Signing up and recovering a password: signed-in users don't need them.
const Set<String> _accountPaths = {
  AppRoutePaths.register,
  AppRoutePaths.verifyEmail,
  AppRoutePaths.forgotPassword,
  AppRoutePaths.resetPassword,
};

/// Where to send the user for [location], or `null` to stay.
///
/// - While the session is being checked, everything waits on the splash
///   screen.
/// - Signed-out users go to login; the page they asked for is kept in
///   `?from=` and opened after signing in — unless [keepReturnPath] is
///   false (someone signed out on purpose; the next person may be someone
///   else).
/// - Signed-in users never see login or splash.
///
/// [homeLocation] is where a signed-in user lands when nothing else was
/// asked for: the first page their role may open.
String? authRedirect({
  required AuthStatus status,
  required Uri location,
  String homeLocation = AppRoutePaths.dashboard,
  bool keepReturnPath = true,
}) {
  final path = location.path;
  final from = keepReturnPath ? _returnPathFor(location) : null;

  switch (status) {
    case AuthStatus.unknown:
      if (path == AppRoutePaths.splash) return null;
      return _withFrom(AppRoutePaths.splash, from);
    case AuthStatus.signedOut:
      if (_publicPaths.contains(path) && path != AppRoutePaths.splash) {
        return null;
      }
      return _withFrom(AppRoutePaths.login, from);
    case AuthStatus.signedIn:
      if (path == AppRoutePaths.login || path == AppRoutePaths.splash) {
        return from ?? homeLocation;
      }
      if (_accountPaths.contains(path)) return homeLocation;
      return null;
  }
}

/// The page to return to after signing in: the `from` parameter on login
/// and splash, otherwise the current location. Only in-app paths are
/// accepted, so `from` cannot redirect to another site.
String? _returnPathFor(Uri location) {
  final isAuthPage =
      location.path == AppRoutePaths.login ||
      location.path == AppRoutePaths.splash;
  final candidate = isAuthPage
      ? location.queryParameters[AppRouteParams.from]
      : location.toString();

  if (candidate == null ||
      !candidate.startsWith('/') ||
      candidate.startsWith('//')) {
    return null;
  }
  final candidatePath = Uri.tryParse(candidate)?.path;
  if (candidatePath == null ||
      candidatePath == AppRoutePaths.root ||
      candidatePath == AppRoutePaths.login ||
      candidatePath == AppRoutePaths.splash) {
    return null;
  }
  return candidate;
}

String _withFrom(String path, String? from) => from == null
    ? path
    : Uri(path: path, queryParameters: {AppRouteParams.from: from}).toString();

/// For signed-in users: someone in no organization yet sees only the
/// welcome page and the "create organization" page; the welcome page is
/// only for them. Returns where to go, or null to stay.
String? organizationRedirect({
  required bool needsOrganization,
  required String path,
  required String homeLocation,
}) {
  if (needsOrganization) {
    return path == AppRoutePaths.welcome ||
            path == AppRoutePaths.createOrganization
        ? null
        : AppRoutePaths.welcome;
  }
  return path == AppRoutePaths.welcome ? homeLocation : null;
}
