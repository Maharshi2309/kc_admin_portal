import 'package:kc_admin_portal/shared/models/list_entry.dart';

abstract interface class MasterDataRepository {
  /// Department codes from `GET /departments`, cached for the session.
  Future<List<ListEntry>> departments();

  /// Position codes from `GET /positions`, cached for the session.
  Future<List<ListEntry>> positions();
}
