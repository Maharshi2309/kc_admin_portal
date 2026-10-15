import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kc_admin_portal/core/utils/phone_utils.dart';
import 'package:kc_admin_portal/shared/models/clock_time.dart';
import 'package:kc_admin_portal/shared/models/json_converters.dart';

part 'organization_models.freezed.dart';
part 'organization_models.g.dart';

/// The organization's own lists (2026-10-06): its **departments** and its
/// **positions**. An employee's position is their job, not their access to
/// the app (that's their permissions).
enum CatalogKind {
  departments('Department', 'Departments'),
  positions('Position', 'Positions');

  const CatalogKind(this.singular, this.plural);

  final String singular;
  final String plural;
}

/// One department or position of the organization
/// (`GET /departments`, `GET /positions`). Deactivated items stay on the
/// employees who have them but can't be chosen for new ones.
@freezed
abstract class CatalogItemModel with _$CatalogItemModel {
  const factory CatalogItemModel({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,
    @Default(true) bool isActive,

    /// Employees who have it, active or not; shown before deactivating.
    @Default(0) int employeeCount,
  }) = _CatalogItemModel;

  factory CatalogItemModel.fromJson(Map<String, dynamic> json) =>
      _$CatalogItemModelFromJson(json);
}

/// The organization's working defaults (`GET /organization/settings`).
/// Only what the app uses now; more can be added without restructuring
/// (docs/ARCHITECTURE_MULTI_ORG.md §F).
@freezed
abstract class OrganizationSettingsModel with _$OrganizationSettingsModel {
  const factory OrganizationSettingsModel({
    /// Letters every EC number starts with, e.g. `KC` for `KC1001`.
    required String ecNumberPrefix,

    /// Minutes after the scheduled start before a punch-in counts as late.
    required int lateGraceMinutes,

    /// Starting values for a new employee's working schedule.
    required DefaultScheduleModel defaultSchedule,

    /// ISO country code (e.g. `IN`) for mobile numbers written without a
    /// country code, and the one the mobile field starts on (2026-10-13).
    /// Missing (older server): India.
    @Default(PhoneUtils.defaultCountry) String defaultCountry,
  }) = _OrganizationSettingsModel;

  factory OrganizationSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$OrganizationSettingsModelFromJson(json);
}

/// A working schedule without dates: the organization's default.
@freezed
abstract class DefaultScheduleModel with _$DefaultScheduleModel {
  const factory DefaultScheduleModel({
    @ClockTimeConverter() required ClockTime startTime,
    @ClockTimeConverter() required ClockTime endTime,
    required int breakMinutes,
    @ClockTimeConverter() ClockTime? breakStart,

    /// ISO weekdays (1 = Monday … 7 = Sunday).
    required List<int> weeklyOffDays,
  }) = _DefaultScheduleModel;

  factory DefaultScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$DefaultScheduleModelFromJson(json);
}

/// The organization's leave policy (`GET /organization/leave-policy`,
/// 2026-10-06): one paid leave type that earns days every month, and one
/// unpaid type. Keshav Clothing: "Casual", 1 day a month, carried forward
/// without a cap, from January 2026. Leave beyond the paid balance can be
/// saved as unpaid; a later month's days can never be used early.
@freezed
abstract class LeavePolicyModel with _$LeavePolicyModel {
  const factory LeavePolicyModel({
    /// Off: the organization only has unpaid leave.
    required bool paidLeaveEnabled,
    required String paidLeaveName,
    required String unpaidLeaveName,

    /// Paid days earned each month (0.5 steps).
    required double daysPerMonth,

    /// The most days the balance can hold; null for no limit.
    double? carryForwardCap,

    /// The first month that earns days (employees who join later start in
    /// their joining month).
    @DateOnlyConverter() required DateTime accrualStartMonth,
  }) = _LeavePolicyModel;

  factory LeavePolicyModel.fromJson(Map<String, dynamic> json) =>
      _$LeavePolicyModelFromJson(json);
}
