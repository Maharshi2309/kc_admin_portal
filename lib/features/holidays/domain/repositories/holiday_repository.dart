import 'package:kc_admin_portal/shared/models/holiday_model.dart';

/// Company holidays. All methods throw an `AppException` on failure.
///
/// Changing a holiday changes attendance, leave days and balances on its
/// dates; the backend recalculates them (docs/DATABASE_V2.md §3.5).
abstract interface class HolidayRepository {
  Future<List<HolidayModel>> list({int? year, String search = ''});

  Future<HolidayModel> getById(String id);

  Future<HolidayModel> create(HolidayInput input);

  Future<HolidayModel> update(String id, HolidayInput input);

  Future<void> delete(String id);
}
