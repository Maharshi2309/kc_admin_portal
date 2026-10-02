import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_access_store.dart';
import 'package:kc_admin_portal/features/users/data/models/user_account_models.dart';

import '../../helpers/fake_auth.dart';

/// The app with the mock backend acting for Arjun Joshi (attendance desk:
/// limited access).
Future<(GoRouter, MockAccessStore)> _openAsAttendanceDesk(
  WidgetTester tester,
  String location,
) async {
  final router = await pumpFullApp(
    tester,
    repository: FakeAuthRepository(sessionUser: testUser),
  );
  final store = ProviderScope.containerOf(
    tester.element(find.byType(MaterialApp)),
  ).read(mockAccessStoreProvider)..resume('u5');
  router.go(location);
  await tester.pumpAndSettle();
  return (router, store);
}

Finder _input(String label) => find.descendant(
  of: find.byWidgetPredicate((w) => w is AppTextField && w.label == label),
  matching: find.byType(TextField),
);

void main() {
  testWidgets("a refused action shows the server's reason", (tester) async {
    await _openAsAttendanceDesk(tester, '/holidays/add');
    await tester.tap(find.text('Select date'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('30').last);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.enterText(_input('Holiday name'), 'Team day');
    await tester.tap(find.widgetWithText(FilledButton, 'Add holiday').last);
    await tester.pumpAndSettle();
    expect(
      find.text('You do not have permission to add holidays.'),
      findsOneWidget,
    );
  });

  testWidgets('a page the role cannot view says so', (tester) async {
    await _openAsAttendanceDesk(tester, '/access-control');
    expect(
      find.text('You do not have permission to manage users and permissions.'),
      findsOneWidget,
    );
  });

  testWidgets('a deactivated user loses the session at once', (tester) async {
    final (router, store) = await _openAsAttendanceDesk(tester, '/dashboard');
    store
      ..resume('u1')
      ..updateUser(
        'u5',
        const UserAccountUpdate(
          name: 'Arjun Joshi',
          email: 'arjun.joshi@keshav.in',
          isActive: false,
        ),
      )
      ..resume('u5');
    router.go('/holidays');
    await tester.pumpAndSettle();
    expect(currentLocation(router), startsWith('/login'));
    // The reason comes from the server.
    expect(find.text('Your account has been deactivated.'), findsOneWidget);
  });
}
