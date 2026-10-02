import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_segmented_control.dart';

import '../../helpers/pump_app.dart';

/// Web and desktop admins can work the portal from the keyboard: every
/// control is reachable with Tab, shows where focus is, and activates with
/// Enter or Space.
void main() {
  testWidgets('a clickable card opens with Enter and shows focus', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpApp(
      Center(
        child: AppCard(
          onTap: () => taps++,
          semanticLabel: 'Total employees',
          child: const Text('Total employees'),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    final outline = tester
        .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
        .map((c) => c.foregroundDecoration)
        .whereType<BoxDecoration>()
        .single
        .border;
    expect(outline, isNotNull);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(taps, 2);
  });

  testWidgets('segments are reachable with Tab and chosen with Space', (
    tester,
  ) async {
    var selected = 'full';
    await tester.pumpApp(
      StatefulBuilder(
        builder: (context, setState) => AppSegmentedControl<String>(
          segments: const [
            AppSegment(value: 'full', label: 'Full day'),
            AppSegment(value: 'half', label: 'Half day'),
          ],
          selected: selected,
          onChanged: (value) => setState(() => selected = value),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(selected, 'half');
  });

  testWidgets('a button focused from the keyboard draws an outline', (
    tester,
  ) async {
    await tester.pumpApp(
      Center(
        child: AppButton(label: 'Save employee', onPressed: () {}),
      ),
    );
    BorderSide side() {
      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(FilledButton),
          matching: find.byType(Material),
        ),
      );
      return (material.shape! as OutlinedBorder).side;
    }

    expect(side(), BorderSide.none);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(side().color, AppColors.inverse);
  });
}
