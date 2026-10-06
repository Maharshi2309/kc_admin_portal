import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/core/constants/app_constants.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';
import 'package:kc_admin_portal/features/auth/presentation/screens/login_screen.dart';
import 'package:kc_admin_portal/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:kc_admin_portal/features/onboarding/presentation/widgets/account_page_parts.dart';

/// "Check your email": the 6-digit code emailed after sign-up (or when
/// signing in to an unverified account). A correct code signs the person
/// in; the app then shows the welcome page.
class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({required this.email, super.key});

  /// The address the code went to; null for an old or edited link.
  final String? email;

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();

  /// Seconds until another code may be sent.
  int _resendIn = 0;
  Timer? _resendTimer;

  static const int _resendWaitSeconds = 30;

  @override
  void dispose() {
    _code.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  Future<void> _verify(String email) async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    // On success the app moves on by itself (signed in now).
    await ref
        .read(verifyEmailControllerProvider.notifier)
        .verify(email: email, code: _code.text);
  }

  Future<void> _resend(String email) async {
    final messenger = ScaffoldMessenger.of(context);
    final sent = await ref
        .read(verifyEmailControllerProvider.notifier)
        .resend(email);
    if (!sent || !mounted) return;
    showAppSnackBarOn(messenger, 'A new code is on its way to $email');
    setState(() => _resendIn = _resendWaitSeconds);
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return timer.cancel();
      setState(() => _resendIn--);
      if (_resendIn <= 0) timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.email?.trim();
    if (email == null || email.isEmpty) {
      return AuthLayout(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.s20,
          children: [
            const AccountPageHeader(
              title: 'Verify your email',
              subtitle:
                  'This link is missing the email address. Sign in, or '
                  'create your account again.',
            ),
            AppButton(
              label: 'Go to sign in',
              size: AppButtonSize.large,
              expand: true,
              onPressed: () => context.goNamed(AppRouteNames.login),
            ),
          ],
        ),
      );
    }

    final submission = ref.watch(verifyEmailControllerProvider);
    final sending = submission.isLoading;
    final error = sending ? null : submission.error;

    return AuthLayout(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.s20,
          children: [
            AccountPageHeader(
              title: 'Check your email',
              subtitle:
                  'We sent a ${AppConstants.emailCodeLength}-digit code to '
                  '$email. Enter it to verify your address.',
            ),
            const MockCodeHint(),
            SubmissionError(error: error),
            AppTextField(
              label: 'Code',
              controller: _code,
              large: true,
              monospace: true,
              autofocus: true,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.oneTimeCode],
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(AppConstants.emailCodeLength),
              ],
              enabled: !sending,
              errorText: fieldErrorOf(error, 'code'),
              validator: codeValidator,
              onFieldSubmitted: (_) => _verify(email),
            ),
            AppButton(
              label: 'Verify email',
              size: AppButtonSize.large,
              expand: true,
              isLoading: sending,
              onPressed: () => _verify(email),
            ),
            AccountLinkLine(
              text: "Didn't get it?",
              linkLabel: _resendIn > 0
                  ? 'Send a new code (${_resendIn}s)'
                  : 'Send a new code',
              onPressed: sending || _resendIn > 0 ? null : () => _resend(email),
            ),
            AccountLinkLine(
              text: 'Wrong address?',
              linkLabel: 'Start again',
              onPressed: sending
                  ? null
                  : () => context.goNamed(AppRouteNames.register),
            ),
          ],
        ),
      ),
    );
  }
}

/// An emailed code: exactly [AppConstants.emailCodeLength] digits.
String? codeValidator(String? value) {
  final code = value?.trim() ?? '';
  if (code.isEmpty) return 'Enter the code from the email';
  return code.length == AppConstants.emailCodeLength
      ? null
      : 'The code has ${AppConstants.emailCodeLength} digits';
}
