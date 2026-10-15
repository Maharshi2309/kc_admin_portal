/// Reusable form validators returning a user-facing message, or `null` when
/// valid. They only check the shape of input; the backend stays the
/// authority on business rules (e.g. EC number uniqueness).
abstract final class Validators {
  static final RegExp _email = RegExp(
    r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+$",
  );

  static String? required(String? value, {String field = 'This field'}) =>
      (value == null || value.trim().isEmpty) ? '$field is required' : null;

  static String? email(String? value) {
    final missing = required(value, field: 'Email address');
    if (missing != null) return missing;
    return _email.hasMatch(value!.trim())
        ? null
        : 'Enter a valid email address';
  }

  /// The organization's [prefix] (Settings, e.g. "KC") directly followed
  /// by digits. Without the prefix (settings not loaded) any letters do.
  static String? ecNumber(String? value, {String? prefix}) {
    final missing = required(value, field: 'EC number');
    if (missing != null) return missing;
    final letters = prefix == null ? '[A-Z]*' : RegExp.escape(prefix);
    if (RegExp('^$letters\\d+\$').hasMatch(value!.trim())) return null;
    return prefix == null || prefix.isEmpty
        ? 'Use numbers, e.g. 1001'
        : 'Use $prefix followed by numbers, e.g. ${prefix}1001';
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
