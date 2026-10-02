import 'package:flutter_test/flutter_test.dart';

import 'package:kc_admin_portal/core/utils/format_utils.dart';

void main() {
  group('FormatUtils.initials', () {
    test('uses first and last name', () {
      expect(FormatUtils.initials('Aarav Shah'), 'AS');
      expect(FormatUtils.initials('Aarav Kumar Shah'), 'AS');
    });

    test('handles single names, extra spaces and case', () {
      expect(FormatUtils.initials('priya'), 'P');
      expect(FormatUtils.initials('  meera   rathod '), 'MR');
    });

    test('returns empty string for blank input', () {
      expect(FormatUtils.initials('   '), '');
    });
  });
}
