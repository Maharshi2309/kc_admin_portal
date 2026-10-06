import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/features/auth/presentation/providers/auth_controller.dart';

/// The organization the signed-in user is working in; null when signed out.
///
/// Every data source provider watches this, so switching organization (or
/// signing out) rebuilds every repository and refetches everything: nothing
/// cached for one organization can show while another loads
/// (docs/ARCHITECTURE_MULTI_ORG.md §C). Filters and pages reset too.
final activeOrganizationIdProvider = Provider<String?>(
  (ref) => ref.watch(
    authControllerProvider.select((auth) => auth.value?.organization?.id),
  ),
);
