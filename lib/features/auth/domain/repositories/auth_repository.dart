import 'package:kc_admin_portal/core/utils/phone_utils.dart';
import 'package:kc_admin_portal/features/auth/data/models/user_model.dart';
import 'package:kc_admin_portal/shared/models/organization_model.dart';

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

  /// Works in another of the user's organizations; returns the user with
  /// their permissions there. Throws an `AppException` on failure.
  Future<UserModel> switchOrganization(String organizationId);

  /// Ends the session locally, and on the server when reachable.
  Future<void> signOut();

  /// Forgets the local session without calling the server (used when the
  /// server has already rejected it).
  Future<void> clearSession();

  // Accounts and organizations (2026-10-06)

  /// A new, unverified account; a code is emailed to verify it.
  Future<void> register({
    required String name,
    required String email,
    required String password,
  });

  /// Verifies the email with its code and starts the session, like
  /// [signIn].
  Future<UserModel> verifyEmail({
    required String email,
    required String code,
    bool keepSignedIn = true,
  });

  Future<void> resendVerification(String email);

  Future<void> forgotPassword(String email);

  Future<void> resetPassword({
    required String email,
    required String code,
    required String password,
  });

  /// Creates an organization (the user becomes its owner) and works in it.
  Future<UserModel> createOrganization({
    required String name,
    required String timezone,
    bool paidLeave = true,
    String defaultCountry = PhoneUtils.defaultCountry,
  });

  /// Invitations waiting for the signed-in person.
  Future<List<InvitationModel>> invitations();

  /// Joins the organization and works in it.
  Future<UserModel> acceptInvitation(String id);

  Future<void> declineInvitation(String id);
}
