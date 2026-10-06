import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kc_admin_portal/core/responsive/layout_mode.dart';

import '../helpers/fake_auth.dart';

/// Every screen at every device class the portal targets, including the
/// exact breakpoint edges (599/600, 1023/1024, 1439/1440) and landscape
/// phones. A screen passes when it lays out without overflow while
/// scrolled to the top and to the bottom.
const _sizes = <String, Size>{
  'phone SE (320x568)': Size(320, 568),
  'phone small (360x640)': Size(360, 640),
  'phone (390x844)': Size(390, 844),
  'phone large (430x932)': Size(430, 932),
  'phone landscape (844x390)': Size(844, 390),
  'below tablet (599x900)': Size(599, 900),
  'tablet edge (600x900)': Size(600, 900),
  'tablet portrait (768x1024)': Size(768, 1024),
  'below desktop (1023x768)': Size(1023, 768),
  'desktop edge (1024x768)': Size(1024, 768),
  'laptop (1280x800)': Size(1280, 800),
  'below wide (1439x900)': Size(1439, 900),
  'wide edge (1440x900)': Size(1440, 900),
  'full HD (1920x1080)': Size(1920, 1080),
  '2K (2560x1440)': Size(2560, 1440),
};

/// Signing in, signing up and recovering a password.
const _signedOutRoutes = [
  '/login',
  '/register',
  '/verify-email?email=asha@bright.in',
  '/forgot-password',
  '/reset-password?email=asha@bright.in',
];

/// Signed in, in no organization yet.
const _onboardingRoutes = ['/welcome', '/create-organization'];

const _allRoutes = [
  ..._signedOutRoutes,
  ..._onboardingRoutes,
  ..._signedInRoutes,
];

const _signedInRoutes = [
  '/dashboard',
  '/employees',
  '/employees/add',
  '/employees/import',
  '/employees/1',
  '/employees/1/edit',
  '/employees/1/schedule',
  '/employees/1/calendar/2026-09-25',
  '/employees/1/calendar/2026-09-20/attendance',
  '/attendance',
  '/attendance/7-20260928/edit',
  '/attendance/new?employeeId=1&date=2026-09-28',
  '/leave',
  '/leave?view=balances',
  '/leave/add?employeeId=1',
  '/leave/1/edit',
  '/holidays',
  '/holidays/add',
  '/holidays/h3/edit',
  '/access-control',
  '/access-control/new',
  '/access-control/u3',
  '/access-control/u1',
  '/access-control/u3/edit',
  '/settings',
];

/// Scrolls every vertical scroll view to its end, so content below the
/// fold is laid out (and checked) too.
Future<void> _scrollAllToEnd(WidgetTester tester) async {
  for (final state in tester.stateList<ScrollableState>(
    find.byType(Scrollable),
  )) {
    final position = state.position;
    if (state.widget.axisDirection == AxisDirection.down &&
        position.hasContentDimensions) {
      position.jumpTo(position.maxScrollExtent);
    }
  }
  await tester.pumpAndSettle();
}

Future<void> _check(
  WidgetTester tester,
  String location,
  Size size, {
  double textScale = 1,
  LayoutMode mode = LayoutMode.auto,
}) async {
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

  final router = await pumpFullApp(
    tester,
    repository: FakeAuthRepository(
      sessionUser: _signedOutRoutes.contains(location)
          ? null
          : _onboardingRoutes.contains(location)
          ? testUser.copyWith(permissions: const [], memberships: const [])
          : testUser,
    ),
    mockDashboard: true,
    size: size,
    overrides: [
      layoutModeStoreProvider.overrideWithValue(MemoryLayoutModeStore(mode)),
    ],
  );
  router.go(location);
  await tester.pumpAndSettle();
  expect(
    Uri.parse(currentLocation(router)).path,
    Uri.parse(location).path,
    reason: 'not redirected',
  );
  // Layout errors (overflow) fail the test with the framework's report.
  await _scrollAllToEnd(tester);
}

void main() {
  group('every screen at every size', () {
    for (final size in _sizes.entries) {
      group(size.key, () {
        for (final location in _allRoutes) {
          testWidgets(
            location,
            (tester) => _check(tester, location, size.value),
          );
        }
      });
    }
  });

  // The layout the person chose (2026-10-06): every screen at every size
  // in mobile and in desktop mode too.
  for (final mode in [LayoutMode.mobile, LayoutMode.desktop]) {
    group('${mode.label} mode', () {
      for (final size in _sizes.entries) {
        group(size.key, () {
          for (final location in _allRoutes) {
            testWidgets(
              location,
              (tester) => _check(tester, location, size.value, mode: mode),
            );
          }
        });
      }
    });
  }

  // Large system font sizes (accessibility settings on phones and browser
  // zoom-like text scaling on desktop).
  group('large text', () {
    const cases = {
      'phone': Size(390, 844),
      'tablet': Size(768, 1024),
      'desktop': Size(1440, 900),
    };
    for (final scale in [1.3, 2.0]) {
      for (final size in cases.entries) {
        group('${scale}x on ${size.key}', () {
          for (final location in _allRoutes) {
            testWidgets(
              location,
              (tester) =>
                  _check(tester, location, size.value, textScale: scale),
            );
          }
        });
      }
    }
  });
}
