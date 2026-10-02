import 'package:flutter_test/flutter_test.dart';

import 'package:kc_admin_portal/core/utils/validation_utils.dart';

void main() {
  test('required', () {
    expect(Validators.required(null), 'This field is required');
    expect(Validators.required('  ', field: 'Name'), 'Name is required');
    expect(Validators.required('x'), isNull);
  });

  test('email', () {
    expect(Validators.email(''), 'Email address is required');
    expect(Validators.email('not-an-email'), 'Enter a valid email address');
    expect(Validators.email('admin@keshav'), 'Enter a valid email address');
    expect(Validators.email(' admin@keshav.in '), isNull);
  });

  test('combine returns the first error', () {
    final validate = Validators.combine([
      Validators.required,
      (value) => value!.length < 3 ? 'Too short' : null,
    ]);
    expect(validate(''), 'This field is required');
    expect(validate('ab'), 'Too short');
    expect(validate('abc'), isNull);
  });
}
