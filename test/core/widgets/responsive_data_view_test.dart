import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kc_admin_portal/core/widgets/responsive_data_view.dart';

import '../../helpers/pump_app.dart';

AppDataColumn<int> _column(
  String label, {
  int priority = 0,
  double minWidth = 150,
}) => AppDataColumn<int>(
  label: label,
  priority: priority,
  minWidth: minWidth,
  cellBuilder: (_, row) => Text('$label $row'),
);

final _columns = [
  _column('Name', minWidth: 200),
  _column('Code'),
  _column('Group', priority: 2),
  _column('Detail', priority: 3),
  _column('Status', priority: 1),
];

Widget _view({List<AppDataColumn<int>>? columns}) => SingleChildScrollView(
  child: ResponsiveDataView<int>(
    rows: const [1, 2, 3],
    columns: columns ?? _columns,
    mobileItemBuilder: (_, row) => Text('item $row'),
  ),
);

void main() {
  group('visibleColumnsFor', () {
    List<String> labels(double width) => ResponsiveDataView.visibleColumnsFor(
      _columns,
      width,
    ).map((column) => column.label).toList();

    test('keeps all columns when they fit', () {
      expect(labels(800), ['Name', 'Code', 'Group', 'Detail', 'Status']);
    });

    test('hides the highest priority number first, keeping order', () {
      expect(labels(700), ['Name', 'Code', 'Group', 'Status']);
      expect(labels(550), ['Name', 'Code', 'Status']);
      expect(labels(400), ['Name', 'Code']);
    });

    test('never hides priority 0 columns', () {
      expect(labels(100), ['Name', 'Code']);
    });
  });

  group('columnWidthsFor', () {
    test('gives every column its minimum, then shares the rest by flex', () {
      final columns = [
        AppDataColumn<int>(
          label: 'Wide',
          flex: 2,
          minWidth: 100,
          cellBuilder: (_, _) => const SizedBox(),
        ),
        AppDataColumn<int>(
          label: 'Narrow',
          minWidth: 150,
          cellBuilder: (_, _) => const SizedBox(),
        ),
        AppDataColumn<int>(
          label: 'Fixed',
          fixedWidth: 50,
          cellBuilder: (_, _) => const SizedBox(),
        ),
      ];

      // 300 required, 60 extra split 2:1.
      expect(ResponsiveDataView.columnWidthsFor(columns, 360), [140, 170, 50]);
      // A flex share smaller than the minimum never shrinks the column.
      expect(ResponsiveDataView.columnWidthsFor(columns, 300), [100, 150, 50]);
    });
  });

  testWidgets('shows a table with all columns on wide screens', (tester) async {
    await tester.pumpApp(_view(), size: const Size(1200, 800));
    expect(find.text('DETAIL'), findsOneWidget);
    expect(find.text('Name 1'), findsOneWidget);
    expect(find.text('item 1'), findsNothing);
  });

  testWidgets('hides low-priority columns on tablet', (tester) async {
    await tester.pumpApp(_view(), size: const Size(700, 800));
    expect(find.text('DETAIL'), findsNothing);
    expect(find.text('STATUS'), findsOneWidget);
  });

  testWidgets('shows list items on phones', (tester) async {
    await tester.pumpApp(_view(), size: const Size(390, 800));
    expect(find.text('item 1'), findsOneWidget);
    expect(find.text('NAME'), findsNothing);
  });

  testWidgets(
    'scrolls horizontally inside its box when required columns do not fit',
    (tester) async {
      await tester.pumpApp(
        _view(
          columns: [
            for (final l in ['A', 'B', 'C', 'D', 'E']) _column(l),
          ],
        ),
        size: const Size(650, 800),
      );
      final horizontal = find.byWidgetPredicate(
        (w) =>
            w is SingleChildScrollView && w.scrollDirection == Axis.horizontal,
      );
      expect(horizontal, findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
