import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/widgets/app_alert_banner.dart';
import 'package:kc_admin_portal/core/widgets/app_link.dart';
import 'package:kc_admin_portal/shared/mock/mock_directory.dart';

/// "Create an account" style heading of an account page, as on sign-in.
class AccountPageHeader extends StatelessWidget {
  const AccountPageHeader({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s6,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: AppTextStyles.headingLarge),
        ),
        Text(
          subtitle,
          style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}

/// Dev builds only: no email is sent by the mock API, so the code is shown.
class MockCodeHint extends ConsumerWidget {
  const MockCodeHint({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(envProvider).useMockApi) return const SizedBox.shrink();
    return const AppAlertBanner(
      tone: AlertTone.info,
      title: 'Development mock API',
      message:
          'No email is sent. The code is '
          '${MockDirectory.verificationCode}.',
    );
  }
}

/// "Already have an account? Sign in".
class AccountLinkLine extends StatelessWidget {
  const AccountLinkLine({
    required this.text,
    required this.linkLabel,
    required this.onPressed,
    super.key,
  });

  final String text;
  final String linkLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.s4,
      children: [
        Text(
          text,
          style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
        ),
        AppLink(label: linkLabel, showChevron: false, onPressed: onPressed),
      ],
    );
  }
}

/// The form-wide message of a failed submission, or nothing. Field errors
/// from the server show on their fields instead, so only the rest is here.
class SubmissionError extends StatelessWidget {
  const SubmissionError({required this.error, super.key});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    final error = this.error;
    if (error == null ||
        (error is ValidationException && error.fieldErrors.isNotEmpty)) {
      return const SizedBox.shrink();
    }
    return AppAlertBanner(message: ErrorHandler.messageFor(error));
  }
}

/// The server's message for [field], if the submission failed on it.
String? fieldErrorOf(Object? error, String field) =>
    error is ValidationException ? error.fieldErrors[field] : null;
