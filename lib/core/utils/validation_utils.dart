/// Reusable form validators returning a user-facing message, or `null` when
/// valid. They only check the shape of input; the backend stays the
/// authority on business rules (e.g. EC number uniqueness).
abstract final class Validators {
  static final RegExp _email = RegExp(
    r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+$",
  );

  /// Client rule (confirmed 2026-09-29): "KC" directly followed by digits.
  static final RegExp _ecNumber = RegExp(r'^KC\d+$');

  /// Design: 10-digit mobile number entered after a fixed "+91" prefix.
  static final RegExp _mobile = RegExp(r'^\d{10}$');

  static String? required(String? value, {String field = 'This field'}) =>
      (value == null || value.trim().isEmpty) ? '$field is required' : null;

  static String? email(String? value) {
    final missing = required(value, field: 'Email address');
    if (missing != null) return missing;
    return _email.hasMatch(value!.trim())
        ? null
        : 'Enter a valid email address';
  }

  static String? ecNumber(String? value) {
    final missing = required(value, field: 'EC number');
    if (missing != null) return missing;
    return _ecNumber.hasMatch(value!.trim())
        ? null
        : 'Use KC followed by numbers, e.g. KC1001';
  }

  static String? mobile(String? value) {
    final missing = required(value, field: 'Mobile number');
    if (missing != null) return missing;
    return _mobile.hasMatch(value!.trim())
        ? null
        : 'Enter a 10-digit mobile number';
  }

  /// Required check for non-text values (dropdowns, dates).
  static String? Function(T?) requiredValue<T>(String field) =>
      (value) => value == null ? '$field is required' : null;

  /// Runs [validators] in order and returns the first error.
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) => (value) {
    for (final validate in validators) {
      final error = validate(value);
      if (error != null) return error;
    }
    return null;
  };
}
