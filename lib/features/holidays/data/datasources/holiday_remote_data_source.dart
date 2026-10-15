import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/network/api_client.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/organization_providers.dart';
import 'package:kc_admin_portal/shared/mock/mock_tenant.dart';
import 'package:kc_admin_portal/shared/models/holiday_model.dart';

/// Company holidays over the API. All methods throw an `AppException` on
/// failure.
abstract interface class HolidayRemoteDataSource {
  Future<List<HolidayModel>> list({int? year, String search = ''});

  Future<HolidayModel> getById(String id);

  Future<HolidayModel> create(HolidayInput input);

  Future<HolidayModel> update(String id, HolidayInput input);

  Future<void> delete(String id);
}

class HolidayApiDataSource implements HolidayRemoteDataSource {
  HolidayApiDataSource(this._client);

  final ApiClient _client;

  static HolidayModel _holiday(Object? json) =>
      HolidayModel.fromJson(json! as Map<String, dynamic>);

  @override
  Future<List<HolidayModel>> list({int? year, String search = ''}) =>
      _client.get(
        ApiConstants.holidays,
        query: {
          'year': ?year,
          if (search.trim().isNotEmpty) 'search': search.trim(),
        },
        parse: (json) => (json! as List).map(_holiday).toList(),
      );

  @override
  Future<HolidayModel> getById(String id) =>
      _client.get(ApiConstants.holiday(id), parse: _holiday);

  @override
  Future<HolidayModel> create(HolidayInput input) => _client.post(
    ApiConstants.holidays,
    body: input.toJson(),
    parse: _holiday,
  );

  @override
  Future<HolidayModel> update(String id, HolidayInput input) => _client.patch(
    ApiConstants.holiday(id),
    body: input.toJson(),
    parse: _holiday,
  );

  @override
  Future<void> delete(String id) =>
      _client.delete(ApiConstants.holiday(id), parse: ApiClient.ignoreBody);
}

final holidayRemoteDataSourceProvider = Provider<HolidayRemoteDataSource>((
  ref,
) {
  if (ref.watch(envProvider).useMockApi) {
    return ref.watch(mockActiveTenantProvider).holidaySource;
  }
  // A new organization means new data: rebuild (docs/ARCHITECTURE_MULTI_ORG.md §C).
  ref.watch(activeOrganizationScopeProvider);
  return HolidayApiDataSource(ref.watch(apiClientProvider));
});
