import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kc_admin_portal/core/widgets/app_pagination.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('visiblePages', () {
    test('lists every page when there are few', () {
      expect(AppPagination.visiblePages(1, 5), [1, 2, 3, 4, 5]);
    });

    test('shows ellipses around the current page', () {
      expect(AppPagination.visiblePages(1, 13), [1, 2, 3, 4, null, 13]);
      expect(AppPagination.visiblePages(7, 13), [1, null, 6, 7, 8, null, 13]);
      expect(AppPagination.visiblePages(13, 13), [1, null, 10, 11, 12, 13]);
    });
  });

  testWidgets('desktop shows range text and page numbers', (tester) async {
    int? requested;
    await tester.pumpApp(
      AppPagination(
        page: 1,
        pageSize: 10,
        totalItems: 124,
        onPageChanged: (page) => requested = page,
      ),
      size: const Size(1000, 400),
    );
    expect(find.text('Showing 1–10 of 124'), findsOneWidget);
    await tester.tap(find.text('13'));
    expect(requested, 13);
  });

  testWidgets('phone shows a compact page indicator', (tester) async {
    await tester.pumpApp(
      AppPagination(
        page: 2,
        pageSize: 10,
        totalItems: 124,
        onPageChanged: (_) {},
      ),
      size: const Size(360, 400),
    );
    expect(find.text('Page 2 of 13'), findsOneWidget);
    expect(find.text('11–20 of 124'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
