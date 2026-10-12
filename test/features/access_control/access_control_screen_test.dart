import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';
import 'package:kc_admin_portal/features/users/presentation/widgets/users_table.dart';

import '../../helpers/fake_auth.dart';

/// Signed in as the mock's Admin (u1), so their own row is "You".
Future<GoRouter> _open(WidgetTester tester, String location) async {
  final router = await pumpFullApp(
    tester,
    repository: FakeAuthRepository(sessionUser: testUser.copyWith(id: 'u1')),
    size: const Size(1440, 1400),
  );
  router.go(location);
  await tester.pumpAndSettle();
  return router;
}

Finder _input(String label) => find.descendant(
  of: find.byWidgetPredicate((w) => w is AppTextField && w.label == label),
  matching: find.byType(TextField),
);

Future<void> _tap(WidgetTester tester, Finder target) async {
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

final int _total = AppPermission.values.length;

void main() {
  group('users list', () {
    testWidgets('each user with their access, and you marked', (tester) async {
      await _open(tester, '/access-control');
      expect(find.text('Access control'), findsWidgets);
      expect(find.text('Admin'), findsOneWidget);
      expect(find.text('You'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(UsersTable),
          matching: find.text('Full access'),
        ),
        findsNWidgets(2), // Admin, Mansi
      );
      expect(find.text('16 of $_total permissions'), findsNWidgets(2));
      expect(find.text('8 of $_total permissions'), findsOneWidget);
      expect(find.text('Never'), findsOneWidget); // Kunal Desai
      expect(find.byTooltip('You cannot deactivate yourself'), findsOneWidget);
      // No roles anywhere.
      expect(find.textContaining('Role'), findsNothing);
    });

    testWidgets('search', (tester) async {
      await _open(tester, '/access-control');
      await tester.enterText(
        find.widgetWithText(TextField, 'Name or email'),
        'nisha',
      );
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(find.text('Kunal Desai'), findsNothing);
      expect(find.text('nisha.solanki@keshav.in'), findsOneWidget);
    });

    testWidgets('deactivating asks first', (tester) async {
      await _open(tester, '/access-control');
      await _tap(tester, find.byTooltip('More actions for Arjun Joshi'));
      await _tap(tester, find.text('Deactivate'));
      expect(find.text('Deactivate Arjun Joshi?'), findsOneWidget);
      await _tap(tester, find.text('Deactivate user'));
      expect(find.text('Arjun Joshi deactivated'), findsOneWidget);
      expect(find.text('Inactive'), findsOneWidget);
    });
  });

  group('adding a user', () {
    testWidgets('then choosing what they can do', (tester) async {
      final router = await _open(tester, '/access-control');
      await _tap(tester, find.widgetWithText(FilledButton, 'Add user'));
      expect(currentLocation(router), '/access-control/new');

      await _tap(tester, find.widgetWithText(FilledButton, 'Add user').last);
      expect(find.text('Full name is required'), findsOneWidget);

      await tester.enterText(_input('Full name'), 'Meera Rathod');
      await tester.enterText(_input('Email'), 'admin@keshav.in');
      await tester.enterText(_input('Password'), 'short');
      await tester.pumpAndSettle();
      await tester.enterText(_input('Confirm password'), 'other');
      await _tap(tester, find.widgetWithText(FilledButton, 'Add user').last);
      expect(find.text('Use at least 8 characters'), findsOneWidget);
      expect(find.text('Passwords do not match'), findsOneWidget);

      await tester.enterText(_input('Password'), 'meera-pass');
      await tester.enterText(_input('Confirm password'), 'meera-pass');
      await _tap(tester, find.widgetWithText(FilledButton, 'Add user').last);
      expect(find.text('Already used by Admin'), findsOneWidget);

      await tester.enterText(_input('Email'), 'meera.rathod@keshav.in');
      await tester.pumpAndSettle();
      await _tap(tester, find.widgetWithText(FilledButton, 'Add user').last);

      // Straight to their permissions, with none yet.
      expect(currentLocation(router), startsWith('/access-control/u'));
      expect(
        find.text('Meera Rathod added. Now choose what they can do.'),
        findsOneWidget,
      );
      expect(find.text('0 of $_total permissions'), findsOneWidget);
    });
  });

  group("a user's permissions", () {
    testWidgets('tick, save, and it shows in the list', (tester) async {
      final router = await _open(tester, '/access-control/u4');
      expect(find.text('Kunal Desai'), findsWidgets);
      expect(find.text('16 of $_total permissions'), findsOneWidget);

      await _tap(tester, find.text('Delete holidays'));
      expect(find.text('1 unsaved change'), findsNWidgets(2));
      await _tap(tester, find.text('Save permissions').first);
      expect(find.text('Permissions of Kunal Desai saved'), findsOneWidget);
      expect(find.text('17 of $_total permissions'), findsOneWidget);

      router.go('/access-control');
      await tester.pumpAndSettle();
      expect(find.text('17 of $_total permissions'), findsOneWidget);
    });

    testWidgets('select all, clear all, discard', (tester) async {
      await _open(tester, '/access-control/u5');
      await _tap(tester, find.text('Select all'));
      expect(find.text('Full access: all $_total permissions'), findsOneWidget);
      await _tap(tester, find.text('Clear all'));
      expect(find.text('0 of $_total permissions'), findsOneWidget);
      await _tap(tester, find.text('Discard').first);
      expect(find.text('8 of $_total permissions'), findsOneWidget);
    });

    testWidgets("copy another user's permissions", (tester) async {
      await _open(tester, '/access-control/u5');
      await _tap(tester, find.textContaining('Copy from'));
      await _tap(tester, find.text('Nisha Solanki').last);
      expect(find.text('16 of $_total permissions'), findsOneWidget);
      expect(find.textContaining('Copied the permissions of Nisha'), findsOne);
    });

    testWidgets('your own Manage users and permissions stays on', (
      tester,
    ) async {
      await _open(tester, '/access-control/u1');
      expect(find.textContaining('This is you.'), findsOneWidget);
      await _tap(tester, find.text('Clear all'));
      // Everything but the locked one.
      expect(find.text('1 of $_total permissions'), findsOneWidget);
      expect(find.text('Deactivate'), findsNothing);
    });

    testWidgets('edit details from the user page', (tester) async {
      final router = await _open(tester, '/access-control/u3');
      await _tap(tester, find.text('Edit details'));
      expect(currentLocation(router), '/access-control/u3/edit');
      await _tap(tester, find.text('Remove')); // unlink the employee
      await _tap(tester, find.widgetWithText(FilledButton, 'Save changes'));
      expect(find.text('Nisha Solanki updated'), findsOneWidget);
      expect(currentLocation(router), '/access-control/u3');
      expect(find.textContaining('No linked employee'), findsOneWidget);
    });
  });
}
