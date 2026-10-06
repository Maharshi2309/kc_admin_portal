import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/auth_controller.dart';
import 'package:kc_admin_portal/shared/models/organization_model.dart';

/// Submission state of one account form: idle (data), sending (loading) or
/// failed (error, shown by the form). Each form has its own controller.
abstract class _Submission extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Runs [action]; true when it succeeded.
  Future<bool> run(Future<void> Function() action) async {
    if (state.isLoading) return false;
    state = const AsyncLoading();
    final result = await AsyncValue.guard(action);
    if (ref.mounted) state = result;
    return !result.hasError;
  }
}

/// "Create an account".
class RegisterController extends _Submission {
  Future<bool> submit({
    required String name,
    required String email,
    required String password,
  }) => run(
    () => ref
        .read(authRepositoryProvider)
        .register(name: name, email: email, password: password),
  );
}

final registerControllerProvider =
    AsyncNotifierProvider.autoDispose<RegisterController, void>(
      RegisterController.new,
      retry: (_, _) => null,
    );

/// "Check your email": the code, and sending a new one.
class VerifyEmailController extends _Submission {
  Future<bool> verify({required String email, required String code}) => run(
    () => ref
        .read(authControllerProvider.notifier)
        .verifyEmail(email: email, code: code),
  );

  Future<bool> resend(String email) =>
      run(() => ref.read(authRepositoryProvider).resendVerification(email));
}

final verifyEmailControllerProvider =
    AsyncNotifierProvider.autoDispose<VerifyEmailController, void>(
      VerifyEmailController.new,
      retry: (_, _) => null,
    );

/// "Forgot password?" and "Choose a new password".
class PasswordResetController extends _Submission {
  Future<bool> requestCode(String email) =>
      run(() => ref.read(authRepositoryProvider).forgotPassword(email));

  Future<bool> reset({
    required String email,
    required String code,
    required String password,
  }) => run(
    () => ref
        .read(authRepositoryProvider)
        .resetPassword(email: email, code: code, password: password),
  );
}

final passwordResetControllerProvider =
    AsyncNotifierProvider.autoDispose<PasswordResetController, void>(
      PasswordResetController.new,
      retry: (_, _) => null,
    );

/// "Create your organization".
class CreateOrganizationController extends _Submission {
  Future<bool> submit({
    required String name,
    required String timezone,
    required bool paidLeave,
  }) => run(
    () => ref
        .read(authControllerProvider.notifier)
        .createOrganization(
          name: name,
          timezone: timezone,
          paidLeave: paidLeave,
        ),
  );
}

final createOrganizationControllerProvider =
    AsyncNotifierProvider.autoDispose<CreateOrganizationController, void>(
      CreateOrganizationController.new,
      retry: (_, _) => null,
    );

/// Invitations waiting for the signed-in person.
final invitationsProvider = FutureProvider.autoDispose<List<InvitationModel>>(
  (ref) => ref.watch(authRepositoryProvider).invitations(),
  retry: (_, _) => null,
);

/// Joining or declining an invitation: the ids being sent.
class InvitationActions extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {};

  /// Joins the organization (the app then opens it). Returns the error, or
  /// null on success.
  Future<Object?> accept(String id) => _run(
    id,
    () => ref.read(authControllerProvider.notifier).acceptInvitation(id),
  );

  Future<Object?> decline(String id) => _run(id, () async {
    await ref.read(authRepositoryProvider).declineInvitation(id);
    ref.invalidate(invitationsProvider);
  });

  Future<Object?> _run(String id, Future<void> Function() action) async {
    if (state.contains(id)) return null;
    state = {...state, id};
    try {
      await action();
      return null;
    } on Object catch (error) {
      return error;
    } finally {
      if (ref.mounted) state = {...state}..remove(id);
    }
  }
}

final invitationActionsProvider =
    NotifierProvider.autoDispose<InvitationActions, Set<String>>(
      InvitationActions.new,
    );
