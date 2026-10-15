import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// The organization's time zone, used for every date and time in the portal
/// (approved 2026-09-30, per organization since 2026-10-13): "today", punch
/// times, schedules and the times shown on screen are all organization
/// wall-clock time, whatever the device's zone.
///
/// Wall-clock values are plain (non-UTC) `DateTime`s whose fields are the
/// organization's local date and time. Instants from the API are converted
/// with [fromInstant]; values sent back get [offsetTextAt].
///
/// The zone is the active organization's ([use], called by
/// `activeTimeZoneProvider`), with daylight saving from the IANA database.
abstract final class CompanyTime {
  /// Used until an organization is open, and for an organization without a
  /// zone (an older server): the portal's original zone.
  static const String defaultZone = 'Asia/Kolkata';

  static bool _loaded = false;
  static tz.Location? _location;

  /// Loads the zone database once (it's bundled; no network).
  static void ensureLoaded() {
    if (_loaded) return;
    tz_data.initializeTimeZones();
    _loaded = true;
  }

  static tz.Location get _active {
    ensureLoaded();
    return _location ??= tz.getLocation(defaultZone);
  }

  /// Whether [zoneName] is a zone the database knows.
  static bool isKnown(String? zoneName) {
    ensureLoaded();
    return zoneName != null &&
        tz.timeZoneDatabase.locations.containsKey(zoneName);
  }

  /// Works in [zoneName] from now on. Unknown or null: [defaultZone].
  static void use(String? zoneName) {
    ensureLoaded();
    _location = tz.getLocation(isKnown(zoneName) ? zoneName! : defaultZone);
  }

  /// The IANA name of the zone in use, e.g. `Asia/Kolkata`.
  static String get zoneName => _active.name;

  /// The current organization wall-clock time.
  static DateTime now() => fromInstant(DateTime.now());

  /// The organization wall-clock time at [instant] (any zone, or UTC).
  static DateTime fromInstant(DateTime instant) =>
      _wall(tz.TZDateTime.from(instant, _active));

  /// The UTC offset in force at the wall-clock time [wall] (it changes
  /// with daylight saving).
  static Duration offsetAt(DateTime wall) => tz.TZDateTime(
    _active,
    wall.year,
    wall.month,
    wall.day,
    wall.hour,
    wall.minute,
    wall.second,
    wall.millisecond,
  ).timeZoneOffset;

  /// The UTC offset in force now.
  static Duration get currentOffset =>
      tz.TZDateTime.now(_active).timeZoneOffset;

  /// `+05:30` for [wall], as sent with times to the API.
  static String offsetTextAt(DateTime wall) => formatOffset(offsetAt(wall));

  /// `+05:30`, `-04:00`.
  static String formatOffset(Duration offset) {
    final sign = offset.isNegative ? '-' : '+';
    final hours = offset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (offset.inMinutes.abs() % Duration.minutesPerHour)
        .toString()
        .padLeft(2, '0');
    return '$sign$hours:$minutes';
  }

  static DateTime _wall(tz.TZDateTime t) => DateTime(
    t.year,
    t.month,
    t.day,
    t.hour,
    t.minute,
    t.second,
    t.millisecond,
  );
}
