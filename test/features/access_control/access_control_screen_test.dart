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

  group('invitations', () {
    /// Adds Meera (an invitation) and returns to the list.
    Future<GoRouter> invite(WidgetTester tester) async {
      final router = await _open(tester, '/access-control/new');
      await tester.enterText(_input('Full name'), 'Meera Rathod');
      await tester.enterText(_input('Email'), 'meera.rathod@keshav.in');
      await tester.pumpAndSettle();
      await _tap(tester, find.widgetWithText(FilledButton, 'Add user').last);
      router.go('/access-control');
      await tester.pumpAndSettle();
      expect(find.text('Invited'), findsOneWidget);
      return router;
    }

    testWidgets('resend from the list', (tester) async {
      await invite(tester);
      await _tap(tester, find.byTooltip('More actions for Meera Rathod'));
      expect(find.text('Deactivate'), findsNothing);
      await _tap(tester, find.text('Resend invitation'));
      expect(
        find.text('Invitation sent again to meera.rathod@keshav.in'),
        findsOneWidget,
      );
      expect(find.text('Invited'), findsOneWidget);
    });

    testWidgets('cancel from the list asks first', (tester) async {
      await invite(tester);
      await _tap(tester, find.byTooltip('More actions for Meera Rathod'));
      await _tap(tester, find.text('Cancel invitation'));
      expect(
        find.text('Cancel the invitation to Meera Rathod?'),
        findsOneWidget,
      );

      // Keeping it changes nothing.
      await _tap(tester, find.text('Keep invitation'));
      expect(find.text('Meera Rathod'), findsOneWidget);

      await _tap(tester, find.byTooltip('More actions for Meera Rathod'));
      await _tap(tester, find.text('Cancel invitation'));
      await _tap(tester, find.text('Cancel invitation').last);
      expect(find.text('Invitation to Meera Rathod cancelled'), findsOneWidget);
      expect(find.text('Meera Rathod'), findsNothing);
      expect(find.text('Invited'), findsNothing);
    });

    testWidgets("cancel from the user's page goes back to the list", (
      tester,
    ) async {
      final router = await invite(tester);
      await _tap(tester, find.byTooltip('Permissions of Meera Rathod'));
      expect(find.text('Invited'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Deactivate'), findsNothing);
      expect(find.text('Resend invitation'), findsOneWidget);

      await _tap(tester, find.text('Cancel invitation'));
      await _tap(tester, find.text('Cancel invitation').last);
      expect(currentLocation(router), '/access-control');
      expect(find.text('Meera Rathod'), findsNothing);
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
      await _tap(tester, find.widgetWithText(FilledButton, 'Add user').last);
      expect(find.text('Already used by Admin'), findsOneWidget);

      await tester.enterText(_input('Email'), 'meera.rathod@keshav.in');
      await tester.pumpAndSettle();
      await _tap(tester, find.widgetWithText(FilledButton, 'Add user').last);

      // Straight to their permissions, with none yet.
      expect(currentLocation(router), startsWith('/access-control/u'));
      // Adding invites them (2026-10-06).
      expect(
        find.text(
          'Invitation sent to meera.rathod@keshav.in. Now choose what they '
          'can do.',
        ),
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
