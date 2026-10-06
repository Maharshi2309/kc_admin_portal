import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/network/api_client.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/organization_providers.dart';
import 'package:kc_admin_portal/features/calendar/data/models/calendar_models.dart';
import 'package:kc_admin_portal/shared/mock/mock_tenant.dart';
import 'package:kc_admin_portal/shared/models/json_converters.dart';

/// An employee's calendar over the API. Throws an `AppException` on
/// failure.
abstract interface class CalendarRemoteDataSource {
  Future<EmployeeCalendarModel> month(String employeeId, DateTime month);

  Future<CalendarDayDetailModel> day(String employeeId, DateTime date);
}

class CalendarApiDataSource implements CalendarRemoteDataSource {
  CalendarApiDataSource(this._client);

  final ApiClient _client;

  @override
  Future<EmployeeCalendarModel> month(String employeeId, DateTime month) =>
      _client.get(
        ApiConstants.employeeCalendar(employeeId),
        query: {'month': ApiDateFormat.month(month)},
        parse: (json) =>
            EmployeeCalendarModel.fromJson(json! as Map<String, dynamic>),
      );

  @override
  Future<CalendarDayDetailModel> day(String employeeId, DateTime date) =>
      _client.get(
        ApiConstants.employeeCalendarDay(employeeId, dateToJson(date)),
        parse: (json) =>
            CalendarDayDetailModel.fromJson(json! as Map<String, dynamic>),
      );
}

final calendarRemoteDataSourceProvider = Provider<CalendarRemoteDataSource>((
  ref,
) {
  if (ref.watch(envProvider).useMockApi) {
    return ref.watch(mockActiveTenantProvider).calendar;
  }
  // A new organization means new data: rebuild (docs/ARCHITECTURE_MULTI_ORG.md §C).
  ref.watch(activeOrganizationIdProvider);
  return CalendarApiDataSource(ref.watch(apiClientProvider));
});
