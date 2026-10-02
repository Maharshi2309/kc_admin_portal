import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/features/access_control/data/models/access_models.dart';
import 'package:kc_admin_portal/features/access_control/data/repositories/access_repository_impl.dart';

/// The permission catalogue, grouped by module, for the permission list.
final permissionCatalogueProvider =
    FutureProvider.autoDispose<List<PermissionModuleModel>>(
      (ref) => ref.watch(accessRepositoryProvider).permissions(),
      retry: (_, _) => null,
    );
