// The import page (2026-10-06): upload, match columns, review, confirm,
// result, on desktop and on a phone.
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kc_admin_portal/core/files/file_picking.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';

import '../../helpers/fake_auth.dart';
import '../../helpers/xlsx.dart';

final _file = xlsx([
  ['Employee Code', 'Employee Name', 'Designation', 'Dept', 'Phone', 'DOJ'],
  ['KC2001', 'Asha Iyer', 'Tailor', 'Tailor', '9876543210', '01/09/2026'],
  [
    'KC2002',
    'Ben Mathew',
    'Accountant',
    'Accountant',
    '9876500001',
    '15/08/2026',
  ],
  ['KC2003', 'Bad Date', 'Tailor', 'Tailor', '9876500004', '31/02/2026'],
]);

/// The files "saved" by the app, by name.
final Map<String, Uint8List> _saved = {};

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<GoRouter> _open(
  WidgetTester tester, {
  Size size = const Size(1440, 1000),
  List<String>? permissions,
}) {
  _saved.clear();
  return pumpFullApp(
    tester,
    repository: FakeAuthRepository(
      sessionUser: permissions == null
          ? testUser
          : testUser.copyWith(permissions: permissions),
    ),
    size: size,
    overrides: [
      fileChooserProvider.overrideWithValue(
        ({required extensions}) async => (name: 'staff.xlsx', bytes: _file),
      ),
      excelSaverProvider.overrideWithValue(
        (name, bytes) async => _saved[name] = bytes,
      ),
    ],
  );
}

void main() {
  testWidgets('the whole import, from the Employees page', (tester) async {
    final router = await _open(tester);
    router.go('/employees');
    await tester.pumpAndSettle();
    await _tap(tester, find.text('Import employees').first);
    expect(currentLocation(router), '/employees/import');

    // The template.
    await _tap(tester, find.text('Download template'));
    expect(_saved.keys, ['employee-import-template']);
    expect(find.textContaining('Template saved'), findsOneWidget);

    // 1 Upload → 2 Match columns, guessed from the headers.
    await _tap(tester, find.text('Choose Excel file'));
    expect(find.text('Match the columns'), findsOneWidget);
    expect(find.textContaining('staff.xlsx · 3 rows'), findsOneWidget);
    expect(find.text('Designation'), findsOneWidget);
    expect(find.text('Position *'), findsOneWidget); // its guess
    expect(find.text('Still to match'), findsNothing);

    // 3 Review.
    await _tap(tester, find.text('Check rows'));
    expect(find.bySemanticsLabel('Ready: 2'), findsOneWidget);
    expect(find.bySemanticsLabel('Errors: 1'), findsOneWidget);
    expect(find.textContaining("isn't a date"), findsOneWidget);

    // 4 Confirm and result.
    await _tap(tester, find.text('Import 2 rows'));
    expect(find.text('Import 2 rows?'), findsOneWidget);
    await _tap(tester, find.widgetWithText(FilledButton, 'Import'));
    expect(find.text('Import completed'), findsOneWidget);
    expect(find.bySemanticsLabel('Imported: 2'), findsOneWidget);
    expect(find.bySemanticsLabel('Not imported: 1'), findsOneWidget);

    await _tap(tester, find.text('Download rows not imported'));
    expect(_saved.keys, contains('employees-not-imported'));

    await _tap(tester, find.text('View employees'));
    router.go('/employees?search=Asha');
    await tester.pumpAndSettle();
    expect(find.text('Asha Iyer'), findsWidgets);
  });

  testWidgets('a required field without a column holds the check', (
    tester,
  ) async {
    final router = await _open(tester);
    router.go('/employees/import');
    await tester.pumpAndSettle();
    await _tap(tester, find.text('Choose Excel file'));

    // "DOJ" → Don't import.
    await _tap(tester, find.text('Joining date *'));
    await _tap(tester, find.text("Don't import").last);
    expect(find.text('Still to match'), findsOneWidget);
    expect(find.text('Joining date'), findsWidgets);
    final check = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Check rows'),
    );
    expect(check.onPressed, isNull);
  });

  testWidgets('on a phone: one step per screen, rows as cards', (tester) async {
    final router = await _open(tester, size: const Size(390, 844));
    router.go('/employees/import');
    await tester.pumpAndSettle();
    expect(find.text('Step 1 of 4 · Upload'), findsOneWidget);
    await _tap(tester, find.text('Choose Excel file'));
    expect(find.text('Step 2 of 4 · Match columns'), findsOneWidget);
    await _tap(tester, find.text('Check rows'));
    expect(find.text('Step 3 of 4 · Review'), findsOneWidget);
    expect(find.textContaining('Row 4 · Bad Date'), findsOneWidget);
  });

  testWidgets('only for people who can add employees', (tester) async {
    final router = await _open(
      tester,
      permissions: [
        for (final p in AppPermission.values)
          if (p != AppPermission.employeeCreate) p.key,
      ],
    );
    router.go('/employees');
    await tester.pumpAndSettle();
    expect(find.text('Import employees'), findsNothing);
    router.go('/employees/import');
    await tester.pumpAndSettle();
    expect(currentLocation(router), startsWith('/no-access'));
  });
}
