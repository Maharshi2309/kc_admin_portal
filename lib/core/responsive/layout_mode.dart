import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/responsive/app_breakpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The layout the person chose (2026-10-06, docs/ARCHITECTURE_MULTI_ORG.md
/// §E). It works with the responsive layout instead of replacing it:
///
/// - [auto]: by the width, as before;
/// - [mobile]: the phone layout (bottom navigation, cards, one column) at
///   any width; on a wide screen the app is shown in a phone-width column;
/// - [desktop]: the desktop layout (sidebar, tables, several columns) from
///   [AppBreakpoints.tablet] up; narrower than that there's no room, so
///   the phone layout stays.
enum LayoutMode {
  auto('Auto'),
  mobile('Mobile'),
  desktop('Desktop');

  const LayoutMode(this.label);

  final String label;

  /// The width of the phone column [mobile] uses on a wide screen.
  static const double mobileColumnWidth = 560;

  /// Whether [desktop] can apply at [screenWidth].
  static bool desktopFits(double screenWidth) =>
      screenWidth >= AppBreakpoints.tablet;

  /// The layout size for a width that would be [natural] in [auto], on a
  /// screen [screenWidth] wide. Mobile mode needs nothing here: the app is
  /// narrow already (see `LayoutModeFrame`).
  ScreenSize apply(ScreenSize natural, double screenWidth) => switch (this) {
    desktop when desktopFits(screenWidth) =>
      natural.isAtLeast(ScreenSize.desktop) ? natural : ScreenSize.desktop,
    _ => natural,
  };
}

/// Makes the chosen [mode] known to the layout below it.
class LayoutModeScope extends InheritedWidget {
  const LayoutModeScope({required this.mode, required super.child, super.key});

  final LayoutMode mode;

  /// The mode in effect; [LayoutMode.auto] outside a scope (tests, previews).
  static LayoutMode of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LayoutModeScope>()?.mode ??
      LayoutMode.auto;

  @override
  bool updateShouldNotify(LayoutModeScope oldWidget) => mode != oldWidget.mode;
}

/// Where the choice is kept: on this device only, so a phone and a laptop
/// can use different modes (not synced with the account).
abstract interface class LayoutModeStore {
  Future<LayoutMode?> read();

  Future<void> write(LayoutMode mode);
}

class _PreferencesStore implements LayoutModeStore {
  static const String _key = 'layout_mode';

  @override
  Future<LayoutMode?> read() async {
    try {
      final name = (await SharedPreferences.getInstance()).getString(_key);
      return LayoutMode.values.where((m) => m.name == name).firstOrNull;
    } on Object {
      return null; // No storage: start with Auto.
    }
  }

  @override
  Future<void> write(LayoutMode mode) async {
    try {
      await (await SharedPreferences.getInstance()).setString(_key, mode.name);
    } on Object {
      // Not remembered, but the app still uses it until it closes.
    }
  }
}

final layoutModeStoreProvider = Provider<LayoutModeStore>(
  (ref) => _PreferencesStore(),
);

/// The chosen mode: Auto until the saved choice loads.
class LayoutModeController extends Notifier<LayoutMode> {
  @override
  LayoutMode build() {
    ref.read(layoutModeStoreProvider).read().then((saved) {
      if (saved != null && ref.mounted) state = saved;
    });
    return LayoutMode.auto;
  }

  Future<void> choose(LayoutMode mode) async {
    state = mode;
    await ref.read(layoutModeStoreProvider).write(mode);
  }
}

final layoutModeProvider = NotifierProvider<LayoutModeController, LayoutMode>(
  LayoutModeController.new,
);
