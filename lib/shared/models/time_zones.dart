import 'package:kc_admin_portal/core/config/company_time.dart';
import 'package:timezone/timezone.dart' as tz;

/// Time zones an organization can choose (2026-10-13: the whole IANA
/// database, searchable). "Today", lateness and month boundaries follow the
/// organization's zone (docs/ARCHITECTURE_MULTI_ORG.md §B). IANA ids are
/// sent to the API as is.
typedef TimeZoneOption = ({String id, String label, Duration offset});

/// Friendly names for common zones, so "India" or "Pacific Time" find them.
const Map<String, String> _knownNames = {
  'Pacific/Honolulu': 'Hawaii',
  'America/Anchorage': 'Alaska',
  'America/Los_Angeles': 'Pacific Time (US)',
  'America/Denver': 'Mountain Time (US)',
  'America/Chicago': 'Central Time (US)',
  'America/New_York': 'Eastern Time (US)',
  'America/Sao_Paulo': 'Brazil (São Paulo)',
  'Europe/London': 'United Kingdom',
  'Europe/Paris': 'Central Europe',
  'Africa/Johannesburg': 'South Africa',
  'Africa/Cairo': 'Egypt',
  'Africa/Nairobi': 'East Africa (Nairobi)',
  'Asia/Riyadh': 'Saudi Arabia',
  'Asia/Dubai': 'United Arab Emirates',
  'Asia/Karachi': 'Pakistan',
  'Asia/Kolkata': 'India',
  'Asia/Kathmandu': 'Nepal',
  'Asia/Dhaka': 'Bangladesh',
  'Asia/Bangkok': 'Thailand',
  'Asia/Jakarta': 'Indonesia (Jakarta)',
  'Asia/Singapore': 'Singapore',
  'Asia/Shanghai': 'China',
  'Asia/Tokyo': 'Japan',
  'Australia/Sydney': 'Australia (Sydney)',
  'Pacific/Auckland': 'New Zealand',
};

/// Old names kept in the database as aliases of a current zone
/// (`Asia/Calcutta` is `Asia/Kolkata`): accepted from the server, not offered.
const Set<String> _aliases = {
  'Africa/Asmera',
  'Africa/Timbuktu',
  'America/Argentina/ComodRivadavia',
  'America/Atka',
  'America/Buenos_Aires',
  'America/Catamarca',
  'America/Coral_Harbour',
  'America/Cordoba',
  'America/Ensenada',
  'America/Fort_Wayne',
  'America/Godthab',
  'America/Indianapolis',
  'America/Jujuy',
  'America/Knox_IN',
  'America/Louisville',
  'America/Mendoza',
  'America/Montreal',
  'America/Porto_Acre',
  'America/Rosario',
  'America/Santa_Isabel',
  'America/Shiprock',
  'America/Virgin',
  'Antarctica/South_Pole',
  'Asia/Ashkhabad',
  'Asia/Calcutta',
  'Asia/Chongqing',
  'Asia/Chungking',
  'Asia/Dacca',
  'Asia/Harbin',
  'Asia/Istanbul',
  'Asia/Kashgar',
  'Asia/Katmandu',
  'Asia/Macao',
  'Asia/Rangoon',
  'Asia/Saigon',
  'Asia/Tel_Aviv',
  'Asia/Thimbu',
  'Asia/Ujung_Pandang',
  'Asia/Ulan_Bator',
  'Atlantic/Faeroe',
  'Atlantic/Jan_Mayen',
  'Australia/ACT',
  'Australia/Canberra',
  'Australia/LHI',
  'Australia/NSW',
  'Australia/North',
  'Australia/Queensland',
  'Australia/South',
  'Australia/Tasmania',
  'Australia/Victoria',
  'Australia/West',
  'Australia/Yancowinna',
  'Europe/Belfast',
  'Europe/Kiev',
  'Europe/Nicosia',
  'Europe/Tiraspol',
  'Pacific/Enderbury',
  'Pacific/Johnston',
  'Pacific/Ponape',
  'Pacific/Samoa',
  'Pacific/Truk',
  'Pacific/Yap',
};

final RegExp _regional = RegExp(
  r'^(Africa|America|Antarctica|Asia|Atlantic|Australia|Europe|Indian|Pacific)/',
);

/// "UTC+5:30", "UTC−4", "UTC".
String utcOffsetLabel(Duration offset) {
  final minutes = offset.inMinutes;
  if (minutes == 0) return 'UTC';
  final sign = minutes < 0 ? '−' : '+';
  final hours = minutes.abs() ~/ 60;
  final rest = minutes.abs() % 60;
  return rest == 0
      ? 'UTC$sign$hours'
      : 'UTC$sign$hours:${rest.toString().padLeft(2, '0')}';
}

/// "Kolkata" from `Asia/Kolkata`; "Buenos Aires, Argentina" from
/// `America/Argentina/Buenos_Aires`; "Fort Nelson, America".
String _place(String id) {
  final parts = id.split('/').map((p) => p.replaceAll('_', ' ')).toList();
  return '${parts.last}, ${parts[parts.length - 2]}';
}

/// "India" for a well-known zone, otherwise its city: "Berlin".
String timeZoneShortName(String id) =>
    _knownNames[id] ?? id.split('/').last.replaceAll('_', ' ');

/// "India · Kolkata, Asia · UTC+5:30", "Berlin, Europe · UTC+2". The offset
/// is the one in force on [at] (summer time included).
String timeZoneLabel(String id, {DateTime? at}) {
  CompanyTime.ensureLoaded();
  final location = tz.getLocation(id);
  final offset = tz.TZDateTime.from(
    at ?? DateTime.now(),
    location,
  ).timeZoneOffset;
  final known = _knownNames[id];
  return [?known, _place(id), utcOffsetLabel(offset)].join(' · ');
}

/// Every zone to choose from, west to east, then by name. [include] adds a
/// zone set elsewhere that the list leaves out (an old alias).
List<TimeZoneOption> timeZoneOptions({String? include, DateTime? at}) {
  CompanyTime.ensureLoaded();
  final now = at ?? DateTime.now();
  final ids = {
    for (final id in tz.timeZoneDatabase.locations.keys)
      if (_regional.hasMatch(id) && !_aliases.contains(id)) id,
    if (include != null && CompanyTime.isKnown(include)) include,
  };
  final options = [
    for (final id in ids)
      (
        id: id,
        label: timeZoneLabel(id, at: now),
        offset: tz.TZDateTime.from(now, tz.getLocation(id)).timeZoneOffset,
      ),
  ];
  return options..sort((a, b) {
    final byOffset = a.offset.compareTo(b.offset);
    return byOffset != 0 ? byOffset : a.label.compareTo(b.label);
  });
}

/// A sensible first choice: a well-known zone with the device's current
/// offset (summer time included), else any zone with it. The person can
/// change it. (Devices don't report their zone's name, only its offset.)
String suggestedTimeZone(Duration deviceOffset, {DateTime? at}) {
  CompanyTime.ensureLoaded();
  final now = at ?? DateTime.now();
  bool matches(String id) =>
      tz.TZDateTime.from(now, tz.getLocation(id)).timeZoneOffset ==
      deviceOffset;
  return _knownNames.keys.where(matches).firstOrNull ??
      timeZoneOptions(
        at: now,
      ).where((z) => z.offset == deviceOffset).firstOrNull?.id ??
      CompanyTime.defaultZone;
}
