import 'package:flutter_test/flutter_test.dart';

import 'package:kc_admin_portal/core/responsive/app_breakpoints.dart';
import 'package:kc_admin_portal/core/responsive/responsive_utils.dart';
import 'package:kc_admin_portal/core/widgets/responsive_grid.dart';

void main() {
  group('ScreenSize.fromWidth', () {
    test('maps boundaries to the larger size', () {
      expect(ScreenSize.fromWidth(320), ScreenSize.mobile);
      expect(ScreenSize.fromWidth(599.9), ScreenSize.mobile);
      expect(ScreenSize.fromWidth(600), ScreenSize.tablet);
      expect(ScreenSize.fromWidth(1023), ScreenSize.tablet);
      expect(ScreenSize.fromWidth(1024), ScreenSize.desktop);
      expect(ScreenSize.fromWidth(1440), ScreenSize.largeDesktop);
      expect(ScreenSize.fromWidth(double.infinity), ScreenSize.largeDesktop);
    });
  });

  group('ResponsiveValue', () {
    test('falls back to the next smaller defined size', () {
      const value = ResponsiveValue(mobile: 1, desktop: 3);
      expect(value.resolve(ScreenSize.mobile), 1);
      expect(value.resolve(ScreenSize.tablet), 1);
      expect(value.resolve(ScreenSize.desktop), 3);
      expect(value.resolve(ScreenSize.largeDesktop), 3);
    });
  });

  group('ResponsiveGrid.columnsFor', () {
    int columns(double width, {int items = 8}) => ResponsiveGrid.columnsFor(
      width: width,
      minItemWidth: 200,
      spacing: 16,
      maxColumns: 4,
      itemCount: items,
    );

    test('fits as many columns as possible up to the cap', () {
      expect(columns(150), 1);
      expect(columns(415), 1);
      expect(columns(416), 2); // 200 + 16 + 200
      expect(columns(1200), 4);
      expect(columns(3000), 4);
    });

    test('balances rows instead of leaving a lone item', () {
      expect(columns(700, items: 4), 2); // 3 fit → 2 + 2, not 3 + 1
      expect(columns(1200, items: 5), 3); // 4 fit → 3 + 2, not 4 + 1
      expect(columns(1200, items: 4), 4);
    });
  });
}
