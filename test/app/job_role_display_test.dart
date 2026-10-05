import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_auth.dart';
import '../helpers/fake_dashboard.dart';

/// Department and position are enums; on screen they must always read as
/// "Graphic Designer", never as a code name ("graphicDesigner") or
/// "JobRole.tailor" (both compile when a string is expected).
void main() {
  final rawName = RegExp(r'JobRole\.|graphicDesigner|graphic_designer');

  for (final (location, size) in [
    ('/employees', const Size(1440, 1000)),
    ('/employees', const Size(390, 900)),
    ('/employees/1', const Size(1440, 1400)),
    ('/attendance', const Size(1440, 1000)),
    ('/attendance', const Size(390, 900)),
    ('/leave', const Size(1440, 1000)),
    ('/dashboard', const Size(1440, 1000)),
    ('/access-control', const Size(1440, 1000)),
  ]) {
    testWidgets('$location at ${size.width.toInt()} shows labels', (
      tester,
    ) async {
      final router = await pumpFullApp(
        tester,
        repository: FakeAuthRepository(sessionUser: testUser),
        dashboard: FakeDashboardRepository(
          summary: testSummary.copyWith(
            notPunchedIn: [
              testSummary.notPunchedIn.first.copyWith(department: null),
              ...testSummary.notPunchedIn,
            ],
          ),
        ),
        size: size,
      );
      router.go(location);
      await tester.pumpAndSettle();

      final texts = [
        for (final e in find.byType(RichText).evaluate())
          (e.widget as RichText).text.toPlainText(),
      ];
      expect(texts, isNotEmpty);
      final bad = texts.where(rawName.hasMatch).toList();
      expect(bad, isEmpty, reason: 'raw enum names on $location: $bad');
    });
  }
}
