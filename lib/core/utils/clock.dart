import 'dart:ui' show PlatformDispatcher;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/config/company_time.dart';

/// Current time source: company wall-clock time ([CompanyTime]). Read "now"
/// through this provider (not `DateTime.now()`) wherever "today" affects
/// data, so every device agrees on the date and tests can fix it.
final clockProvider = Provider<DateTime Function()>((ref) => CompanyTime.now);

/// This device's current UTC offset (its own time zone), to tell people
/// when the organization's times differ from their clock. Tests fix it.
final deviceUtcOffsetProvider = Provider<Duration Function()>(
  (ref) =>
      () => DateTime.now().timeZoneOffset,
);

extension DateOnly on DateTime {
  /// Midnight at the start of this date.
  DateTime get dateOnly => DateTime(year, month, day);

  /// First day of this date's month.
  DateTime get monthStart => DateTime(year, month);
}

/// This device's region from its language settings (`IN` for en_IN), if
/// it has one: a new organization's first phone country. Tests fix it.
final deviceCountryProvider = Provider<String?>(
  (ref) => PlatformDispatcher.instance.locale.countryCode,
);
