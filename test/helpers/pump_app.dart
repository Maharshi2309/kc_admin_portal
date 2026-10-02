import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kc_admin_portal/app/theme/app_theme.dart';

extension PumpApp on WidgetTester {
  /// Pumps [child] inside a themed [MaterialApp] and [Scaffold].
  Future<void> pumpApp(Widget child, {Size? size}) async {
    if (size != null) {
      view.physicalSize = size;
      view.devicePixelRatio = 1;
      addTearDown(view.reset);
    }
    await pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(body: child),
      ),
    );
  }
}
