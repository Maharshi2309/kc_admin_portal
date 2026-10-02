import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/utils/validation_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_alert_banner.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';
import 'package:kc_admin_portal/features/auth/data/datasources/auth_mock_data_source.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/auth_controller.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/login_controller.dart';

/// Email + password sign-in form from the design.
///
/// "Keep me signed in on this device" (checked by default, as in the design)
/// saves the session for the next start; unchecked, it ends when the app
/// closes.
///
/// TODO — REQUIREMENT CONFIRMATION REQUIRED: the design also shows
/// "Forgot password?", which needs a backend reset flow, so it is omitted.
class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _passwordFocus = FocusNode();
  bool _keepSignedIn = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    ref
        .read(loginControllerProvider.notifier)
        .submit(
          email: _email.text.trim(),
          password: _password.text,
          keepSignedIn: _keepSignedIn,
        );
  }

  @override
  Widget build(BuildContext context) {
    final submission = ref.watch(loginControllerProvider);
    final sessionNotice = ref.watch(sessionExpiredNoticeProvider);
    final isSubmitting = submission.isLoading;
    final usesMockApi = ref.watch(envProvider).useMockApi;

    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text('Sign in', style: AppTextStyles.headingLarge),
            ),
            const SizedBox(height: AppSpacing.s6),
            Text(
              'Use your admin email and password',
              style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: AppSpacing.s24),
            // Dev builds only: makes it obvious which API the app talks to.
            if (usesMockApi) ...[
              const AppAlertBanner(
                tone: AlertTone.info,
                title: 'Development mock API',
                message:
                    'No server is used. Sign in as a sample user, e.g. '
                    'admin@keshav.in (full access), nisha.solanki@keshav.in '
                    'or arjun.joshi@keshav.in (limited access), with the '
                    'password "${AuthMockDataSource.password}".',
              ),
              const SizedBox(height: AppSpacing.s20),
            ],
            if (submission.hasError && !isSubmitting) ...[
              AppAlertBanner(
                message: ErrorHandler.messageFor(submission.error!),
              ),
              const SizedBox(height: AppSpacing.s20),
            ] else if (sessionNotice != null) ...[
              AppAlertBanner(tone: AlertTone.info, message: sessionNotice),
              const SizedBox(height: AppSpacing.s20),
            ],
            AppTextField(
              label: 'Email address',
              controller: _email,
              large: true,
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [
                AutofillHints.username,
                AutofillHints.email,
              ],
              enabled: !isSubmitting,
              validator: Validators.email,
              onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
            ),
            const SizedBox(height: AppSpacing.s20),
            AppTextField(
              label: 'Password',
              controller: _password,
              focusNode: _passwordFocus,
              large: true,
              isPassword: true,
              prefixIcon: Icons.lock_outline_rounded,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              enabled: !isSubmitting,
              validator: (value) =>
                  Validators.required(value, field: 'Password'),
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppSpacing.s12),
            _KeepSignedInCheckbox(
              value: _keepSignedIn,
              onChanged: isSubmitting
                  ? null
                  : (value) => setState(() => _keepSignedIn = value),
            ),
            const SizedBox(height: AppSpacing.s20),
            AppButton(
              label: 'Sign in',
              size: AppButtonSize.large,
              expand: true,
              isLoading: isSubmitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _KeepSignedInCheckbox extends StatelessWidget {
  const _KeepSignedInCheckbox({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;
    return MergeSemantics(
      child: InkWell(
        onTap: enabled ? () => onChanged!(!value) : null,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
          child: Row(
            children: [
              Checkbox(
                value: value,
                onChanged: enabled ? (checked) => onChanged!(checked!) : null,
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const SizedBox(width: AppSpacing.s8),
              Flexible(
                child: Text(
                  'Keep me signed in on this device',
                  style: AppTextStyles.body.copyWith(
                    color: enabled
                        ? AppColors.textSecondary
                        : AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
