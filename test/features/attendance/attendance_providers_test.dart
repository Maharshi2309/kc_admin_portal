import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/features/attendance/data/models/attendance_models.dart';
import 'package:kc_admin_portal/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:kc_admin_portal/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:kc_admin_portal/features/attendance/presentation/providers/attendance_providers.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/catalogs.dart';
import '../../helpers/fake_auth.dart';
import '../../helpers/fake_dashboard.dart';

class _MockAttendance extends Mock implements AttendanceRepository {}

/// The API example for one day, cut into pages of [pageSize].
AttendanceDayModel _page(int page, {int pageSize = 1}) {
  final json =
      jsonDecode(
            File(
              'docs/api-examples/attendance.day.response.json',
            ).readAsStringSync(),
          )
          as Map<String, dynamic>;
  final day = AttendanceDayModel.fromJson(json);
  final start = (page - 1) * pageSize;
  return day.copyWith(
    items: day.items.sublist(start, start + pageSize),
    total: day.items.length,
    page: page,
    pageSize: pageSize,
  );
}

void main() {
  setUpAll(() => registerFallbackValue(AttendanceQuery(date: testNow)));

  group('attendance query', () {
    test('starts today; never moves into the future', () {
      final container = createTestContainer();
      final query = container.read(attendanceQueryProvider.notifier);
      expect(query.isToday, isTrue);

      query.nextDay();
      expect(
        container.read(attendanceQueryProvider).date,
        DateTime(2026, 9, 28),
      );

      query
        ..previousDay()
        ..nextDay();
      expect(query.isToday, isTrue);
    });

    test('search waits for a pause in typing; department filters', () async {
      final container = createTestContainer();
      container.read(attendanceQueryProvider.notifier)
        ..setSearch('ish')
        ..setDepartment(dept('Graphic Designer').id);
      expect(container.read(attendanceQueryProvider).search, '');
      expect(
        container.read(attendanceQueryProvider).departmentId,
        dept('Graphic Designer').id,
      );

      await Future<void>.delayed(
        AttendanceQueryNotifier.searchDebounce +
            const Duration(milliseconds: 50),
      );
      expect(container.read(attendanceQueryProvider).search, 'ish');

      final day = await container.read(attendanceDayProvider.future);
      expect(day.items.single.employee.name, 'Ishaan Trivedi');
    });
  });

  group('day list', () {
    test('"load more" appends the next page once', () async {
      final repository = _MockAttendance();
      when(
        () => repository.day(any(), page: any(named: 'page')),
      ).thenAnswer((call) async => _page(call.namedArguments[#page] as int));
      final container = createTestContainer(
        overrides: [attendanceRepositoryProvider.overrideWithValue(repository)],
      );

      final first = await container.read(attendanceDayProvider.future);
      expect(first.items, hasLength(1));
      expect(first.hasMore, isTrue);

      final notifier = container.read(attendanceDayProvider.notifier);
      await Future.wait([notifier.loadMore(), notifier.loadMore()]);

      final day = container.read(attendanceDayProvider).value!;
      expect(day.items, hasLength(2));
      expect(day.hasMore, isFalse);
      verify(() => repository.day(any(), page: 2)).called(1);

      await notifier.loadMore(); // nothing left
      verifyNever(() => repository.day(any(), page: 3));
    });

    test('a failed "load more" shows the error', () async {
      final repository = _MockAttendance();
      when(() => repository.day(any())).thenAnswer((_) async => _page(1));
      when(
        () => repository.day(any(), page: 2),
      ).thenThrow(const NetworkException());
      final container = createTestContainer(
        overrides: [attendanceRepositoryProvider.overrideWithValue(repository)],
      );

      await container.read(attendanceDayProvider.future);
      await container.read(attendanceDayProvider.notifier).loadMore();
      expect(
        container.read(attendanceDayProvider).error,
        isA<NetworkException>(),
      );
    });
  });

  group('punch actions', () {
    test('punch in, then out, updates the day', () async {
      final container = createTestContainer();
      final actions = container.read(attendanceActionsProvider.notifier);

      expect(await actions.punchIn('3'), isNull);
      var day = await container.read(attendanceDayProvider.future);
      final rohan = day.items.firstWhere((r) => r.employee.id == '3');
      expect(rohan.punchIn, isNotNull);

      expect(await actions.punchOut('3'), isNull);
      day = await container.read(attendanceDayProvider.future);
      expect(
        day.items.firstWhere((r) => r.employee.id == '3').punchOut,
        isNotNull,
      );
      expect(container.read(attendanceActionsProvider), isEmpty);
    });

    test('a failure returns a friendly message, not an exception', () async {
      final repository = _MockAttendance();
      when(() => repository.punchIn(any())).thenThrow(const NetworkException());
      final container = createTestContainer(
        overrides: [attendanceRepositoryProvider.overrideWithValue(repository)],
      );

      final message = await container
          .read(attendanceActionsProvider.notifier)
          .punchIn('3');
      expect(message, const NetworkException().message);
      expect(container.read(attendanceActionsProvider), isEmpty);
    });
  });
}
