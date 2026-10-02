import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kc_admin_portal/core/widgets/app_dialog.dart';
import 'package:kc_admin_portal/core/widgets/app_overlay_panel.dart';

import '../../helpers/pump_app.dart';

void main() {
  /// Pumps a button that opens a confirm dialog; returns the latest result.
  Future<bool? Function()> pumpConfirmLauncher(WidgetTester tester) async {
    bool? result;
    await tester.pumpApp(
      Builder(
        builder: (context) => TextButton(
          onPressed: () async => result = await showAppConfirmDialog(
            context,
            title: 'Delete item?',
            message: 'This cannot be undone.',
            confirmLabel: 'Delete',
            isDestructive: true,
          ),
          child: const Text('open'),
        ),
      ),
    );
    return () => result;
  }

  Future<void> open(WidgetTester tester) async {
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Delete item?'), findsOneWidget);
  }

  testWidgets('confirm dialog resolves true on confirm', (tester) async {
    final result = await pumpConfirmLauncher(tester);
    await open(tester);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(result(), isTrue);
  });

  testWidgets('confirm dialog resolves false on cancel and on close', (
    tester,
  ) async {
    final result = await pumpConfirmLauncher(tester);

    await open(tester);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(result(), isFalse);
    expect(find.text('Delete item?'), findsNothing);

    await open(tester);
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(result(), isFalse);
  });

  testWidgets('confirm dialog stays compact on phones', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpConfirmLauncher(tester);
    await open(tester);
    expect(tester.getSize(find.byType(AppOverlayPanel)).height, lessThan(844));
  });

  group('AppDialog', () {
    Future<Size> openDialog(WidgetTester tester, Size screen) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => const AppDialog(title: 'T', body: Text('body')),
            ),
            child: const Text('open'),
          ),
        ),
        size: screen,
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      return tester.getSize(find.byType(AppOverlayPanel));
    }

    testWidgets('is full screen on phones', (tester) async {
      final size = await openDialog(tester, const Size(390, 844));
      expect(size.width, 390);
    });

    testWidgets('is centered and width-limited on desktop', (tester) async {
      final size = await openDialog(tester, const Size(1440, 1000));
      expect(size.width, lessThanOrEqualTo(620));
    });
  });
}
