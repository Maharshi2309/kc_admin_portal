import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/features/auth/presentation/providers/auth_controller.dart';

/// Submission state of the login form: idle (data), submitting (loading) or
/// failed (error). Kept separate from [authControllerProvider] so a sign-in
/// attempt never puts the whole app into a loading state.
class LoginController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> submit({
    required String email,
    required String password,
    bool keepSignedIn = true,
  }) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref
          .read(authControllerProvider.notifier)
          .signIn(email: email, password: password, keepSignedIn: keepSignedIn),
    );
    if (ref.mounted) state = result;
  }
}

final loginControllerProvider =
    AsyncNotifierProvider.autoDispose<LoginController, void>(
      LoginController.new,
      retry: (_, _) => null,
    );
