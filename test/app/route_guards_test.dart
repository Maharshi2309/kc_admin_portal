import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kc_admin_portal/app/router/route_guards.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/features/auth/data/models/user_model.dart';

import '../helpers/fake_auth.dart';

String? redirect(AuthStatus status, String location) =>
    authRedirect(status: status, location: Uri.parse(location));

void main() {
  group('authStatusOf', () {
    test('maps auth state to a status', () {
      expect(
        authStatusOf(const AsyncLoading<UserModel?>()),
        AuthStatus.unknown,
      );
      expect(
        authStatusOf(
          const AsyncError<UserModel?>(NetworkException(), StackTrace.empty),
        ),
        AuthStatus.unknown,
      );
      expect(authStatusOf(const AsyncData(null)), AuthStatus.signedOut);
      expect(authStatusOf(AsyncData(testUser)), AuthStatus.signedIn);
    });
  });

  group('while the session is being checked', () {
    test('waits on the splash screen and remembers the target', () {
      expect(
        redirect(AuthStatus.unknown, '/employees/42'),
        '/splash?from=%2Femployees%2F42',
      );
      expect(redirect(AuthStatus.unknown, '/splash'), isNull);
    });
  });

  group('signed out', () {
    test('protected pages go to login with a return path', () {
      expect(
        redirect(AuthStatus.signedOut, '/dashboard'),
        '/login?from=%2Fdashboard',
      );
      expect(
        redirect(AuthStatus.signedOut, '/employees?search=EC-1'),
        '/login?from=%2Femployees%3Fsearch%3DEC-1',
      );
    });

    test('after signing out on purpose, no return path', () {
      expect(
        authRedirect(
          status: AuthStatus.signedOut,
          location: Uri.parse('/access-control/u4'),
          keepReturnPath: false,
        ),
        '/login',
      );
    });

    test('login stays put; splash hands its target to login', () {
      expect(redirect(AuthStatus.signedOut, '/login'), isNull);
      expect(
        redirect(AuthStatus.signedOut, '/splash?from=/leave'),
        '/login?from=%2Fleave',
      );
    });

    test('root path does not become a return path', () {
      expect(redirect(AuthStatus.signedOut, '/'), '/login');
    });
  });

  group('signed in', () {
    test('protected pages are allowed', () {
      expect(redirect(AuthStatus.signedIn, '/employees/42'), isNull);
    });

    test('login and splash go to the return path or dashboard', () {
      expect(redirect(AuthStatus.signedIn, '/login'), '/dashboard');
      expect(
        redirect(AuthStatus.signedIn, '/login?from=/employees/42'),
        '/employees/42',
      );
      expect(redirect(AuthStatus.signedIn, '/splash?from=/leave'), '/leave');
    });

    test('ignores return paths that leave the app', () {
      expect(
        redirect(AuthStatus.signedIn, '/login?from=https://evil.example'),
        '/dashboard',
      );
      expect(
        redirect(AuthStatus.signedIn, '/login?from=//evil.example'),
        '/dashboard',
      );
    });
  });
}
