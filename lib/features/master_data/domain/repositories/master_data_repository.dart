import 'package:kc_admin_portal/features/master_data/data/models/master_data_models.dart';

/// Reference lists used by forms and filters.
abstract interface class MasterDataRepository {
  Future<List<DepartmentModel>> departments();

  Future<List<DesignationModel>> designations(String departmentId);
}
