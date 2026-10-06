// Mobile and desktop mode (2026-10-06): the person's choice, applied on
// top of the responsive layout, remembered on the device.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/app/shell/app_sidebar.dart';
import 'package:kc_admin_portal/core/responsive/app_breakpoints.dart';
import 'package:kc_admin_portal/core/responsive/layout_mode.dart';

import '../helpers/fake_auth.dart';

Future<void> _open(
  WidgetTester tester,
  String location,
  Size size, {
  MemoryLayoutModeStore? store,
}) async {
  final router = await pumpFullApp(
    tester,
    repository: FakeAuthRepository(sessionUser: testUser),
    mockDashboard: true,
    size: size,
    overrides: [
      layoutModeStoreProvider.overrideWithValue(
        store ?? MemoryLayoutModeStore(),
      ),
    ],
  );
  router.go(location);
  await tester.pumpAndSettle();
}

void main() {
  group('the rule', () {
    test('auto and mobile leave the size alone', () {
      for (final size in ScreenSize.values) {
        expect(LayoutMode.auto.apply(size, 1440), size);
        expect(LayoutMode.mobile.apply(size, 1440), size);
      }
    });

    test('desktop: at least desktop, where the screen has room', () {
      expect(
        LayoutMode.desktop.apply(ScreenSize.tablet, 768),
        ScreenSize.desktop,
      );
      expect(
        LayoutMode.desktop.apply(ScreenSize.mobile, 700),
        ScreenSize.desktop,
      );
      expect(
        LayoutMode.desktop.apply(ScreenSize.largeDesktop, 1920),
        ScreenSize.largeDesktop,
      );
      // A phone has no room for the sidebar: unchanged.
      expect(
        LayoutMode.desktop.apply(ScreenSize.mobile, 390),
        ScreenSize.mobile,
      );
    });
  });

  testWidgets('mobile mode on a wide screen: the phone layout, centred', (
    tester,
  ) async {
    await _open(
      tester,
      '/employees',
      const Size(1440, 900),
      store: MemoryLayoutModeStore(LayoutMode.mobile),
    );
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(AppSidebar), findsNothing);
    expect(
      tester.getSize(find.byType(Scaffold).first).width,
      LayoutMode.mobileColumnWidth,
    );
    // Employees as list items, not a table.
    expect(find.text('EC NUMBER'), findsNothing);
  });

  testWidgets('desktop mode on a tablet: sidebar and tables', (tester) async {
    await _open(
      tester,
      '/employees',
      const Size(700, 1000),
      store: MemoryLayoutModeStore(LayoutMode.desktop),
    );
    expect(find.byType(AppSidebar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.text('EMPLOYEE'), findsWidgets);
  });

  testWidgets('auto on the same tablet: the navigation rail', (tester) async {
    await _open(tester, '/employees', const Size(700, 1000));
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(AppSidebar), findsNothing);
  });

  testWidgets('desktop mode on a phone keeps the phone layout and says why', (
    tester,
  ) async {
    await _open(
      tester,
      '/dashboard',
      const Size(390, 844),
      store: MemoryLayoutModeStore(LayoutMode.desktop),
    );
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(
      find.textContaining('The desktop layout needs a wider screen'),
      findsOneWidget,
    );
  });

  testWidgets('switching on the dashboard is remembered', (tester) async {
    final store = MemoryLayoutModeStore();
    await _open(tester, '/dashboard', const Size(1440, 900), store: store);
    expect(find.byType(AppSidebar), findsOneWidget);

    await tester.tap(find.text('Mobile'));
    await tester.pumpAndSettle();
    expect(store.saved, LayoutMode.mobile);
    expect(find.byType(NavigationBar), findsOneWidget);

    // (A start with a saved choice is the first tests' setup.)
    // And back, from the dashboard again.
    await tester.ensureVisible(find.text('Auto'));
    await tester.tap(find.text('Auto'));
    await tester.pumpAndSettle();
    expect(find.byType(AppSidebar), findsOneWidget);
    expect(store.saved, LayoutMode.auto);
  });

  testWidgets('the account menu offers it too', (tester) async {
    final store = MemoryLayoutModeStore();
    await _open(tester, '/employees', const Size(390, 844), store: store);
    await tester.tap(find.byTooltip('Account'));
    await tester.pumpAndSettle();
    expect(find.text('LAYOUT'), findsOneWidget);
    await tester.tap(find.text('Desktop').last);
    await tester.pumpAndSettle();
    expect(store.saved, LayoutMode.desktop);
  });
}
