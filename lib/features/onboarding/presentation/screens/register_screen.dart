import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/core/constants/app_constants.dart';
import 'package:kc_admin_portal/core/utils/validation_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';
import 'package:kc_admin_portal/features/auth/presentation/screens/login_screen.dart';
import 'package:kc_admin_portal/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:kc_admin_portal/features/onboarding/presentation/widgets/account_page_parts.dart';

/// "Create an account": anyone may sign up free (2026-10-06). A code is
/// then emailed to verify the address; after that the person creates their
/// organization or joins one they were invited to.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final email = _email.text.trim();
    final created = await ref
        .read(registerControllerProvider.notifier)
        .submit(name: _name.text, email: email, password: _password.text);
    if (!created || !mounted) return;
    context.goNamed(
      AppRouteNames.verifyEmail,
      queryParameters: {AppRouteParams.email: email},
    );
  }

  @override
  Widget build(BuildContext context) {
    final submission = ref.watch(registerControllerProvider);
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
              const AccountPageHeader(
                title: 'Create an account',
                subtitle:
                    'Free for any organization. Set up yours, or join one '
                    "you've been invited to.",
              ),
              SubmissionError(error: error),
              AppTextField(
                label: 'Your name',
                controller: _name,
                large: true,
                prefixIcon: Icons.person_outline_rounded,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                enabled: !sending,
                errorText: fieldErrorOf(error, 'name'),
                validator: (value) =>
                    Validators.required(value, field: 'Your name'),
              ),
              AppTextField(
                label: 'Email address',
                controller: _email,
                large: true,
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                enabled: !sending,
                errorText: fieldErrorOf(error, 'email'),
                validator: Validators.email,
              ),
              AppTextField(
                label: 'Password',
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
                onFieldSubmitted: (_) => _submit(),
              ),
              AppButton(
                label: 'Create account',
                size: AppButtonSize.large,
                expand: true,
                isLoading: sending,
                onPressed: _submit,
              ),
              AccountLinkLine(
                text: 'Already have an account?',
                linkLabel: 'Sign in',
                onPressed: sending
                    ? null
                    : () => context.goNamed(AppRouteNames.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A new password: required and long enough (the server checks too).
String? passwordValidator(String? value) {
  final missing = Validators.required(value, field: 'Password');
  if (missing != null) return missing;
  return value!.length < AppConstants.passwordMinLength
      ? 'Use at least ${AppConstants.passwordMinLength} characters'
      : null;
}
