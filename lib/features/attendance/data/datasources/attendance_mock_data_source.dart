import 'dart:math' as math;

import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_guard.dart';
import 'package:kc_admin_portal/features/attendance/data/datasources/attendance_remote_data_source.dart';
import 'package:kc_admin_portal/features/attendance/data/datasources/mock_day_calculator.dart';
import 'package:kc_admin_portal/features/attendance/data/models/attendance_models.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/employee_mock_data_source.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/mock_schedule_book.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/shared/mock/mock_audit_log.dart';
import 'package:kc_admin_portal/shared/models/audit_entry_model.dart';
import 'package:kc_admin_portal/shared/models/employee_summary_model.dart';
import 'package:kc_admin_portal/shared/models/holiday_model.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/models/work_schedule_model.dart';

/// DEV ONLY (`USE_MOCK_API=true`): in-memory attendance for the sample
/// employees, playing the backend's role: every value comes from
/// [MockDayCalculator] with each employee's own schedule
/// (docs/DATABASE_V2.md §3).
class AttendanceMockDataSource implements AttendanceRemoteDataSource {
  /// Checks the signed-in user's permissions, like the backend (§4.2).
  final MockGuard guard;

  AttendanceMockDataSource({
    this.guard = const MockGuard.allowAll(),
    required this.now,
    this.latency = Duration.zero,
    List<EmployeeModel>? store,
    MockScheduleBook? schedules,
    HolidayModel? Function(DateTime date)? holidayOn,
    this.leaveOn,
    this.audit,
  }) : _store = store ?? EmployeeMockDataSource.seed(now()),
       _holidayOn = holidayOn ?? _noHolidays {
    _schedules =
        schedules ??
        (MockScheduleBook(now: now)
          ..seed([for (final e in _store) (id: e.id, joined: e.joiningDate)]));
  }

  final DateTime Function() now;
  final Duration latency;

  /// Shared mock employee store; only active employees take attendance.
  final List<EmployeeModel> _store;

  /// Each employee's schedule versions (shared with the employee mock).
  late final MockScheduleBook _schedules;

  /// The company holiday on a date, if any.
  final HolidayModel? Function(DateTime date) _holidayOn;

  static HolidayModel? _noHolidays(DateTime _) => null;

  /// Approved leave on a date, from the leave mock. Without it (unit tests
  /// on their own), today's sample statuses stand in for leave.
  final DayLeave Function(String employeeId, DateTime date)? leaveOn;

  /// The change history, when shared.
  final MockAuditLog? audit;

  static String _time(DateTime? t) => t == null
      ? '—'
      : '${t.hour.toString().padLeft(2, '0')}:'
            '${t.minute.toString().padLeft(2, '0')}';

  List<EmployeeModel> get _employees =>
      _store.where((e) => e.status == EmployeeStatus.active).toList();

  /// Punches changed by punch in/out and corrections, by [_key].
  final Map<String, AttendanceRecordModel> _saved = {};

  Future<void> _wait() => Future<void>.delayed(latency);

  static String _key(String employeeId, DateTime date) =>
      '$employeeId-${date.year}${date.month.toString().padLeft(2, '0')}'
      '${date.day.toString().padLeft(2, '0')}';

  static DateTime _at(DateTime date, int minutes) =>
      date.dateOnly.add(Duration(minutes: minutes));

  static int _minutesOf(DateTime time) => time.hour * 60 + time.minute;

  static EmployeeSummaryModel _summary(EmployeeModel e) => EmployeeSummaryModel(
    id: e.id,
    name: e.name,
    ecNumber: e.ecNumber,
    department: e.department.name,
    designation: e.designation.name,
  );

  EmployeeModel _employee(String id) {
    final employee = _employees.where((e) => e.id == id).firstOrNull;
    if (employee == null) {
      throw const NotFoundException('This employee could not be found.');
    }
    return employee;
  }

  /// Builds a record the way the backend would: from the punches, the
  /// employee's schedule on [date], holidays and leave.
  AttendanceRecordModel _derived(
    EmployeeModel employee,
    DateTime date, {
    DateTime? punchIn,
    DateTime? punchOut,
    DayLeave leave = DayLeave.none,
    String? note,
    String? correctedBy,
    DateTime? correctedAt,
  }) {
    final schedule = _schedules.on(employee.id, date);
    final result = MockDayCalculator.compute(
      date: date,
      now: now(),
      schedule: schedule,
      holiday: _holidayOn(date.dateOnly),
      leave: leave,
      punchIn: punchIn,
      punchOut: punchOut,
    );
    final working = result.dayType == CalendarDayType.working;
    final hasRecord =
        punchIn != null || result.status == AttendanceDayStatus.onLeave;

    return AttendanceRecordModel(
      id: hasRecord ? _key(employee.id, date) : null,
      employee: _summary(employee),
      date: date.dateOnly,
      punchIn: punchIn,
      punchOut: punchOut,
      workedMinutes: result.workedMinutes,
      workedPercent: result.workedPercent,
      status: result.status,
      note: note ?? result.note,
      correctedBy: correctedBy,
      correctedAt: correctedAt,
      dayKind: result.dayKind,
      schedule: working && schedule != null
          ? ScheduleSnapshotModel(
              startTime: schedule.startTime,
              endTime: schedule.endTime,
              expectedMinutes: schedule.expectedMinutes,
            )
          : null,
      expectedMinutes: result.expectedMinutes,
      overtimeMinutes: result.overtimeMinutes,
    );
  }

  /// The stored punches, or sample data for dates never changed.
  AttendanceRecordModel _recordFor(EmployeeModel employee, DateTime date) {
    final day = date.dateOnly;
    final isToday = day == now().dateOnly;
    final fromLeaveMock = leaveOn;
    final leave = fromLeaveMock != null
        ? fromLeaveMock(employee.id, day)
        : !isToday
        ? DayLeave.none
        : switch (employee.todayStatus) {
            AttendanceDayStatus.onLeave => DayLeave.fullDay,
            AttendanceDayStatus.halfDay => DayLeave.halfDay,
            _ => DayLeave.none,
          };

    final saved = _saved[_key(employee.id, day)];
    if (saved != null) {
      return _derived(
        employee,
        day,
        punchIn: saved.punchIn,
        punchOut: saved.punchOut,
        leave: leave,
        note: saved.correctedBy == null ? null : saved.note,
        correctedBy: saved.correctedBy,
        correctedAt: saved.correctedAt,
      );
    }

    final schedule = _schedules.on(employee.id, day);
    final seedIndex = int.parse(employee.id);
    final offDay =
        _holidayOn(day) != null ||
        (schedule?.weeklyOffDays.contains(day.weekday) ?? false);
    if (schedule == null || offDay) {
      // Now and then someone works their weekly off or a holiday.
      final worksOffDay = offDay && (day.day + seedIndex) % 9 == 0 && !isToday;
      return _derived(
        employee,
        day,
        punchIn: worksOffDay ? _at(day, 10 * 60) : null,
        punchOut: worksOffDay ? _at(day, 14 * 60) : null,
      );
    }

    final start = schedule.startTime.minutes;
    final end = schedule.endTime.minutes;
    final sampled = isToday
        ? employee.todayStatus
        : (day.day + seedIndex) % 11 == 0
        ? AttendanceDayStatus.late
        : AttendanceDayStatus.present;
    // Leave comes from the leave records when they are shared.
    final todayStatus = switch (leave) {
      DayLeave.fullDay => AttendanceDayStatus.onLeave,
      DayLeave.halfDay => AttendanceDayStatus.halfDay,
      DayLeave.none
          when fromLeaveMock != null &&
              (sampled == AttendanceDayStatus.onLeave ||
                  sampled == AttendanceDayStatus.halfDay) =>
        AttendanceDayStatus.present,
      _ => sampled,
    };
    // Arrive 10 min early to 4 min late; leave 10 min early to 29 min late.
    final inMinutes = start - 10 + seedIndex * 3 % 15;
    final outMinutes = end - 10 + seedIndex * 7 % 40;
    final finished = !isToday || _minutesOf(now()) >= outMinutes;

    return switch (todayStatus) {
      AttendanceDayStatus.late => _derived(
        employee,
        day,
        punchIn: _at(day, start + MockDayCalculator.lateGraceMinutes + 23),
        punchOut: finished ? _at(day, outMinutes) : null,
      ),
      AttendanceDayStatus.halfDay => _derived(
        employee,
        day,
        punchIn: _at(day, start),
        punchOut: _at(day, start + 4 * 60),
        leave: DayLeave.halfDay,
        note: 'Leave 2nd half',
      ),
      AttendanceDayStatus.onLeave => _derived(
        employee,
        day,
        leave: DayLeave.fullDay,
      ),
      AttendanceDayStatus.absent => _derived(employee, day),
      _ => _derived(
        employee,
        day,
        punchIn: _at(day, inMinutes),
        punchOut: finished ? _at(day, outMinutes) : null,
      ),
    };
  }

  List<AttendanceRecordModel> _allFor(DateTime date) => [
    for (final employee in _employees) _recordFor(employee, date),
  ];

  static const List<AttendanceDayStatus> _listOrder = [
    AttendanceDayStatus.absent,
    AttendanceDayStatus.late,
    AttendanceDayStatus.present,
    AttendanceDayStatus.halfDay,
    AttendanceDayStatus.onLeave,
    AttendanceDayStatus.holiday,
    AttendanceDayStatus.weeklyOff,
  ];

  static bool _matches(AttendanceFilter filter, AttendanceRecordModel r) =>
      switch (filter) {
        AttendanceFilter.all => true,
        // Half days count as present, as in the design's tiles.
        AttendanceFilter.present =>
          r.status == AttendanceDayStatus.present ||
              r.status == AttendanceDayStatus.halfDay,
        AttendanceFilter.late => r.status == AttendanceDayStatus.late,
        AttendanceFilter.onLeave => r.status == AttendanceDayStatus.onLeave,
        AttendanceFilter.absent => r.status == AttendanceDayStatus.absent,
      };

  @override
  Future<AttendanceDayModel> day(AttendanceQuery query, int page) async {
    await _wait();
    guard.require(AppPermission.attendanceView);
    if (query.date.dateOnly.isAfter(now().dateOnly)) {
      throw const ValidationException(
        'Attendance is not available for future dates.',
      );
    }
    final all = _allFor(query.date);
    final search = query.search.trim().toLowerCase();
    final rows =
        all
            .where((r) => _matches(query.filter, r))
            .where(
              (r) =>
                  search.isEmpty ||
                  r.employee.name.toLowerCase().contains(search) ||
                  r.employee.ecNumber.toLowerCase().contains(search),
            )
            .where(
              (r) =>
                  query.departmentId == null ||
                  _employee(r.employee.id).department.id == query.departmentId,
            )
            .toList()
          ..sort((a, b) {
            final byStatus = _listOrder
                .indexOf(a.status)
                .compareTo(_listOrder.indexOf(b.status));
            return byStatus != 0
                ? byStatus
                : a.employee.name.compareTo(b.employee.name);
          });

    final end = math.min(page * AttendanceQuery.pageSize, rows.length);
    int count(bool Function(AttendanceRecordModel) test) =>
        all.where(test).length;

    return AttendanceDayModel(
      summary: AttendanceDaySummaryModel(
        date: query.date.dateOnly,
        totalEmployees: all.length,
        present: count((r) => _matches(AttendanceFilter.present, r)),
        late: count((r) => r.status == AttendanceDayStatus.late),
        onLeave: count((r) => r.status == AttendanceDayStatus.onLeave),
        absent: count((r) => r.status == AttendanceDayStatus.absent),
        notPunchedIn: count((r) => r.status == AttendanceDayStatus.absent),
      ),
      items: rows.sublist(0, end),
      total: rows.length,
      page: page,
      pageSize: AttendanceQuery.pageSize,
    );
  }

  (EmployeeModel, DateTime) _parseId(String id) {
    final separator = id.lastIndexOf('-');
    final raw = separator < 0 ? '' : id.substring(separator + 1);
    if (raw.length != 8) {
      throw const NotFoundException('This attendance record was not found.');
    }
    final date = DateTime(
      int.parse(raw.substring(0, 4)),
      int.parse(raw.substring(4, 6)),
      int.parse(raw.substring(6, 8)),
    );
    return (_employee(id.substring(0, separator)), date);
  }

  @override
  Future<AttendanceRecordModel> getById(String id) async {
    await _wait();
    guard.require(AppPermission.attendanceView);
    final (employee, date) = _parseId(id);
    return _recordFor(employee, date);
  }

  AttendanceRecordModel _save(AttendanceRecordModel record) {
    _saved[_key(record.employee.id, record.date)] = record;
    return _recordFor(_employee(record.employee.id), record.date);
  }

  @override
  Future<AttendanceRecordModel> punchIn(String employeeId) async {
    await _wait();
    guard.require(AppPermission.attendancePunch);
    final today = now();
    final current = _recordFor(_employee(employeeId), today);
    if (current.punchIn != null) {
      throw const ValidationException('Already punched in today.');
    }
    if (current.status == AttendanceDayStatus.onLeave) {
      throw const ValidationException('This employee is on leave today.');
    }
    return _save(current.copyWith(punchIn: today));
  }

  @override
  Future<AttendanceRecordModel> punchOut(String employeeId) async {
    await _wait();
    guard.require(AppPermission.attendancePunch);
    final today = now();
    final current = _recordFor(_employee(employeeId), today);
    if (current.punchIn == null) {
      throw const ValidationException('Punch in first.');
    }
    if (current.punchOut != null) {
      throw const ValidationException('Already punched out today.');
    }
    return _save(current.copyWith(punchOut: today));
  }

  @override
  Future<int> punchInAll(DateTime date) async {
    await _wait();
    guard.require(AppPermission.attendancePunch);
    final today = now();
    final pending = _allFor(
      today,
    ).where((r) => r.status == AttendanceDayStatus.absent);
    for (final record in pending) {
      _save(record.copyWith(punchIn: today));
    }
    return pending.length;
  }

  AttendanceRecordModel _applyCorrection(
    EmployeeModel employee,
    AttendanceCorrectionData data,
  ) {
    if (data.punchOut != null && !data.punchOut!.isAfter(data.punchIn)) {
      throw const ValidationException(
        'Punch out must be after punch in.',
        fieldErrors: {'punchOut': 'Must be after punch in'},
      );
    }
    final base = _recordFor(employee, data.date);
    final isNew = base.punchIn == null;
    audit?.record(
      action: isNew ? 'attendance.create' : 'attendance.correct',
      summary: isNew ? 'Added attendance' : 'Corrected attendance',
      employeeId: employee.id,
      from: data.date,
      changes: [
        if (base.punchIn != data.punchIn)
          AuditChangeModel(
            field: 'punchIn',
            label: 'Punch in',
            before: _time(base.punchIn),
            after: _time(data.punchIn),
          ),
        if (base.punchOut != data.punchOut)
          AuditChangeModel(
            field: 'punchOut',
            label: 'Punch out',
            before: _time(base.punchOut),
            after: _time(data.punchOut),
          ),
      ],
      reason: data.reason.label,
      remarks: data.remarks,
    );
    return _save(
      base.copyWith(
        punchIn: data.punchIn,
        punchOut: data.punchOut,
        note: 'Corrected: ${data.reason.label}',
        correctedBy: 'Admin',
        correctedAt: now(),
      ),
    );
  }

  @override
  Future<AttendanceRecordModel> correct(
    String id,
    AttendanceCorrectionData data,
  ) async {
    await _wait();
    guard.require(AppPermission.attendanceCorrect);
    final (employee, _) = _parseId(id);
    return _applyCorrection(employee, data);
  }

  @override
  Future<AttendanceRecordModel> create(AttendanceCorrectionData data) async {
    await _wait();
    guard.require(AppPermission.attendanceCorrect);
    final employee = _employee(data.employeeId ?? '');
    if (_recordFor(employee, data.date).punchIn != null) {
      throw const ValidationException(
        'A record already exists for this day. Correct it instead.',
      );
    }
    return _applyCorrection(employee, data);
  }

  @override
  Future<List<AttendanceRecordModel>> employeeLog(
    String employeeId,
    DateTime month,
  ) async {
    await _wait();
    guard.require(AppPermission.attendanceView);
    final employee = _employee(employeeId);
    final today = now().dateOnly;
    return [
      for (
        var date = month.monthStart;
        date.month == month.month && !date.isAfter(today);
        date = DateTime(date.year, date.month, date.day + 1)
      )
        _recordFor(employee, date),
    ].reversed.toList();
  }

  /// DEV ONLY: one employee's records from [from] to [to] (not past today),
  /// for the overtime and calendar mocks. Includes inactive employees, so
  /// their past overtime still shows.
  List<AttendanceRecordModel> recordsBetween(
    String employeeId,
    DateTime from,
    DateTime to,
  ) {
    final employee = _store.where((e) => e.id == employeeId).firstOrNull;
    if (employee == null) {
      throw const NotFoundException('This employee could not be found.');
    }
    final today = now().dateOnly;
    final last = to.dateOnly.isAfter(today) ? today : to.dateOnly;
    return [
      for (
        var date = from.dateOnly;
        !date.isAfter(last);
        date = DateTime(date.year, date.month, date.day + 1)
      )
        _recordFor(employee, date),
    ];
  }

  /// DEV ONLY: every active employee's record on [date], for other mocks
  /// (the dashboard) that do their own permission check.
  List<AttendanceRecordModel> recordsOn(DateTime date) => _allFor(date);

  /// DEV ONLY: the schedules used for the records.
  MockScheduleBook get schedules => _schedules;
}
