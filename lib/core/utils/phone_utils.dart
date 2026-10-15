import 'package:kc_admin_portal/core/utils/countries.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

/// A country to choose for phone numbers: "India", code `IN`, dial `91`.
typedef PhoneCountry = ({String code, String name, String dialCode});

/// Mobile numbers in any country (2026-10-13).
///
/// - Stored and sent in international form: `+919825011234`.
/// - A number without "+" (records from before, typed digits, Excel) is
///   read in the organization's default country, so `9825011234` and
///   `09825011234` are `+919825011234` in an organization based in India.
/// - Only valid **mobile** numbers for their country are accepted.
abstract final class PhoneUtils {
  /// The portal's original country, and the default for an organization
  /// without one (an older server).
  static const String defaultCountry = 'IN';

  static final RegExp _separators = RegExp(r'[\s\-().\/]');

  static IsoCode? _iso(String? code) =>
      IsoCode.values.asNameMap()[code?.trim().toUpperCase()];

  /// Whether [code] is a country this app knows (ISO 3166 alpha-2).
  static bool isCountry(String? code) => _iso(code) != null;

  /// "91" for India.
  static String dialCode(String country) =>
      PhoneNumber(isoCode: _iso(country) ?? IsoCode.IN, nsn: '').countryCode;

  /// One country, e.g. `(code: 'IN', name: 'India', dialCode: '91')`.
  static PhoneCountry country(String code) {
    final iso = (_iso(code) ?? IsoCode.IN).name;
    return (code: iso, name: countryNames[iso] ?? iso, dialCode: dialCode(iso));
  }

  /// Every country, by name.
  static final List<PhoneCountry> countries = [
    for (final iso in IsoCode.values) country(iso.name),
  ]..sort((a, b) => a.name.compareTo(b.name));

  /// "India (+91)".
  static String countryLabel(String code) {
    final c = country(code);
    return '${c.name} (+${c.dialCode})';
  }

  /// [raw] read as a phone number: with "+" (or "00") in its own country,
  /// otherwise in [country]. Null when it isn't a number at all.
  static PhoneNumber? parse(String? raw, {required String country}) {
    var text = (raw ?? '').trim().replaceAll(_separators, '');
    if (text.isEmpty) return null;
    if (text.startsWith('00')) text = '+${text.substring(2)}';
    if (!RegExp(r'^\+?\d+$').hasMatch(text)) return null;
    try {
      return text.startsWith('+')
          ? PhoneNumber.parse(text)
          : PhoneNumber.parse(
              text,
              callerCountry: _iso(country),
              destinationCountry: _iso(country),
            );
    } on Object {
      return null;
    }
  }

  static bool _isMobile(PhoneNumber? number) =>
      number != null &&
      number.nsn.isNotEmpty &&
      number.isValid(type: PhoneNumberType.mobile);

  /// The international form to store (`+919825011234`), or null when [raw]
  /// isn't a valid mobile number.
  static String? toStored(String? raw, {required String country}) {
    final number = parse(raw, country: country);
    return _isMobile(number) ? number!.international : null;
  }

  /// A form error for [raw], or null when it's a valid mobile number (or
  /// empty and not [required]).
  static String? validate(
    String? raw, {
    required String country,
    bool required = true,
  }) {
    if ((raw ?? '').trim().isEmpty) {
      return required ? 'Mobile number is required' : null;
    }
    final number = parse(raw, country: country);
    if (_isMobile(number)) return null;
    final where = number == null ? country : number.isoCode.name;
    return 'Enter a valid mobile number for ${PhoneUtils.country(where).name}';
  }

  /// The country of a stored number, or [fallback] when it has none.
  static String countryOf(String? stored, {required String fallback}) {
    final number = parse(stored, country: fallback);
    return number == null || number.nsn.isEmpty
        ? fallback
        : number.isoCode.name;
  }

  /// The digits after the country code (`9825011234`), for editing next to
  /// a country picker. Unreadable values come back as they are.
  static String nationalDigits(String? stored, {required String country}) {
    final number = parse(stored, country: country);
    return number == null || number.nsn.isEmpty ? (stored ?? '') : number.nsn;
  }

  /// "+91 98250 11234", "+1 415-555-0132". Values that can't be read are
  /// shown as they are.
  static String format(String stored, {required String country}) {
    final number = parse(stored, country: country);
    if (number == null || !number.isValid()) return stored;
    return '+${number.countryCode} '
        '${number.formatNsn(format: NsnFormat.international)}';
  }
}
