import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/widgets/app_dialog.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/employees/presentation/providers/employee_providers.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

/// Deactivates (after confirmation) or reactivates [employee], then reports
/// the result. Employees are never deleted; their records are kept.
Future<void> toggleEmployeeStatus(
  BuildContext context,
  WidgetRef ref,
  EmployeeModel employee,
) async {
  final deactivating = employee.status == EmployeeStatus.active;
  // Captured now: after a successful deactivation the calling row may be
  // gone from the list, but the screen's messenger is still there.
  final messenger = ScaffoldMessenger.of(context);

  if (deactivating) {
    final confirmed = await showAppConfirmDialog(
      context,
      title: 'Deactivate ${employee.name}?',
      message:
          '${employee.name} (${employee.ecNumber}) will be marked inactive. '
          'Their records are kept and they can be reactivated later.',
      confirmLabel: 'Deactivate',
      isDestructive: true,
    );
    if (!confirmed) return;
  }

  // Read before the await: the row's `ref` may be disposed afterwards.
  final controller = ref.read(employeeStatusControllerProvider.notifier);
  final saved = await controller.change(
    employee.id,
    deactivating ? EmployeeStatus.inactive : EmployeeStatus.active,
  );

  if (saved) {
    showAppSnackBarOn(
      messenger,
      '${employee.name} ${deactivating ? 'deactivated' : 'reactivated'}',
      tone: SnackBarTone.success,
    );
  } else {
    showAppSnackBarOn(
      messenger,
      ErrorHandler.messageFor(controller.lastError ?? Object()),
      tone: SnackBarTone.error,
    );
  }
}
