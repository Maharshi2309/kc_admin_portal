import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/widgets/app_icon_button.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';

/// An employee's EC number in the monospace font, optionally with a copy button.
class EcNumberText extends StatelessWidget {
  const EcNumberText(
    this.ecNumber, {
    this.large = false,
    this.copyable = false,
    super.key,
  });

  final String ecNumber;

  /// 14 px dark variant (profile header, forms) instead of 13 px grey.
  final bool large;
  final bool copyable;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      ecNumber,
      style: large ? AppTextStyles.monoLarge : AppTextStyles.mono,
    );
    if (!copyable) return text;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        text,
        const SizedBox(width: AppSpacing.s4),
        AppIconButton(
          icon: Icons.copy_rounded,
          tooltip: 'Copy EC number',
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: ecNumber));
            if (context.mounted) {
              showAppSnackBar(context, 'EC number copied');
            }
          },
        ),
      ],
    );
  }
}
