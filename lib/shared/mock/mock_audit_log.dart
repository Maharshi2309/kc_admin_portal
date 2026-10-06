import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/shared/mock/mock_tenant.dart';
import 'package:kc_admin_portal/shared/models/audit_entry_model.dart';
import 'package:kc_admin_portal/shared/models/named_ref.dart';

/// DEV ONLY (`USE_MOCK_API=true`): the change history, playing the
/// backend's `audit_logs` table (docs/DATABASE_V2.md §5). The mocks write
/// an entry with every change; the calendar's day sheet reads them.
class MockAuditLog {
  MockAuditLog({required this.now});

  final DateTime Function() now;
  final List<_Entry> _entries = [];
  int _nextId = 1;

  /// Who the dev mocks act as.
  static const NamedRef actor = NamedRef(id: '1', name: 'Admin');

  /// Records a change. [employeeId] null means it concerns everyone (a
  /// company holiday). The change applies to [from]–[to] (one day when [to]
  /// is null).
  void record({
    required String action,
    required String summary,
    required DateTime from,
    DateTime? to,
    String? employeeId,
    List<AuditChangeModel> changes = const [],
    String? reason,
    String? remarks,
  }) {
    _entries.add(
      _Entry(
        employeeId: employeeId,
        from: from.dateOnly,
        to: (to ?? from).dateOnly,
        model: AuditEntryModel(
          id: 'au${_nextId++}',
          action: action,
          summary: summary,
          actor: actor,
          createdAt: now(),
          changes: changes,
          reason: reason,
          remarks: (remarks?.trim().isEmpty ?? true) ? null : remarks!.trim(),
        ),
      ),
    );
  }

  /// Changes to [employeeId]'s records on [date], and company-wide changes
  /// on that date, newest first.
  List<AuditEntryModel> forDay(String employeeId, DateTime date) {
    final day = date.dateOnly;
    return [
      for (final e in _entries.reversed)
        if ((e.employeeId == null || e.employeeId == employeeId) &&
            !day.isBefore(e.from) &&
            !day.isAfter(e.to))
          e.model,
    ];
  }
}

class _Entry {
  const _Entry({
    required this.employeeId,
    required this.from,
    required this.to,
    required this.model,
  });

  final String? employeeId;
  final DateTime from;
  final DateTime to;
  final AuditEntryModel model;
}

/// DEV ONLY: the active organization's change history, shared by its
/// mocks.
final mockAuditLogProvider = Provider<MockAuditLog>(
  (ref) => ref.watch(mockActiveTenantProvider).audit,
);
