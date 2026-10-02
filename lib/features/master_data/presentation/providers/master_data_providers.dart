import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/features/master_data/data/models/master_data_models.dart';
import 'package:kc_admin_portal/features/master_data/data/repositories/master_data_repository_impl.dart';

/// All departments. Kept for the session: the list rarely changes and is
/// used by several screens.
final departmentsProvider = FutureProvider<List<DepartmentModel>>(
  (ref) => ref.watch(masterDataRepositoryProvider).departments(),
  retry: (_, _) => null,
);

/// Designations of one department (the designation picker only offers
/// those of the chosen department, as in the design).
final designationsProvider =
    FutureProvider.family<List<DesignationModel>, String>(
      (ref, departmentId) =>
          ref.watch(masterDataRepositoryProvider).designations(departmentId),
      retry: (_, _) => null,
    );
