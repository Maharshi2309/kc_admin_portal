import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/core/constants/app_constants.dart';
import 'package:kc_admin_portal/core/utils/validation_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';
import 'package:kc_admin_portal/features/auth/presentation/screens/login_screen.dart';
import 'package:kc_admin_portal/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:kc_admin_portal/features/onboarding/presentation/screens/register_screen.dart';
import 'package:kc_admin_portal/features/onboarding/presentation/screens/verify_email_screen.dart';
import 'package:kc_admin_portal/features/onboarding/presentation/widgets/account_page_parts.dart';

/// "Forgot password?": emails a code to reset it. The answer is the same
/// whether or not the address has an account, so nobody can find out.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({this.email, super.key});

  /// Pre-filled from the sign-in page.
  final String? email;

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _email = TextEditingController(text: widget.email);

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final email = _email.text.trim();
    final sent = await ref
        .read(passwordResetControllerProvider.notifier)
        .requestCode(email);
    if (!sent || !mounted) return;
    context.goNamed(
      AppRouteNames.resetPassword,
      queryParameters: {AppRouteParams.email: email},
    );
  }

  @override
  Widget build(BuildContext context) {
    final submission = ref.watch(passwordResetControllerProvider);
    final sending = submission.isLoading;
    final error = sending ? null : submission.error;

    return AuthLayout(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.s20,
          children: [
            const AccountPageHeader(
              title: 'Forgot your password?',
              subtitle:
                  "Enter your email address and we'll send you a code to "
                  'choose a new password.',
            ),
            SubmissionError(error: error),
            AppTextField(
              label: 'Email address',
              controller: _email,
              large: true,
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.email],
              enabled: !sending,
              validator: Validators.email,
              onFieldSubmitted: (_) => _submit(),
            ),
            AppButton(
              label: 'Send code',
              size: AppButtonSize.large,
              expand: true,
              isLoading: sending,
              onPressed: _submit,
            ),
            AccountLinkLine(
              text: 'Remembered it?',
              linkLabel: 'Sign in',
              onPressed: sending
                  ? null
                  : () => context.goNamed(AppRouteNames.login),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Choose a new password" with the emailed code.
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({required this.email, super.key});

  final String? email;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit(String email) async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final messenger = ScaffoldMessenger.of(context);
    final changed = await ref
        .read(passwordResetControllerProvider.notifier)
        .reset(email: email, code: _code.text, password: _password.text);
    if (!changed || !mounted) return;
    showAppSnackBarOn(
      messenger,
      'Password changed. Sign in with your new password.',
      tone: SnackBarTone.success,
    );
    context.goNamed(AppRouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.email?.trim();
    if (email == null || email.isEmpty) {
      return ForgotPasswordScreen(email: email);
    }
    final submission = ref.watch(passwordResetControllerProvider);
    final sending = submission.isLoading;
    final error = sending ? null : submission.error;

    return AuthLayout(
      child: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.s20,
            children: [
              AccountPageHeader(
                title: 'Choose a new password',
                subtitle:
                    'If $email has an account, we sent it a '
                    '${AppConstants.emailCodeLength}-digit code.',
              ),
              const MockCodeHint(),
              SubmissionError(error: error),
              AppTextField(
                label: 'Code',
                controller: _code,
                large: true,
                monospace: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(
                    AppConstants.emailCodeLength,
                  ),
                ],
                enabled: !sending,
                errorText: fieldErrorOf(error, 'code'),
                validator: codeValidator,
              ),
              AppTextField(
                label: 'New password',
                controller: _password,
                large: true,
                isPassword: true,
                prefixIcon: Icons.lock_outline_rounded,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.newPassword],
                helperText:
                    'At least ${AppConstants.passwordMinLength} characters',
                enabled: !sending,
                errorText: fieldErrorOf(error, 'password'),
                validator: passwordValidator,
                onFieldSubmitted: (_) => _submit(email),
              ),
              AppButton(
                label: 'Change password',
                size: AppButtonSize.large,
                expand: true,
                isLoading: sending,
                onPressed: () => _submit(email),
              ),
              AccountLinkLine(
                text: "Didn't get a code?",
                linkLabel: 'Send another',
                onPressed: sending
                    ? null
                    : () => context.goNamed(
                        AppRouteNames.forgotPassword,
                        queryParameters: {AppRouteParams.email: email},
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
