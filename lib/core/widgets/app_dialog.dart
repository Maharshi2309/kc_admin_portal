import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/responsive/responsive_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_overlay_panel.dart';

/// Dialog from the design (e.g. "Correct attendance"): centered card on
/// tablet and wider, full screen on phones so forms get the whole display.
class AppDialog extends StatelessWidget {
  const AppDialog({
    required this.title,
    required this.body,
    this.subtitle,
    this.actions = const [],
    this.footerNote,
    this.maxWidth = AppSizes.dialogMaxWidth,
    this.fullscreenOnMobile = true,
    this.onClose,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final List<Widget> actions;
  final String? footerNote;
  final double maxWidth;

  /// Short dialogs (confirmations) stay centered on phones too.
  final bool fullscreenOnMobile;

  /// Defaults to closing the dialog.
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final fullscreen = fullscreenOnMobile && context.isMobile;
    final panel = AppOverlayPanel(
      title: title,
      subtitle: subtitle,
      body: body,
      actions: actions,
      footerNote: footerNote,
      expandBody: fullscreen,
      onClose: onClose ?? () => Navigator.of(context).maybePop(),
    );

    if (fullscreen) {
      return Dialog.fullscreen(
        backgroundColor: AppColors.surface,
        child: SafeArea(bottom: false, child: panel),
      );
    }
    return Dialog(
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: panel,
      ),
    );
  }
}

/// Asks the user to confirm an action. Resolves to `true` only when the
/// confirm button is pressed.
Future<bool> showAppConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  String cancelLabel = 'Cancel',
  bool isDestructive = false,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AppDialog(
      title: title,
      maxWidth: AppSizes.confirmDialogMaxWidth,
      fullscreenOnMobile: false,
      body: Text(
        message,
        style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
      ),
      actions: [
        AppButton(
          label: cancelLabel,
          variant: AppButtonVariant.secondary,
          onPressed: () => Navigator.of(dialogContext).pop(false),
        ),
        AppButton(
          label: confirmLabel,
          variant: isDestructive
              ? AppButtonVariant.danger
              : AppButtonVariant.primary,
          onPressed: () => Navigator.of(dialogContext).pop(true),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
