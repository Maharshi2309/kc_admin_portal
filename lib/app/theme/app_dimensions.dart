import 'package:flutter/painting.dart';

/// Spacing scale (4 px base) used for padding, gaps and margins.
abstract final class AppSpacing {
  static const double s2 = 2;
  static const double s4 = 4;
  static const double s6 = 6;
  static const double s8 = 8;
  static const double s10 = 10;
  static const double s12 = 12;
  static const double s14 = 14;
  static const double s16 = 16;
  static const double s18 = 18;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s28 = 28;
  static const double s32 = 32;
  static const double s40 = 40;
  static const double s56 = 56;
}

abstract final class AppRadius {
  static const double xs = 6;
  static const double sm = 8;
  static const double md = 10;
  static const double lg = 12;
  static const double card = 14;
  static const double dialog = 16;
  static const double pill = 999;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius cardAll = BorderRadius.all(Radius.circular(card));
  static const BorderRadius dialogAll = BorderRadius.all(
    Radius.circular(dialog),
  );
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));
}

/// Component sizes from the design.
abstract final class AppSizes {
  // Controls
  static const double buttonHeight = 40;
  static const double buttonHeightSmall = 32;
  static const double buttonHeightLarge = 48;
  static const double inputHeight = 44;
  static const double inputHeightLarge = 48;
  static const double chipHeight = 36;
  static const double segmentHeight = 36;
  static const double iconButton = 40;
  static const double iconButtonGhost = 32;
  static const double iconButtonInField = 28;
  static const double badgeHeight = 24;
  static const double badgeDot = 6;
  static const double checkbox = 18;
  static const double tableRowHeight = 56;

  /// Smallest tap area on touch platforms (Apple HIG, WCAG 2.5.5).
  /// Compact controls keep their design size with a mouse.
  static const double minTouchTarget = 44;

  /// Keyboard focus outline on buttons, cards and segments.
  static const double focusOutline = 2;

  // Icons
  static const double icon = 20;
  static const double iconSmall = 16;
  static const double iconLarge = 24;
  static const double iconFeature = 40;
  static const double iconTile = 40;

  // Avatars
  static const double avatarSmall = 34;
  static const double avatar = 36;
  static const double avatarLarge = 48;
  static const double avatarXLarge = 64;

  // Layout chrome
  static const double sidebarWidth = 248;
  static const double headerHeight = 72;
  static const double footerBarHeight = 72;
  static const double navItemHeight = 44;

  // Overlays
  static const double dialogMaxWidth = 620;
  static const double confirmDialogMaxWidth = 440;
  static const double sideSheetWidth = 600;
  static const double menuMaxHeight = 320;

  // Progress bars
  static const double progressThin = 6;
  static const double progressThick = 10;

  // Feedback views
  static const double feedbackMaxWidth = 420;
  static const double loaderSize = 28;
  static const double loaderSizeSmall = 18;
  static const double loaderStroke = 2.5;
}

abstract final class AppShadows {
  static const List<BoxShadow> menu = [
    BoxShadow(color: Color(0x2416181D), blurRadius: 32, offset: Offset(0, 12)),
  ];
  static const List<BoxShadow> dialog = [
    BoxShadow(color: Color(0x4716181D), blurRadius: 64, offset: Offset(0, 24)),
  ];
  static const List<BoxShadow> sideSheet = [
    BoxShadow(color: Color(0x3316181D), blurRadius: 48, offset: Offset(-16, 0)),
  ];
  static const List<BoxShadow> cardHover = [
    BoxShadow(color: Color(0x1A1D4FC4), blurRadius: 16, offset: Offset(0, 4)),
  ];
  static const List<BoxShadow> segmentThumb = [
    BoxShadow(color: Color(0x1416181D), blurRadius: 2, offset: Offset(0, 1)),
  ];
  static const List<BoxShadow> focusRing = [
    BoxShadow(color: Color(0xFFD5E0FA), spreadRadius: 3),
  ];
}

abstract final class AppDurations {
  static const Duration hover = Duration(milliseconds: 120);

  /// Delay before a hover tooltip (calendar days) appears.
  static const Duration tooltipWait = Duration(milliseconds: 400);
  static const Duration sheet = Duration(milliseconds: 250);
  static const Duration snackBar = Duration(seconds: 4);
}
