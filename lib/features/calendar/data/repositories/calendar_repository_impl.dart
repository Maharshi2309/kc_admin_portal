import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/features/calendar/data/datasources/calendar_remote_data_source.dart';
import 'package:kc_admin_portal/features/calendar/data/models/calendar_models.dart';
import 'package:kc_admin_portal/features/calendar/domain/repositories/calendar_repository.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  CalendarRepositoryImpl(this._remote);

  final CalendarRemoteDataSource _remote;

  @override
  Future<EmployeeCalendarModel> month(String employeeId, DateTime month) =>
      _remote.month(employeeId, month);

  @override
  Future<CalendarDayDetailModel> day(String employeeId, DateTime date) =>
      _remote.day(employeeId, date);
}

final calendarRepositoryProvider = Provider<CalendarRepository>(
  (ref) => CalendarRepositoryImpl(ref.watch(calendarRemoteDataSourceProvider)),
);
