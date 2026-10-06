import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/responsive/layout_mode.dart';
import 'package:kc_admin_portal/core/widgets/app_segmented_control.dart';

/// "Layout: Auto · Mobile · Desktop" (2026-10-06). Remembered on this
/// device. Desktop needs a screen at least a small tablet wide; on a phone
/// it says so and keeps the phone layout.
class LayoutModeSwitch extends ConsumerWidget {
  const LayoutModeSwitch({super.key});

  static const double _width = 260;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(layoutModeProvider);
    // The real screen, not the phone column of mobile mode.
    final screenWidth =
        View.of(context).physicalSize.width / View.of(context).devicePixelRatio;
    final tooNarrow =
        mode == LayoutMode.desktop && !LayoutMode.desktopFits(screenWidth);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s4,
      children: [
        SizedBox(
          width: _width,
          child: AppSegmentedControl<LayoutMode>(
            semanticLabel: 'Layout',
            compact: true,
            selected: mode,
            onChanged: (value) =>
                ref.read(layoutModeProvider.notifier).choose(value),
            segments: [
              for (final value in LayoutMode.values)
                AppSegment(value: value, label: value.label),
            ],
          ),
        ),
        if (tooNarrow)
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _width),
            child: Text(
              'The desktop layout needs a wider screen. Turn the device '
              'or widen the window.',
              textAlign: TextAlign.end,
              style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
            ),
          ),
      ],
    );
  }
}

/// The three choices as menu items, for the account menu.
List<Widget> layoutModeMenuItems(WidgetRef ref) {
  final mode = ref.watch(layoutModeProvider);
  return [
    Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s12,
        AppSpacing.s8,
        AppSpacing.s12,
        AppSpacing.s2,
      ),
      child: Text('LAYOUT', style: AppTextStyles.overline),
    ),
    for (final value in LayoutMode.values)
      MenuItemButton(
        leadingIcon: Icon(
          value == mode ? Icons.check_rounded : null,
          size: AppSizes.icon,
        ),
        onPressed: () => ref.read(layoutModeProvider.notifier).choose(value),
        child: Text(value.label),
      ),
  ];
}
