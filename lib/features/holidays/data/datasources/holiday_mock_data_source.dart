import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_guard.dart';
import 'package:kc_admin_portal/features/holidays/data/datasources/holiday_remote_data_source.dart';
import 'package:kc_admin_portal/features/holidays/data/datasources/mock_holiday_store.dart';
import 'package:kc_admin_portal/shared/models/holiday_model.dart';

/// DEV ONLY (`USE_MOCK_API=true`): the holiday endpoints over
/// [MockHolidayStore].
class HolidayMockDataSource implements HolidayRemoteDataSource {
  /// Checks the signed-in user's permissions, like the backend (§4.2).
  final MockGuard guard;

  HolidayMockDataSource({
    this.guard = const MockGuard.allowAll(),
    required this.store,
    this.latency = Duration.zero,
  });

  final MockHolidayStore store;
  final Duration latency;

  Future<void> _wait() => Future<void>.delayed(latency);

  @override
  Future<List<HolidayModel>> list({int? year, String search = ''}) async {
    await _wait();
    guard.require(AppPermission.holidayView);
    return store.list(year: year, search: search);
  }

  @override
  Future<HolidayModel> getById(String id) async {
    await _wait();
    guard.require(AppPermission.holidayView);
    return store.byId(id);
  }

  @override
  Future<HolidayModel> create(HolidayInput input) async {
    await _wait();
    guard.require(AppPermission.holidayCreate);
    return store.create(input);
  }

  @override
  Future<HolidayModel> update(String id, HolidayInput input) async {
    await _wait();
    guard.require(AppPermission.holidayEdit);
    return store.update(id, input);
  }

  @override
  Future<void> delete(String id) async {
    await _wait();
    guard.require(AppPermission.holidayDelete);
    store.delete(id);
  }
}
