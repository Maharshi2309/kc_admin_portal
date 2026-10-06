abstract final class AppConstants {
  static const String appName = 'Keshav Admin Portal';

  /// Used in page titles ("Employees · Keshav Admin"), as in the design.
  static const String appShortName = 'Keshav Admin';

  /// TODO — REQUIREMENT CONFIRMATION REQUIRED: password rules for new
  /// accounts; assumed at least 8 characters. The server decides.
  static const int passwordMinLength = 8;

  /// Length of the codes emailed to verify an address or reset a password.
  static const int emailCodeLength = 6;
}
