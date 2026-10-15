import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/config/company_time.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/auth_controller.dart';

/// The active organization's time zone (IANA name), applied to
/// [CompanyTime] so "today" and every time shown follow it (2026-10-13).
/// Signed out, or an organization without one: [CompanyTime.defaultZone].
final activeTimeZoneProvider = Provider<String>((ref) {
  final zone = ref.watch(
    authControllerProvider.select((auth) => auth.value?.organization?.timezone),
  );
  CompanyTime.use(zone);
  return CompanyTime.zoneName;
});

/// The organization the signed-in user is working in; null when signed out.
/// Its time zone is applied first, so data loaded for it is read in it.
final activeOrganizationIdProvider = Provider<String?>((ref) {
  ref.watch(activeTimeZoneProvider);
  return ref.watch(
    authControllerProvider.select((auth) => auth.value?.organization?.id),
  );
});

/// What all organization data depends on: the organization and its time
/// zone. Every data source provider and query notifier watches this, so
/// switching organization (or signing out) rebuilds every repository and
/// refetches everything: nothing cached for one organization can show while
/// another loads (docs/ARCHITECTURE_MULTI_ORG.md §C). Filters and pages
/// reset too. A new time zone does the same, as times already loaded were
/// read in the old one.
final activeOrganizationScopeProvider =
    Provider<({String? organizationId, String timeZone})>(
      (ref) => (
        organizationId: ref.watch(activeOrganizationIdProvider),
        timeZone: ref.watch(activeTimeZoneProvider),
      ),
    );
