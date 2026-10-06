import 'package:kc_admin_portal/features/organization/data/models/organization_models.dart';
import 'package:kc_admin_portal/shared/mock/mock_session.dart';
import 'package:kc_admin_portal/shared/models/clock_time.dart';
import 'package:kc_admin_portal/shared/models/named_ref.dart';

/// DEV ONLY: each sample organization's starting departments, positions
/// and settings. Keshav Clothing keeps its approved list (Accountant,
/// Graphic Designer, Tailor for both, 2026-10-05); Sunrise Garments has
/// different ones, so nothing in the app can assume one list.
abstract final class MockCatalogs {
  static List<CatalogItemModel> of(String organizationId, CatalogKind kind) {
    final names = switch ((organizationId, kind)) {
      (MockSession.keshavId, _) => _keshav,
      (MockSession.sunriseId, CatalogKind.departments) => _sunriseDepartments,
      (MockSession.sunriseId, CatalogKind.positions) => _sunrisePositions,
      _ => const <String>[],
    };
    return [
      for (final name in names)
        CatalogItemModel(id: idFor(organizationId, kind, name), name: name),
    ];
  }

  static const List<String> _keshav = [
    'Accountant',
    'Graphic Designer',
    'Tailor',
  ];
  static const List<String> _sunriseDepartments = [
    'Accounts',
    'Design',
    'Stitching',
  ];
  static const List<String> _sunrisePositions = [
    'Accountant',
    'Designer',
    'Tailor',
  ];

  /// Stable sample ids, e.g. `keshav-dep-graphic-designer`.
  static String idFor(String organizationId, CatalogKind kind, String name) {
    final org = organizationId.replaceFirst('org-', '');
    final type = kind == CatalogKind.departments ? 'dep' : 'pos';
    final slug = name.toLowerCase().replaceAll(RegExp('[^a-z0-9]+'), '-');
    return '$org-$type-$slug';
  }

  /// A sample organization's item by name, e.g. for the seeded employees.
  static NamedRef ref(String organizationId, CatalogKind kind, String name) =>
      NamedRef(id: idFor(organizationId, kind, name), name: name);

  /// Each sample organization's leave policy. Keshav: "Casual", 1 day a
  /// month from January 2026, no cap (approved 2026-10-05). Sunrise:
  /// "Paid leave", 1.5 days a month, at most 12 days. A new organization
  /// gets the one-tap preset (1 paid day a month from its first month, no
  /// cap), or unpaid leave only.
  static LeavePolicyModel leavePolicy(
    String organizationId, {
    required DateTime now,
    bool paidLeave = true,
  }) => switch (organizationId) {
    MockSession.keshavId => LeavePolicyModel(
      paidLeaveEnabled: true,
      paidLeaveName: 'Casual',
      unpaidLeaveName: 'Unpaid',
      daysPerMonth: 1,
      accrualStartMonth: DateTime(2026),
    ),
    MockSession.sunriseId => LeavePolicyModel(
      paidLeaveEnabled: true,
      paidLeaveName: 'Paid leave',
      unpaidLeaveName: 'Unpaid leave',
      daysPerMonth: 1.5,
      carryForwardCap: 12,
      accrualStartMonth: DateTime(2026),
    ),
    _ => LeavePolicyModel(
      paidLeaveEnabled: paidLeave,
      paidLeaveName: 'Paid leave',
      unpaidLeaveName: 'Unpaid leave',
      daysPerMonth: 1,
      accrualStartMonth: DateTime(now.year, now.month),
    ),
  };

  /// Keshav's EC numbers start with `KC`. New organizations start with
  /// `EMP` and can change it in Settings.
  ///
  /// TODO — REQUIREMENT CONFIRMATION REQUIRED: the default prefix for new
  /// organizations.
  static OrganizationSettingsModel settings(String organizationId) =>
      OrganizationSettingsModel(
        ecNumberPrefix: switch (organizationId) {
          MockSession.keshavId => 'KC',
          MockSession.sunriseId => 'SG',
          _ => 'EMP',
        },
        lateGraceMinutes: 15,
        defaultSchedule: const DefaultScheduleModel(
          startTime: ClockTime.hm(9, 30),
          endTime: ClockTime.hm(18, 30),
          breakMinutes: 60,
          weeklyOffDays: [DateTime.sunday],
        ),
      );
}
