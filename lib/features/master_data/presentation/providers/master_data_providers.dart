import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/features/master_data/data/repositories/master_data_repository_impl.dart';
import 'package:kc_admin_portal/shared/models/list_entry.dart';

/// All departments from `GET /departments`. Loaded once after sign-in and
/// kept alive for the session. Used to populate dropdowns and resolve
/// department codes to display names throughout the app.
final departmentsProvider = FutureProvider<List<ListEntry>>(
  (ref) => ref.watch(masterDataRepositoryProvider).departments(),
);

/// All positions from `GET /positions`. Same behaviour as [departmentsProvider].
final positionsProvider = FutureProvider<List<ListEntry>>(
  (ref) => ref.watch(masterDataRepositoryProvider).positions(),
);

/// Convenience: [departmentsProvider] data or empty list (safe for eager use).
List<ListEntry> watchDepartments(WidgetRef ref) =>
    switch (ref.watch(departmentsProvider)) {
      AsyncData(:final value) => value,
      _ => const [],
    };

/// Convenience: [positionsProvider] data or empty list.
List<ListEntry> watchPositions(WidgetRef ref) =>
    switch (ref.watch(positionsProvider)) {
      AsyncData(:final value) => value,
      _ => const [],
    };
