import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/responsive/responsive_utils.dart';
import 'package:kc_admin_portal/features/auth/presentation/widgets/login_form.dart';
import 'package:kc_admin_portal/shared/widgets/brand_mark.dart';

/// Sign-in page. Desktop: dark brand panel on the left, form on the right
/// (as in the design). Tablet and phone: the form alone with the logo above.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => const AuthLayout(child: LoginForm());
}

/// The layout of the sign-in page, shared by every account page (sign-up,
/// email verification, password reset, welcome, new organization).
class AuthLayout extends StatelessWidget {
  const AuthLayout({required this.child, super.key});

  final Widget child;

  static const double _formMaxWidth = 400;
  static const double _brandPanelWidth = 600;

  @override
  Widget build(BuildContext context) {
    final form = Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(pagePaddingValue.resolve(context.screenSize)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _formMaxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!context.isDesktop) ...[
                const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: BrandMark(),
                ),
                const SizedBox(height: AppSpacing.s32),
              ],
              child,
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      body: context.isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(width: _brandPanelWidth, child: _BrandPanel()),
                Expanded(child: SafeArea(child: form)),
              ],
            )
          : SafeArea(child: form),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  static const double _copyMaxWidth = 440;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.inverse,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.hardEdge,
        children: [
          // A large, faint KC mark behind the copy.
          Positioned(
            right: -_watermarkHeight * 0.12,
            bottom: -_watermarkHeight * 0.08,
            child: IgnorePointer(
              child: KcLogo(
                height: _watermarkHeight,
                color: AppColors.onInverse.withValues(alpha: 0.06),
              ),
            ),
          ),
          _copy(),
        ],
      ),
    );
  }

  static const double _watermarkHeight = 460;

  Widget _copy() {
    return SafeArea(
      // Fills the height, but scrolls when large text makes it too tall.
      child: LayoutBuilder(
        builder: (context, constraints) {
          final copyWidth = constraints.maxWidth - 2 * AppSpacing.s56;
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.s56),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BrandMark(inverted: true),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: AppSpacing.s20,
                        children: [
                          Text(
                            'Attendance and leave, managed in one place.',
                            style: AppTextStyles.display.copyWith(
                              color: AppColors.onInverse,
                            ),
                          ),
                          // Padding (not a max-width box) caps the line
                          // length, because IntrinsicHeight measures
                          // through padding correctly.
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                              end: math.max(0, copyWidth - _copyMaxWidth),
                            ),
                            child: Text(
                              'Employees, EC numbers, daily punches and leave balances '
                              'for your whole team.',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.onInverseMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'For authorised administrators only',
                        style: AppTextStyles.small.copyWith(
                          color: AppColors.onInverseSubtle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
