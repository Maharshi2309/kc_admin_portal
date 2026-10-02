import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/features/holidays/data/datasources/holiday_remote_data_source.dart';
import 'package:kc_admin_portal/features/holidays/domain/repositories/holiday_repository.dart';
import 'package:kc_admin_portal/shared/models/holiday_model.dart';

class HolidayRepositoryImpl implements HolidayRepository {
  HolidayRepositoryImpl(this._remote);

  final HolidayRemoteDataSource _remote;

  @override
  Future<List<HolidayModel>> list({int? year, String search = ''}) =>
      _remote.list(year: year, search: search);

  @override
  Future<HolidayModel> getById(String id) => _remote.getById(id);

  @override
  Future<HolidayModel> create(HolidayInput input) =>
      _remote.create(_trimmed(input));

  @override
  Future<HolidayModel> update(String id, HolidayInput input) =>
      _remote.update(id, _trimmed(input));

  @override
  Future<void> delete(String id) => _remote.delete(id);

  /// Trims text; an empty description is sent as null.
  static HolidayInput _trimmed(HolidayInput input) {
    final description = input.description?.trim();
    return input.copyWith(
      name: input.name.trim(),
      description: description == null || description.isEmpty
          ? null
          : description,
    );
  }
}

final holidayRepositoryProvider = Provider<HolidayRepository>(
  (ref) => HolidayRepositoryImpl(ref.watch(holidayRemoteDataSourceProvider)),
);
