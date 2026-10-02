import 'package:kc_admin_portal/features/access_control/data/datasources/mock_guard.dart';
import 'package:kc_admin_portal/features/master_data/data/datasources/master_data_remote_data_source.dart';
import 'package:kc_admin_portal/features/master_data/data/models/master_data_models.dart';

/// DEV ONLY (`USE_MOCK_API=true`): sample departments and designations taken
/// from the design. The real lists come from the backend.
class MasterDataMockDataSource implements MasterDataRemoteDataSource {
  /// Checks the signed-in user's permissions, like the backend (§4.2).
  final MockGuard guard;

  MasterDataMockDataSource({
    this.guard = const MockGuard.allowAll(),
    this.latency = Duration.zero,
  });

  final Duration latency;

  static const List<DepartmentModel> sampleDepartments = [
    DepartmentModel(id: 'accounts', name: 'Accounts', employeeCount: 18),
    DepartmentModel(id: 'hr', name: 'HR', employeeCount: 6),
    DepartmentModel(id: 'it', name: 'IT', employeeCount: 22),
    DepartmentModel(id: 'operations', name: 'Operations', employeeCount: 41),
    DepartmentModel(id: 'sales', name: 'Sales', employeeCount: 37),
  ];

  static const Map<String, List<DesignationModel>> sampleDesignations = {
    'accounts': [
      DesignationModel(id: 'accountant', name: 'Accountant'),
      DesignationModel(id: 'accounts-assistant', name: 'Accounts assistant'),
    ],
    'hr': [
      DesignationModel(id: 'hr-executive', name: 'HR executive'),
      DesignationModel(id: 'recruiter', name: 'Recruiter'),
    ],
    'it': [
      DesignationModel(id: 'senior-developer', name: 'Senior developer'),
      DesignationModel(id: 'qa-engineer', name: 'QA engineer'),
    ],
    'operations': [
      DesignationModel(
        id: 'operations-executive',
        name: 'Operations executive',
      ),
      DesignationModel(id: 'supervisor', name: 'Supervisor'),
    ],
    'sales': [
      DesignationModel(id: 'sales-manager', name: 'Sales manager'),
      DesignationModel(id: 'sales-executive', name: 'Sales executive'),
    ],
  };

  @override
  Future<List<DepartmentModel>> departments() async {
    await Future<void>.delayed(latency);
    guard.signedIn();
    return sampleDepartments;
  }

  @override
  Future<List<DesignationModel>> designations(String departmentId) async {
    await Future<void>.delayed(latency);
    guard.signedIn();
    return sampleDesignations[departmentId] ?? const [];
  }
}
