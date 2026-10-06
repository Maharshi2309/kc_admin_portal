import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/features/employees/domain/utils/schedule_rules.dart';
import 'package:kc_admin_portal/shared/mock/mock_ids.dart';
import 'package:kc_admin_portal/shared/mock/mock_tenant.dart';
import 'package:kc_admin_portal/shared/models/clock_time.dart';
import 'package:kc_admin_portal/shared/models/named_ref.dart';
import 'package:kc_admin_portal/shared/models/work_schedule_model.dart';

/// DEV ONLY (`USE_MOCK_API=true`): every employee's schedule versions, playing
/// the backend's role (docs/DATABASE_V2.md §2.1): it validates schedules,
/// computes expected minutes and closes the previous version. Shared by the
/// employee mock and, later, the attendance and calendar mocks.
class MockScheduleBook {
  MockScheduleBook({required this.now});

  final DateTime Function() now;
  final Map<String, List<WorkScheduleModel>> _versions = {};
  int _nextId = 1;

  static const NamedRef _admin = NamedRef(id: '1', name: 'Admin');

  /// Sample schedules: most people 09:30–18:30 with an hour's break (the
  /// design's shift); a few different ones so per-employee hours show.
  /// Employee 1 changed schedule this April, so it has a history.
  void seed(Iterable<({String id, DateTime joined})> employees) {
    final year = now().year;
    for (final (:id, :joined) in employees) {
      final input = switch (mockSeedOf(id) % 4) {
        2 => _input(
          joined,
          9,
          0,
          17,
          30,
          60,
          breakAt: const ClockTime.hm(13, 0),
        ),
        3 => _input(joined, 10, 0, 18, 30, 30, offs: const [6, 7]),
        _ => _input(joined, 9, 30, 18, 30, 60),
      };
      add(id, input);
      if (id == '1') {
        add(
          id,
          _input(
            DateTime(year, 4),
            9,
            0,
            17,
            30,
            60,
            breakAt: const ClockTime.hm(13, 0),
          ),
        );
      }
    }
  }

  static WorkScheduleInput _input(
    DateTime from,
    int startH,
    int startM,
    int endH,
    int endM,
    int breakMinutes, {
    ClockTime? breakAt,
    List<int> offs = const [DateTime.sunday],
  }) => WorkScheduleInput(
    effectiveFrom: from,
    startTime: ClockTime.hm(startH, startM),
    endTime: ClockTime.hm(endH, endM),
    breakMinutes: breakMinutes,
    breakStart: breakAt,
    breakEnd: breakAt == null
        ? null
        : ClockTime(breakAt.minutes + breakMinutes),
    weeklyOffDays: offs,
  );

  /// Newest first, like `GET /employees/{id}/schedules`.
  List<WorkScheduleModel> versions(String employeeId) =>
      (_versions[employeeId] ?? const []).reversed.toList();

  /// The version in effect on [date], if any.
  WorkScheduleModel? on(String employeeId, DateTime date) {
    final day = date.dateOnly;
    for (final version
        in _versions[employeeId] ?? const <WorkScheduleModel>[]) {
      final to = version.effectiveTo;
      if (!version.effectiveFrom.isAfter(day) &&
          (to == null || !to.isBefore(day))) {
        return version;
      }
    }
    return null;
  }

  /// Validates like the server, stores the version and re-links the
  /// versions' end dates. Throws a [ValidationException] on bad input.
  WorkScheduleModel add(String employeeId, WorkScheduleInput input) {
    validate(input);
    final list = _versions.putIfAbsent(employeeId, () => []);
    final from = input.effectiveFrom.dateOnly;
    if (list.any((v) => v.effectiveFrom == from)) {
      throw const ValidationException(
        'A schedule already starts on this date.',
        fieldErrors: {
          'effectiveFrom': 'A schedule already starts on this date',
        },
        code: 'SCHEDULE_OVERLAP',
      );
    }
    final version = WorkScheduleModel(
      id: 's${_nextId++}',
      effectiveFrom: from,
      startTime: input.startTime,
      endTime: input.endTime,
      breakMinutes: input.breakMinutes,
      breakStart: input.breakStart,
      breakEnd: input.breakEnd,
      weeklyOffDays: [...input.weeklyOffDays]..sort(),
      expectedMinutes:
          input.endTime.minutes - input.startTime.minutes - input.breakMinutes,
      createdBy: _admin,
      createdAt: now(),
    );
    list
      ..add(version)
      ..sort((a, b) => a.effectiveFrom.compareTo(b.effectiveFrom));
    // Each version ends the day before the next one starts.
    for (var i = 0; i < list.length; i++) {
      list[i] = list[i].copyWith(
        effectiveTo: i + 1 < list.length
            ? list[i + 1].effectiveFrom.subtract(const Duration(days: 1))
            : null,
      );
    }
    return list.firstWhere((v) => v.id == version.id);
  }

  /// The server's checks (docs/DATABASE_V2.md §2.1).
  static void validate(WorkScheduleInput input) {
    final problems = scheduleProblems(input);
    if (problems.isNotEmpty) {
      throw ValidationException(problems.values.first, fieldErrors: problems);
    }
  }
}

/// DEV ONLY: the schedules of the active organization's sample employees.
final mockScheduleBookProvider = Provider<MockScheduleBook>(
  (ref) => ref.watch(mockActiveTenantProvider).schedules,
);
