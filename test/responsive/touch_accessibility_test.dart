import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_auth.dart';

/// On Android and iOS every control can be tapped comfortably (44 px, see
/// `AppSizes.minTouchTarget`), has an accessible label, and its text meets
/// WCAG contrast.
const _routes = [
  '/login',
  '/dashboard',
  '/employees',
  '/employees/add',
  '/employees/1',
  '/employees/1/edit',
  '/employees/1/schedule',
  '/employees/1/calendar/2026-09-25',
  '/employees/1/calendar/2026-09-20/attendance',
  '/attendance',
  '/attendance/7-20260928/edit',
  '/attendance/new?employeeId=1',
  '/leave',
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
];

const _sizes = {'phone': Size(390, 844), 'tablet': Size(820, 1180)};

void main() {
  for (final size in _sizes.entries) {
    group(size.key, () {
      for (final location in _routes) {
        testWidgets(location, variant: TargetPlatformVariant.mobile(), (
          tester,
        ) async {
          final semantics = tester.ensureSemantics();
          final router = await pumpFullApp(
            tester,
            repository: FakeAuthRepository(
              sessionUser: location == '/login' ? null : testUser,
            ),
            mockDashboard: true,
            size: size.value,
          );
          router.go(location);
          await tester.pumpAndSettle();

          await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          await expectLater(tester, meetsGuideline(textContrastGuideline));
          semantics.dispose();
        });
      }
    });
  }
}
