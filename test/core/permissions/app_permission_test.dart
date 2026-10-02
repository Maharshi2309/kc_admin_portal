import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';

void main() {
  test('every permission has a unique module.action key', () {
    final keys = AppPermission.values.map((p) => p.key).toList();
    expect(keys.toSet(), hasLength(keys.length));
    for (final key in keys) {
      expect(key, matches(RegExp(r'^[a-z]+\.[a-z_]+$')), reason: key);
    }
  });

  test('keys map back to permissions; unknown keys are ignored', () {
    expect(AppPermission.fromKey('leave.approve'), AppPermission.leaveApprove);
    expect(AppPermission.fromKey('payroll.run'), isNull);
    expect(
      AppPermission.parseAll(['holiday.view', 'payroll.run', 'holiday.view']),
      {AppPermission.holidayView},
    );
  });
}
