import 'package:flutter_test/flutter_test.dart';

import 'package:kc_admin_portal/features/leave/presentation/providers/leave_providers.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

import '../../helpers/catalogs.dart';
import '../../helpers/fake_auth.dart';

void main() {
  group('leave list query', () {
    test('search waits for a pause in typing, then goes to page 1', () async {
      final container = createTestContainer();
      final query = container.read(leaveQueryProvider.notifier)..setPage(3);

      query
        ..setSearch('dh')
        ..setSearch('dhruv ');
      expect(container.read(leaveQueryProvider).search, '');

      await Future<void>.delayed(
        LeaveQueryNotifier.searchDebounce + const Duration(milliseconds: 50),
      );
      expect(container.read(leaveQueryProvider).search, 'dhruv');
      expect(container.read(leaveQueryProvider).page, 1);
    });

    test('every filter change returns to page 1', () {
      final container = createTestContainer();
      final query = container.read(leaveQueryProvider.notifier);
      final from = DateTime(2026, 10);
      final to = DateTime(2026, 10, 31);

      query
        ..setPage(2)
        ..setDateRange(from, to);
      expect(container.read(leaveQueryProvider).page, 1);
      expect(container.read(leaveQueryProvider).from, from);

      query
        ..setPage(2)
        ..setLeaveType('casual');
      expect(container.read(leaveQueryProvider).page, 1);

      query
        ..setPage(2)
        ..setDepartment(dept('Graphic Designer').id);
      expect(container.read(leaveQueryProvider).page, 1);

      query
        ..setPage(2)
        ..setPageSize(25);
      expect(container.read(leaveQueryProvider).page, 1);
      expect(container.read(leaveQueryProvider).pageSize, 25);
    });

    test('clearing filters keeps the status tab and page size', () {
      final container = createTestContainer();
      container.read(leaveQueryProvider.notifier)
        ..setStatus(LeaveStatus.pending)
        ..setPageSize(25)
        ..applySearch('dhruv')
        ..setLeaveType('casual')
        ..clearFilters();

      final query = container.read(leaveQueryProvider);
      expect(query.status, LeaveStatus.pending);
      expect(query.pageSize, 25);
      expect(query.search, '');
      expect(query.leaveTypeId, isNull);
    });

    test('the list follows the query (search and type)', () async {
      final container = createTestContainer();
      container.read(leaveQueryProvider.notifier)
        ..applySearch('Dhruv')
        ..setLeaveType('casual');

      final list = await container.read(leaveListProvider.future);
      expect(list.items, isNotEmpty);
      expect(
        list.items.every(
          (l) =>
              l.employee.name.contains('Dhruv') && l.leaveType.id == 'casual',
        ),
        isTrue,
      );
    });
  });
}
