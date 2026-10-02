import 'dart:math' as math;

import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_guard.dart';
import 'package:kc_admin_portal/features/attendance/data/datasources/mock_day_calculator.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/mock_schedule_book.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/holidays/data/datasources/mock_holiday_store.dart';
import 'package:kc_admin_portal/features/leave/data/datasources/leave_remote_data_source.dart';
import 'package:kc_admin_portal/features/leave/data/models/leave_models.dart';
import 'package:kc_admin_portal/shared/mock/mock_audit_log.dart';
import 'package:kc_admin_portal/shared/models/audit_entry_model.dart';
import 'package:kc_admin_portal/shared/models/employee_summary_model.dart';
import 'package:kc_admin_portal/shared/models/leave_balance_model.dart';
import 'package:kc_admin_portal/shared/models/named_ref.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

/// DEV ONLY (`USE_MOCK_API=true`): in-memory leave records playing the
/// backend's role: it counts days (weekly offs and holidays excluded),
/// checks balances and overlaps, and enforces status changes. Quotas are
/// sample values from the design, not business rules.
class LeaveMockDataSource implements LeaveRemoteDataSource {
  /// Checks the signed-in user's permissions, like the backend (§4.2).
  final MockGuard guard;

  LeaveMockDataSource({
    this.guard = const MockGuard.allowAll(),
    required this.now,
    required this.employees,
    this.latency = Duration.zero,
    MockHolidayStore? holidays,
    MockScheduleBook? schedules,
    this.audit,
  }) : holidays = holidays ?? MockHolidayStore(now: now),
       schedules =
           schedules ??
           (MockScheduleBook(now: now)..seed([
             for (final e in employees) (id: e.id, joined: e.joiningDate),
           ])) {
    _leaves.addAll(_seed());
    // Like the server: a holiday added, moved or removed changes the leave
    // days (and so the balances) of leave covering that date.
    this.holidays.addListener(_recountDays);
  }

  /// Company holidays (shared with the holiday and attendance mocks).
  final MockHolidayStore holidays;

  /// Schedules, for each employee's weekly offs.
  final MockScheduleBook schedules;

  /// The change history, when shared.
  final MockAuditLog? audit;

  static String _dates(LeaveModel l) => l.startDate == l.endDate
      ? _d(l.startDate)
      : '${_d(l.startDate)} – ${_d(l.endDate)}';

  static String _d(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

  void _audit(
    String action,
    String summary,
    LeaveModel l, {
    LeaveModel? before,
  }) => audit?.record(
    action: action,
    summary: summary,
    employeeId: l.employee.id,
    from: before == null || before.startDate.isAfter(l.startDate)
        ? l.startDate
        : before.startDate,
    to: before == null || before.endDate.isBefore(l.endDate)
        ? l.endDate
        : before.endDate,
    changes: [
      if (before == null || _dates(before) != _dates(l))
        AuditChangeModel(
          field: 'dates',
          label: 'Dates',
          before: before == null ? null : _dates(before),
          after: _dates(l),
        ),
      if (before == null || before.leaveType.id != l.leaveType.id)
        AuditChangeModel(
          field: 'leaveTypeId',
          label: 'Type',
          before: before?.leaveType.name,
          after: l.leaveType.name,
        ),
      if (before == null || before.status != l.status)
        AuditChangeModel(
          field: 'status',
          label: 'Status',
          before: before?.status.label,
          after: l.status.label,
        ),
    ],
    remarks: l.remarks,
  );

  void _recountDays() {
    for (var i = 0; i < _leaves.length; i++) {
      final l = _leaves[i];
      _leaves[i] = l.copyWith(
        days: countDays(
          l.employee.id,
          l.startDate,
          l.endDate,
          isHalfDay: l.isHalfDay,
        ),
      );
    }
  }

  final DateTime Function() now;

  /// The shared mock employee store.
  final List<EmployeeModel> employees;
  final Duration latency;
  final List<LeaveModel> _leaves = [];
  int _nextId = 1;

  static const List<LeaveTypeModel> leaveTypes = [
    LeaveTypeModel(id: 'casual', name: 'Casual'),
    LeaveTypeModel(id: 'sick', name: 'Sick'),
    LeaveTypeModel(id: 'earned', name: 'Earned'),
    LeaveTypeModel(id: 'unpaid', name: 'Unpaid', hasBalance: false),
  ];

  /// Yearly days per type (design sample: 12 / 8 / 15).
  static const Map<String, double> _quotas = {
    'casual': 12,
    'sick': 8,
    'earned': 15,
  };

  static const String _admin = 'Admin';
  static const String _employeeRequest = 'Employee request';

  Future<void> _wait() => Future<void>.delayed(latency);

  /// The employee's weekly off on [date], from the schedule of that date.
  bool _isWeekOff(String employeeId, DateTime date) =>
      schedules.on(employeeId, date)?.weeklyOffDays.contains(date.weekday) ??
      false;

  bool _isWorkingDay(String employeeId, DateTime date) =>
      !_isWeekOff(employeeId, date) && holidays.on(date) == null;

  /// The backend's day count: the employee's working days only (their own
  /// weekly offs and company holidays excluded), half a day for half days.
  double countDays(
    String employeeId,
    DateTime start,
    DateTime end, {
    required bool isHalfDay,
  }) {
    if (isHalfDay) return _isWorkingDay(employeeId, start) ? 0.5 : 0;
    var days = 0.0;
    for (
      var date = start.dateOnly;
      !date.isAfter(end.dateOnly);
      date = DateTime(date.year, date.month, date.day + 1)
    ) {
      if (_isWorkingDay(employeeId, date)) days++;
    }
    return days;
  }

  EmployeeModel _employee(String id) {
    final employee = employees.where((e) => e.id == id).firstOrNull;
    if (employee == null) {
      throw const NotFoundException('This employee could not be found.');
    }
    return employee;
  }

  static EmployeeSummaryModel _summary(EmployeeModel e) => EmployeeSummaryModel(
    id: e.id,
    name: e.name,
    ecNumber: e.ecNumber,
    department: e.department.name,
    designation: e.designation.name,
  );

  static LeaveTypeModel _type(String id) {
    final type = leaveTypes.where((t) => t.id == id).firstOrNull;
    if (type == null) {
      throw const ValidationException(
        'Choose a leave type',
        fieldErrors: {'leaveTypeId': 'Choose a leave type'},
      );
    }
    return type;
  }

  LeaveModel _build({
    required EmployeeModel employee,
    required String typeId,
    required DateTime start,
    DateTime? end,
    required LeaveReason reason,
    required LeaveStatus status,
    required String addedBy,
    bool halfDay = false,
    String? remarks,
    String? id,
  }) {
    final type = _type(typeId);
    final last = halfDay ? start : (end ?? start);
    return LeaveModel(
      id: id ?? '${_nextId++}',
      employee: _summary(employee),
      leaveType: NamedRef(id: type.id, name: type.name),
      startDate: start.dateOnly,
      endDate: last.dateOnly,
      days: countDays(employee.id, start, last, isHalfDay: halfDay),
      isHalfDay: halfDay,
      reason: reason,
      remarks: remarks,
      status: status,
      addedBy: addedBy,
    );
  }

  /// The design's sample rows, plus the profile's past leaves.
  List<LeaveModel> _seed() {
    final year = now().year;
    DateTime d(int month, int day) => DateTime(year, month, day);
    final rows =
        <
          (
            String,
            String,
            DateTime,
            DateTime,
            LeaveStatus,
            String,
            LeaveReason,
            bool,
          )
        >[
          (
            'Dhruv Parmar',
            'casual',
            d(10, 5),
            d(10, 7),
            LeaveStatus.pending,
            _employeeRequest,
            LeaveReason.familyFunction,
            false,
          ),
          (
            'Nisha Solanki',
            'earned',
            d(10, 12),
            d(10, 16),
            LeaveStatus.pending,
            _employeeRequest,
            LeaveReason.travel,
            false,
          ),
          (
            'Priya Desai',
            'casual',
            d(9, 28),
            d(9, 30),
            LeaveStatus.approved,
            _admin,
            LeaveReason.personalWork,
            false,
          ),
          (
            'Harsh Vaghela',
            'sick',
            d(9, 28),
            d(9, 28),
            LeaveStatus.approved,
            _admin,
            LeaveReason.medical,
            false,
          ),
          (
            'Meera Rathod',
            'casual',
            d(9, 28),
            d(9, 28),
            LeaveStatus.approved,
            _admin,
            LeaveReason.personalWork,
            true,
          ),
          (
            'Aarav Shah',
            'casual',
            d(9, 21),
            d(9, 22),
            LeaveStatus.approved,
            _admin,
            LeaveReason.familyFunction,
            false,
          ),
          (
            'Kavya Mehta',
            'sick',
            d(9, 15),
            d(9, 15),
            LeaveStatus.pending,
            _employeeRequest,
            LeaveReason.medical,
            false,
          ),
          (
            'Rohan Patel',
            'unpaid',
            d(9, 8),
            d(9, 9),
            LeaveStatus.rejected,
            _admin,
            LeaveReason.personalWork,
            false,
          ),
          (
            'Arjun Joshi',
            'earned',
            d(9, 3),
            d(9, 4),
            LeaveStatus.cancelled,
            _admin,
            LeaveReason.travel,
            false,
          ),
          (
            'Aarav Shah',
            'casual',
            d(8, 11),
            d(8, 11),
            LeaveStatus.approved,
            _admin,
            LeaveReason.personalWork,
            false,
          ),
          (
            'Aarav Shah',
            'sick',
            d(7, 4),
            d(7, 4),
            LeaveStatus.approved,
            _admin,
            LeaveReason.medical,
            false,
          ),
          (
            'Aarav Shah',
            'earned',
            d(5, 14),
            d(5, 15),
            LeaveStatus.approved,
            _admin,
            LeaveReason.travel,
            false,
          ),
          (
            'Aarav Shah',
            'casual',
            d(3, 2),
            d(3, 3),
            LeaveStatus.approved,
            _admin,
            LeaveReason.familyFunction,
            false,
          ),
          (
            'Aarav Shah',
            'sick',
            d(2, 16),
            d(2, 16),
            LeaveStatus.approved,
            _admin,
            LeaveReason.medical,
            false,
          ),
        ];
    return [
      for (final (name, type, start, end, status, by, reason, half) in rows)
        if (employees.where((e) => e.name == name).firstOrNull
            case final employee?)
          _build(
            employee: employee,
            typeId: type,
            start: start,
            end: end,
            reason: reason,
            status: status,
            addedBy: by,
            halfDay: half,
            remarks: half ? '2nd half' : null,
          ),
    ];
  }

  // ------------------------------------------------------------------ list

  bool _matches(LeaveQuery query, LeaveModel leave) {
    final search = query.search.trim().toLowerCase();
    final from = query.from;
    final to = query.to;
    return (search.isEmpty ||
            leave.employee.name.toLowerCase().contains(search) ||
            leave.employee.ecNumber.toLowerCase().contains(search)) &&
        (from == null || !leave.endDate.isBefore(from.dateOnly)) &&
        (to == null || !leave.startDate.isAfter(to.dateOnly)) &&
        (query.leaveTypeId == null ||
            leave.leaveType.id == query.leaveTypeId) &&
        (query.departmentId == null ||
            _employee(leave.employee.id).department.id == query.departmentId);
  }

  @override
  Future<LeaveListModel> list(LeaveQuery query) async {
    await _wait();
    guard.require(AppPermission.leaveView);
    final filtered = _leaves.where((l) => _matches(query, l)).toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
    int count(LeaveStatus status) =>
        filtered.where((l) => l.status == status).length;

    final rows = query.status == null
        ? filtered
        : filtered.where((l) => l.status == query.status).toList();
    final start = math.min((query.page - 1) * query.pageSize, rows.length);
    final end = math.min(start + query.pageSize, rows.length);

    return LeaveListModel(
      items: rows.sublist(start, end),
      total: rows.length,
      page: query.page,
      pageSize: query.pageSize,
      counts: LeaveStatusCounts(
        all: filtered.length,
        pending: count(LeaveStatus.pending),
        approved: count(LeaveStatus.approved),
        rejected: count(LeaveStatus.rejected),
        cancelled: count(LeaveStatus.cancelled),
      ),
    );
  }

  LeaveModel _find(String id) {
    final leave = _leaves.where((l) => l.id == id).firstOrNull;
    if (leave == null) {
      throw const NotFoundException('This leave could not be found.');
    }
    return leave;
  }

  @override
  Future<LeaveModel> getById(String id) async {
    await _wait();
    guard.require(AppPermission.leaveView);
    return _find(id);
  }

  /// Pending requests, for the dashboard's "Needs your attention".
  int get pendingCount =>
      _leaves.where((l) => l.status == LeaveStatus.pending).length;

  // ------------------------------------------------------------ balances

  double _usedDays(String employeeId, String typeId, {String? exceptId}) =>
      _leaves
          .where(
            (l) =>
                l.id != exceptId &&
                l.employee.id == employeeId &&
                l.leaveType.id == typeId &&
                l.startDate.year == now().year &&
                (l.status == LeaveStatus.approved ||
                    l.status == LeaveStatus.pending),
          )
          .fold(0, (sum, l) => sum + l.days);

  /// Balances per type, as shown on the profile.
  List<LeaveBalanceModel> balances(String employeeId) => [
    for (final type in leaveTypes)
      LeaveBalanceModel(
        leaveTypeId: type.id,
        leaveType: '${type.name} leave',
        quota: _quotas[type.id],
        used: _usedDays(employeeId, type.id),
        remaining: _quotas[type.id] == null
            ? null
            : _quotas[type.id]! - _usedDays(employeeId, type.id),
      ),
  ];

  /// Leave history, as shown on the profile.
  List<LeaveHistoryItemModel> history(String employeeId) => [
    for (final l
        in _leaves.where((l) => l.employee.id == employeeId).toList()
          ..sort((a, b) => b.startDate.compareTo(a.startDate)))
      LeaveHistoryItemModel(
        id: l.id,
        startDate: l.startDate,
        endDate: l.endDate,
        leaveType: l.leaveType.name,
        days: l.days,
        reason: [l.reason.label, ?l.remarks].join(' · '),
        status: l.status,
      ),
  ];

  // --------------------------------------------------------------- saving

  void _validate(LeaveFormData data, {String? exceptId}) {
    final employee = _employee(data.employeeId);
    if (employee.status != EmployeeStatus.active) {
      throw const ValidationException(
        'Leave can only be added for active employees.',
        fieldErrors: {'employeeId': 'This employee is inactive'},
      );
    }
    final type = _type(data.leaveTypeId);
    final end = data.isHalfDay ? data.startDate : data.endDate;
    if (end.isBefore(data.startDate)) {
      throw const ValidationException(
        'The end date must be on or after the start date.',
        fieldErrors: {'endDate': 'Must be on or after the start date'},
      );
    }
    final days = countDays(
      data.employeeId,
      data.startDate,
      end,
      isHalfDay: data.isHalfDay,
    );
    if (days == 0) {
      throw const ValidationException(
        'The selected dates are all holidays or weekly offs.',
        fieldErrors: {'startDate': 'No working days selected'},
      );
    }
    final overlaps = _leaves.any(
      (l) =>
          l.id != exceptId &&
          l.employee.id == data.employeeId &&
          (l.status == LeaveStatus.approved ||
              l.status == LeaveStatus.pending) &&
          !l.endDate.isBefore(data.startDate.dateOnly) &&
          !l.startDate.isAfter(end.dateOnly),
    );
    if (overlaps) {
      throw const ValidationException(
        'This employee already has leave on some of these dates.',
        fieldErrors: {'startDate': 'Overlaps another leave'},
      );
    }
    final quota = _quotas[type.id];
    if (quota != null) {
      final left =
          quota - _usedDays(data.employeeId, type.id, exceptId: exceptId);
      if (days > left) {
        throw ValidationException(
          'Not enough ${type.name} balance: ${FormatUtils.days(left)} left.',
          fieldErrors: {'leaveTypeId': 'Only ${FormatUtils.days(left)} left'},
        );
      }
    }
  }

  @override
  Future<LeaveModel> create(LeaveFormData data) async {
    await _wait();
    guard.require(AppPermission.leaveCreate);
    _validate(data);
    final leave = _build(
      employee: _employee(data.employeeId),
      typeId: data.leaveTypeId,
      start: data.startDate,
      end: data.endDate,
      reason: data.reason,
      status: data.status,
      addedBy: _admin,
      halfDay: data.isHalfDay,
      remarks: data.remarks,
    );
    _leaves.add(leave);
    _audit('leave.create', '${leave.leaveType.name} leave added', leave);
    return leave;
  }

  @override
  Future<LeaveModel> update(String id, LeaveFormData data) async {
    await _wait();
    guard.require(AppPermission.leaveEdit);
    final current = _find(id);
    // The server's rule: only pending leave is edited; approved or
    // rejected leave would need a separate correction process.
    if (current.status != LeaveStatus.pending) {
      throw ValidationException(
        'Only pending leave can be edited. This leave is already '
        '${current.status.label.toLowerCase()}.',
        code: ApiConstants.leaveNotEditableCode,
      );
    }
    _validate(data, exceptId: id);
    final updated = _build(
      id: id,
      employee: _employee(data.employeeId),
      typeId: data.leaveTypeId,
      start: data.startDate,
      end: data.endDate,
      reason: data.reason,
      status: data.status,
      addedBy: current.addedBy ?? _admin,
      halfDay: data.isHalfDay,
      remarks: data.remarks,
    );
    _leaves[_leaves.indexOf(current)] = updated;
    _audit(
      'leave.update',
      '${updated.leaveType.name} leave edited',
      updated,
      before: current,
    );
    return updated;
  }

  @override
  Future<LeaveModel> setStatus(String id, LeaveStatus status) async {
    await _wait();
    guard.require(
      status == LeaveStatus.cancelled
          ? AppPermission.leaveCancel
          : AppPermission.leaveApprove,
    );
    final current = _find(id);
    final allowed = switch (current.status) {
      LeaveStatus.pending => {
        LeaveStatus.approved,
        LeaveStatus.rejected,
        LeaveStatus.cancelled,
      },
      LeaveStatus.approved => {LeaveStatus.cancelled},
      _ => <LeaveStatus>{},
    };
    if (!allowed.contains(status)) {
      throw ValidationException(
        'A ${current.status.label.toLowerCase()} leave cannot be '
        '${status.label.toLowerCase()}.',
      );
    }
    final updated = current.copyWith(status: status);
    _leaves[_leaves.indexOf(current)] = updated;
    _audit(
      'leave.status',
      '${updated.leaveType.name} leave ${status.label.toLowerCase()}',
      updated,
      before: current,
    );
    return updated;
  }

  // ---------------------------------------------------------------- lookup

  @override
  Future<List<LeaveTypeModel>> types() async {
    await _wait();
    guard.require(AppPermission.leaveView);
    return leaveTypes;
  }

  @override
  Future<LeavePreviewModel> preview(LeavePreviewRequest request) async {
    await _wait();
    guard.requireAny(const [
      AppPermission.leaveCreate,
      AppPermission.leaveEdit,
    ]);
    final end = request.isHalfDay ? request.startDate : request.endDate;
    final days = end.isBefore(request.startDate)
        ? 0.0
        : countDays(
            request.employeeId,
            request.startDate,
            end,
            isHalfDay: request.isHalfDay,
          );
    final quota = _quotas[request.leaveTypeId];
    final before = quota == null
        ? null
        : quota -
              _usedDays(
                request.employeeId,
                request.leaveTypeId,
                exceptId: request.leaveId,
              );
    return LeavePreviewModel(
      days: days,
      balanceBefore: before,
      balanceAfter: before == null ? null : before - days,
    );
  }

  @override
  Future<LeaveCalendarModel> calendar(
    DateTime month, {
    String? employeeId,
  }) async {
    await _wait();
    guard.require(AppPermission.leaveView);
    final first = month.monthStart;
    final dates = [
      for (
        var date = first;
        date.month == first.month;
        date = DateTime(date.year, date.month, date.day + 1)
      )
        date,
    ];
    return LeaveCalendarModel(
      month: first,
      holidays: [
        for (final h in holidays.list(year: month.year))
          if (h.date.month == month.month) h,
      ],
      weeklyOffDays: employeeId == null
          ? const []
          : schedules.on(employeeId, first)?.weeklyOffDays ?? const [],
      weekOffDates: employeeId == null
          ? const []
          : [
              for (final date in dates)
                if (_isWeekOff(employeeId, date)) date,
            ],
    );
  }

  /// DEV ONLY: the approved leave on [date] for the attendance mock (the
  /// backend's "approved leave" input to computeDay).
  DayLeave leaveOn(String employeeId, DateTime date) {
    final day = date.dateOnly;
    final leave = _leaves
        .where(
          (l) =>
              l.employee.id == employeeId &&
              l.status == LeaveStatus.approved &&
              !day.isBefore(l.startDate) &&
              !day.isAfter(l.endDate),
        )
        .firstOrNull;
    if (leave == null) return DayLeave.none;
    return leave.isHalfDay ? DayLeave.halfDay : DayLeave.fullDay;
  }

  /// DEV ONLY: every leave of [employeeId] (any status) touching
  /// [from]–[to], for the calendar mock.
  List<LeaveModel> leavesOf(String employeeId, DateTime from, DateTime to) =>
      _leaves
          .where(
            (l) =>
                l.employee.id == employeeId &&
                !l.endDate.isBefore(from.dateOnly) &&
                !l.startDate.isAfter(to.dateOnly),
          )
          .toList();
}
