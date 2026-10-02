import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/app/theme/app_theme.dart';
import 'package:kc_admin_portal/core/constants/app_constants.dart';

/// Shown instead of the app when it cannot start (e.g. missing build
/// configuration), so the failure is visible rather than a blank screen.
class StartupErrorApp extends StatelessWidget {
  const StartupErrorApp({required this.message, super.key});

  /// Developer-facing explanation of what is wrong and how to fix it.
  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSizes.dialogMaxWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.s12,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.dangerFg,
                      size: AppSizes.iconFeature,
                    ),
                    Text(
                      'The app could not start',
                      style: AppTextStyles.headingMedium,
                    ),
                    SelectableText(
                      message,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
