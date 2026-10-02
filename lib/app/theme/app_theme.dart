import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_focus.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';

/// The single [ThemeData] for the app. The design defines a light theme only.
abstract final class AppTheme {
  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primarySoft,
      onPrimaryContainer: AppColors.primary,
      secondary: AppColors.primary,
      onSecondary: AppColors.onPrimary,
      error: AppColors.dangerFg,
      onError: AppColors.onPrimary,
      errorContainer: AppColors.dangerBg,
      onErrorContainer: AppColors.dangerFg,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textMuted,
      surfaceContainerLowest: AppColors.surface,
      surfaceContainerLow: AppColors.surfaceChrome,
      surfaceContainer: AppColors.surface,
      surfaceContainerHigh: AppColors.surface,
      surfaceContainerHighest: AppColors.surfaceSunken,
      outline: AppColors.borderStrong,
      outlineVariant: AppColors.border,
      inverseSurface: AppColors.inverse,
      onInverseSurface: AppColors.onInverse,
      shadow: AppColors.inverse,
      scrim: AppColors.inverse,
      surfaceTint: Colors.transparent,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      fontFamily: AppTextStyles.fontFamily,
      textTheme: _textTheme,
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
        size: AppSizes.icon,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardAll,
          side: BorderSide(color: AppColors.border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(style: _filledButtonStyle),
      outlinedButtonTheme: OutlinedButtonThemeData(style: _outlinedButtonStyle),
      textButtonTheme: TextButtonThemeData(style: _textButtonStyle),
      inputDecorationTheme: _inputDecorationTheme,
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: AppTextStyles.input,
        inputDecorationTheme: _inputDecorationTheme,
        menuStyle: _menuStyle,
      ),
      menuTheme: MenuThemeData(style: _menuStyle),
      menuButtonTheme: MenuButtonThemeData(style: _menuItemStyle),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(side: AppFocus.side()),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.surface,
        elevation: 8,
        shadowColor: AppColors.inverse.withValues(alpha: 0.14),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
          side: BorderSide(color: AppColors.borderStrong),
        ),
        textStyle: AppTextStyles.body,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primary
              : Colors.transparent,
        ),
        checkColor: const WidgetStatePropertyAll(AppColors.onPrimary),
        side: const BorderSide(color: AppColors.borderStrong, width: 1.5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primarySoft,
        disabledColor: AppColors.surfaceDisabled,
        labelStyle: AppTextStyles.buttonSmall,
        side: WidgetStateBorderSide.resolveWith(
          (states) => BorderSide(
            color: states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.borderStrong,
          ),
        ),
        shape: const StadiumBorder(),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.textPrimary,
        unselectedLabelColor: AppColors.textMuted,
        labelStyle: AppTextStyles.bodySemibold,
        unselectedLabelStyle: AppTextStyles.bodySemibold,
        indicatorColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: AppColors.divider,
        tabAlignment: TabAlignment.start,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.dialogAll),
        titleTextStyle: AppTextStyles.headingSmall,
        contentTextStyle: AppTextStyles.body.copyWith(
          color: AppColors.textSecondary,
        ),
        barrierColor: AppColors.inverse.withValues(alpha: 0.4),
        insetPadding: const EdgeInsets.all(AppSpacing.s16),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.dialog),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.inverse,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.onInverse,
        ),
        actionTextColor: AppColors.primaryMuted,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        width: AppSizes.feedbackMaxWidth,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: const BoxDecoration(
          color: AppColors.inverse,
          borderRadius: AppRadius.smAll,
        ),
        textStyle: AppTextStyles.caption.copyWith(color: AppColors.onInverse),
        waitDuration: const Duration(milliseconds: 500),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.divider,
        circularTrackColor: Colors.transparent,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.focusRing,
        selectionHandleColor: AppColors.primary,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: AppColors.surface,
        headerForegroundColor: AppColors.textPrimary,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.dialogAll),
        dayStyle: AppTextStyles.bodyMedium,
        todayBorder: const BorderSide(color: AppColors.primary),
        cancelButtonStyle: _textButtonStyle,
        confirmButtonStyle: _textButtonStyle,
      ),
      scrollbarTheme: const ScrollbarThemeData(
        radius: Radius.circular(AppRadius.pill),
        thickness: WidgetStatePropertyAll(6),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceChrome,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.sectionTitle,
        shape: const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceChrome,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        indicatorColor: AppColors.primarySoft,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => AppTextStyles.captionSemibold.copyWith(
            color: states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.textSecondary,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: AppSizes.iconLarge,
            color: states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.textSecondary,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.surfaceChrome,
        elevation: 0,
        indicatorColor: AppColors.primarySoft,
        selectedIconTheme: const IconThemeData(
          color: AppColors.primary,
          size: AppSizes.iconLarge,
        ),
        unselectedIconTheme: const IconThemeData(
          color: AppColors.textSecondary,
          size: AppSizes.iconLarge,
        ),
        selectedLabelTextStyle: AppTextStyles.captionSemibold.copyWith(
          color: AppColors.primary,
        ),
        unselectedLabelTextStyle: AppTextStyles.captionSemibold.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      // Phones keep their native transitions (Android predictive back, iOS
      // swipe back). Desktop and desktop browsers get a quick cross-fade
      // instead of the iOS slide (macOS) or zoom (Windows) defaults.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
        },
      ),
      splashFactory: InkRipple.splashFactory,
      hoverColor: AppColors.surfaceSunken,
      highlightColor: Colors.transparent,
      // Keyboard focus on rows, tiles and calendar days: the design's
      // light-blue focus tint.
      focusColor: AppColors.focusRing,
    );
  }

  static final TextTheme _textTheme = TextTheme(
    displayLarge: AppTextStyles.display,
    displayMedium: AppTextStyles.kpiValue,
    displaySmall: AppTextStyles.statLarge,
    headlineLarge: AppTextStyles.headingLarge,
    headlineMedium: AppTextStyles.pageTitle,
    headlineSmall: AppTextStyles.headingMedium,
    titleLarge: AppTextStyles.headingSmall,
    titleMedium: AppTextStyles.sectionTitle,
    titleSmall: AppTextStyles.bodySemibold,
    bodyLarge: AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.body,
    bodySmall: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
    labelLarge: AppTextStyles.button,
    labelMedium: AppTextStyles.label,
    labelSmall: AppTextStyles.captionSemibold,
  );

  static const EdgeInsets _buttonPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.s16,
  );
  static const OutlinedBorder _buttonShape = RoundedRectangleBorder(
    borderRadius: AppRadius.mdAll,
  );
  static const Size _buttonMinSize = Size(0, AppSizes.buttonHeight);

  static final ButtonStyle _filledButtonStyle = ButtonStyle(
    minimumSize: const WidgetStatePropertyAll(_buttonMinSize),
    padding: const WidgetStatePropertyAll(_buttonPadding),
    shape: const WidgetStatePropertyAll(_buttonShape),
    textStyle: WidgetStatePropertyAll(AppTextStyles.button),
    elevation: const WidgetStatePropertyAll(0),
    side: AppFocus.side(onFilled: true),
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) return AppColors.primaryMuted;
      if (states.contains(WidgetState.hovered) ||
          states.contains(WidgetState.pressed)) {
        return AppColors.primaryHover;
      }
      return AppColors.primary;
    }),
    foregroundColor: const WidgetStatePropertyAll(AppColors.onPrimary),
    overlayColor: const WidgetStatePropertyAll(Colors.transparent),
  );

  static final ButtonStyle _outlinedButtonStyle = ButtonStyle(
    minimumSize: const WidgetStatePropertyAll(_buttonMinSize),
    padding: const WidgetStatePropertyAll(_buttonPadding),
    shape: const WidgetStatePropertyAll(_buttonShape),
    textStyle: WidgetStatePropertyAll(AppTextStyles.button),
    side: AppFocus.side(base: const BorderSide(color: AppColors.borderStrong)),
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return AppColors.surfaceDisabled;
      }
      if (states.contains(WidgetState.hovered) ||
          states.contains(WidgetState.pressed)) {
        return AppColors.background;
      }
      return AppColors.surface;
    }),
    foregroundColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.disabled)
          ? AppColors.textDisabled
          : AppColors.textPrimary,
    ),
    overlayColor: const WidgetStatePropertyAll(Colors.transparent),
  );

  static final ButtonStyle _textButtonStyle = ButtonStyle(
    minimumSize: const WidgetStatePropertyAll(_buttonMinSize),
    padding: const WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: AppSpacing.s12),
    ),
    shape: const WidgetStatePropertyAll(_buttonShape),
    textStyle: WidgetStatePropertyAll(AppTextStyles.button),
    side: AppFocus.side(),
    foregroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) return AppColors.textDisabled;
      if (states.contains(WidgetState.hovered)) return AppColors.primaryHover;
      return AppColors.primary;
    }),
    overlayColor: const WidgetStatePropertyAll(AppColors.primarySubtle),
  );

  static const OutlineInputBorder _inputBorder = OutlineInputBorder(
    borderRadius: AppRadius.mdAll,
    borderSide: BorderSide(color: AppColors.borderStrong),
  );

  static final InputDecorationThemeData _inputDecorationTheme =
      InputDecorationThemeData(
        filled: true,
        fillColor: AppColors.surface,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s12,
          vertical: AppSpacing.s12,
        ),
        hintStyle: AppTextStyles.input.copyWith(
          color: AppColors.textPlaceholder,
        ),
        helperStyle: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
        errorStyle: AppTextStyles.caption.copyWith(color: AppColors.dangerFg),
        helperMaxLines: 2,
        errorMaxLines: 2,
        prefixIconColor: AppColors.textMuted,
        suffixIconColor: AppColors.textMuted,
        border: _inputBorder,
        enabledBorder: _inputBorder,
        disabledBorder: _inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: _inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: _inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.dangerFg),
        ),
        focusedErrorBorder: _inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.dangerFg),
        ),
      );

  static final MenuStyle _menuStyle = MenuStyle(
    backgroundColor: const WidgetStatePropertyAll(AppColors.surface),
    surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
    elevation: const WidgetStatePropertyAll(8),
    shadowColor: WidgetStatePropertyAll(
      AppColors.inverse.withValues(alpha: 0.14),
    ),
    shape: const WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: AppRadius.lgAll,
        side: BorderSide(color: AppColors.borderStrong),
      ),
    ),
    padding: const WidgetStatePropertyAll(EdgeInsets.all(AppSpacing.s6)),
    maximumSize: const WidgetStatePropertyAll(
      Size(double.infinity, AppSizes.menuMaxHeight),
    ),
  );

  static final ButtonStyle _menuItemStyle = ButtonStyle(
    minimumSize: const WidgetStatePropertyAll(Size(0, AppSizes.buttonHeight)),
    padding: const WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: AppSpacing.s10),
    ),
    shape: const WidgetStatePropertyAll(
      RoundedRectangleBorder(borderRadius: AppRadius.smAll),
    ),
    textStyle: WidgetStatePropertyAll(AppTextStyles.bodyMedium),
    backgroundColor: WidgetStateProperty.resolveWith(
      (states) =>
          states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)
          ? AppColors.primarySoft
          : Colors.transparent,
    ),
    foregroundColor: WidgetStateProperty.resolveWith(
      (states) =>
          states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)
          ? AppColors.primary
          : AppColors.textPrimary,
    ),
    overlayColor: const WidgetStatePropertyAll(Colors.transparent),
  );
}
