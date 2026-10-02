import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kc_admin_portal/core/widgets/app_dropdown.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('AppTextField shows validator error below the field and clears '
      'it once valid', (tester) async {
    final formKey = GlobalKey<FormState>();
    await tester.pumpApp(
      Form(
        key: formKey,
        child: AppTextField(
          label: 'Name',
          isRequired: true,
          helperText: 'Helper',
          validator: (value) =>
              (value ?? '').isEmpty ? 'Name is required' : null,
        ),
      ),
    );

    expect(find.text('Helper'), findsOneWidget);
    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('Name is required'), findsOneWidget);
    expect(find.text('Helper'), findsNothing);

    await tester.enterText(find.byType(TextField), 'Aarav');
    expect(formKey.currentState!.validate(), isTrue);
    await tester.pump();
    expect(find.text('Name is required'), findsNothing);
  });

  testWidgets('AppTextField validates programmatic controller changes', (
    tester,
  ) async {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpApp(
      Form(
        key: formKey,
        child: AppTextField(
          controller: controller,
          validator: (value) => (value ?? '').isEmpty ? 'Required' : null,
        ),
      ),
    );

    controller.text = 'filled in code';
    expect(formKey.currentState!.validate(), isTrue);
  });

  testWidgets('password field toggles visibility', (tester) async {
    await tester.pumpApp(
      const AppTextField(label: 'Password', isPassword: true),
    );

    TextField field() => tester.widget<TextField>(find.byType(TextField));
    expect(field().obscureText, isTrue);

    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();
    expect(field().obscureText, isFalse);
  });

  group('AppDropdown with options that load later', () {
    Widget dropdown(List<String> options, {String? value}) =>
        AppDropdown<String>(
          label: 'Department',
          hintText: 'Select department',
          value: value,
          searchable: true,
          items: [for (final o in options) AppDropdownItem(value: o, label: o)],
          onChanged: (_) {},
        );

    testWidgets('an open menu stays open when the options arrive', (
      tester,
    ) async {
      var options = <String>[];
      late StateSetter setOptions;
      await tester.pumpApp(
        StatefulBuilder(
          builder: (context, setState) {
            setOptions = setState;
            return dropdown(options);
          },
        ),
      );
      await tester.tap(find.byType(DropdownMenu<String>));
      await tester.pumpAndSettle();

      setOptions(() => options = ['IT', 'Sales']);
      await tester.pumpAndSettle();
      expect(find.text('Sales'), findsWidgets);

      await tester.tap(find.text('Sales').last);
      await tester.pumpAndSettle();
    });

    testWidgets('a saved value shows once its options arrive', (tester) async {
      var options = <String>[];
      late StateSetter setOptions;
      await tester.pumpApp(
        StatefulBuilder(
          builder: (context, setState) {
            setOptions = setState;
            return dropdown(options, value: 'Sales');
          },
        ),
      );
      String shown() => tester
          .widget<TextField>(
            find.descendant(
              of: find.byType(DropdownMenu<String>),
              matching: find.byType(TextField),
            ),
          )
          .controller!
          .text;
      expect(shown(), '');

      setOptions(() => options = ['IT', 'Sales']);
      await tester.pumpAndSettle();
      expect(shown(), 'Sales');
    });
  });
}
