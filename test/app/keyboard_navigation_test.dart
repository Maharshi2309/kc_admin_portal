import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';

import '../helpers/fake_auth.dart';

/// Tabbing through a page reaches every part of the app (page, sidebar,
/// header search) with no invisible stops, and the focused control is
/// always on screen.
void main() {
  testWidgets('Tab cycles through page, sidebar and search, always visible', (
    tester,
  ) async {
    const window = Size(1440, 900);
    final router = await pumpFullApp(
      tester,
      repository: FakeAuthRepository(sessionUser: testUser),
      mockDashboard: true,
      size: window,
    );
    router.go('/dashboard');
    await tester.pumpAndSettle();

    var sidebarStops = 0;
    var reachedSearch = false;
    var pageStopsAfterWrap = 0;
    for (var i = 0; i < 40; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      final focus = FocusManager.instance.primaryFocus!;
      final rect = focus.rect;

      // No invisible stops: every stop is a real control with a size...
      expect(rect.isEmpty, isFalse, reason: 'stop $i has no size');
      // ...and it is on screen (scrolled into view if needed).
      expect(
        Offset.zero & window,
        predicate<Rect>((r) => r.contains(rect.center)),
        reason: 'stop $i at $rect is off screen',
      );

      if (rect.left < AppSizes.sidebarWidth) sidebarStops++;
      if (focus.debugLabel == 'header search') reachedSearch = true;
      if (reachedSearch && rect.left >= AppSizes.sidebarWidth) {
        pageStopsAfterWrap++;
      }
    }

    expect(sidebarStops, greaterThanOrEqualTo(4), reason: 'all sections');
    expect(reachedSearch, isTrue);
    expect(pageStopsAfterWrap, greaterThan(0), reason: 'back into the page');
  });
}
