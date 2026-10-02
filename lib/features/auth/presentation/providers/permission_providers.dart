import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/auth_controller.dart';

/// What the signed-in user's role allows; empty when signed out.
///
/// Only shapes the UI (hides what can't be used). The backend checks every
/// request itself.
final grantsProvider = Provider<Set<AppPermission>>(
  (ref) => ref.watch(authControllerProvider).value?.grants ?? const {},
);

extension PermissionRef on WidgetRef {
  /// Whether the signed-in user may [permission]; rebuilds when it changes.
  bool can(AppPermission permission) =>
      watch(grantsProvider).contains(permission);
}
