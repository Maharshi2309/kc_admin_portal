import 'package:kc_admin_portal/features/auth/data/models/user_model.dart';

/// Sign-in, session restore and sign-out. Hides the API and token storage
/// from the presentation layer.
abstract interface class AuthRepository {
  /// Signs in and starts the session. With [keepSignedIn] the session is
  /// also restored on the next start. Throws an `AppException` on failure.
  Future<UserModel> signIn({
    required String email,
    required String password,
    bool keepSignedIn = true,
  });

  /// The signed-in user from a stored session, or `null` if there is none
  /// or it is no longer valid.
  Future<UserModel?> restoreSession();

  /// Ends the session locally, and on the server when reachable.
  Future<void> signOut();

  /// Forgets the local session without calling the server (used when the
  /// server has already rejected it).
  Future<void> clearSession();
}
