import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kc_admin_portal/app/dev/component_gallery_screen.dart';
import 'package:kc_admin_portal/app/theme/app_theme.dart';
import 'package:kc_admin_portal/core/widgets/app_side_sheet.dart';

void main() {
  // Renders every core widget from the smallest phone to a large monitor.
  // Any RenderFlex overflow fails the test.
  const sizes = {
    'smallest phone': Size(320, 640),
    'phone': Size(390, 844),
    'tablet': Size(820, 1180),
    'laptop': Size(1280, 800),
    'large desktop': Size(1920, 1080),
  };

  for (final entry in sizes.entries) {
    testWidgets('gallery renders without overflow on ${entry.key}', (
      tester,
    ) async {
      tester.view.physicalSize = entry.value;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const ComponentGalleryScreen(),
        ),
      );

      // Scroll through the whole page so every section is laid out.
      await tester.dragUntilVisible(
        find.text('Error snackbar'),
        find.byType(Scrollable).first,
        const Offset(0, -300),
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('side sheet opens full width on phones', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const ComponentGalleryScreen()),
    );
    await tester.tap(find.text('Side sheet'));
    // The gallery's spinner never settles, so pump past the slide-in.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Field two'), findsOneWidget);
    expect(tester.getSize(find.byType(AppSideSheet)).width, 390);
    expect(tester.takeException(), isNull);
  });
}
