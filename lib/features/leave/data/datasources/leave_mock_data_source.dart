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
import 'package:kc_admin_portal/features/leave/data/datasources/mock_leave_accrual.dart';
import 'package:kc_admin_portal/features/leave/data/models/leave_models.dart';
import 'package:kc_admin_portal/shared/mock/mock_audit_log.dart';
import 'package:kc_admin_portal/shared/models/audit_entry_model.dart';
import 'package:kc_admin_portal/shared/models/employee_summary_model.dart';
import 'package:kc_admin_portal/shared/models/leave_balance_model.dart';
import 'package:kc_admin_portal/shared/models/named_ref.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

/// DEV ONLY (`USE_MOCK_API=true`): in-memory leave records playing the
/// backend's role: it counts days (weekly offs and holidays excluded),
/// applies the paid-leave rules ([LeaveAccrual]: 1 Casual day a month,
/// no future months), checks overlaps, and enforces status changes.
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

  /// The only two types (requirement 2026-10-05).
  static const List<LeaveTypeModel> leaveTypes = [
    LeaveTypeModel(id: casualId, name: 'Casual'),
    LeaveTypeModel(
      id: unpaidId,
      name: 'Unpaid',
      hasBalance: false,
      isPaid: false,
    ),
  ];

  static const String casualId = 'casual';
  static const String unpaidId = 'unpaid';

  /// The company's accrual start (`leave_accrual_start_month`): January
  /// 2026 in the mock.
  static final LeaveAccrual accrual = LeaveAccrual(policyStart: DateTime(2026));

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
    department: e.department,
    position: e.position,
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
      isPaid: type.isPaid,
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
            'casual',
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
            'casual',
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
            'casual',
            d(9, 15),
            d(9, 15),
            LeaveStatus.pending,
            _employeeRequest,
            LeaveReason.medical,
            false,
          ),
          (
            'Priya Desai',
            'unpaid',
            d(8, 3),
            d(8, 4),
            LeaveStatus.approved,
            _admin,
            LeaveReason.personalWork,
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
            'casual',
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
            'casual',
            d(7, 4),
            d(7, 4),
            LeaveStatus.approved,
            _admin,
            LeaveReason.medical,
            false,
          ),
          (
            'Aarav Shah',
            'casual',
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
            'casual',
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
        (query.department == null ||
            _employee(leave.employee.id).department == query.department);
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
      items: [for (final l in rows.sublist(start, end)) _withBalance(l)],
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
    return _withBalance(_find(id));
  }

  /// Pending requests, for the dashboard's "Needs your attention".
  int get pendingCount =>
      _leaves.where((l) => l.status == LeaveStatus.pending).length;

  // ------------------------------------------------------------ balances

  bool _counts(LeaveModel l) =>
      l.status == LeaveStatus.approved || l.status == LeaveStatus.pending;

  /// Each working day of a leave (weekly offs and holidays left out).
  List<LeaveDay> _daysOf(
    String employeeId,
    DateTime start,
    DateTime end, {
    required bool isHalfDay,
  }) {
    if (isHalfDay) {
      return [
        if (_isWorkingDay(employeeId, start)) (date: start.dateOnly, days: 0.5),
      ];
    }
    return [
      for (
        var date = start.dateOnly;
        !date.isAfter(end.dateOnly);
        date = DateTime(date.year, date.month, date.day + 1)
      )
        if (_isWorkingDay(employeeId, date)) (date: date, days: 1.0),
    ];
  }

  /// The employee's Casual leave that holds balance (approved + pending).
  List<LeaveDay> _casualDays(String employeeId, {String? exceptId}) => [
    for (final l in _leaves)
      if (l.id != exceptId &&
          l.employee.id == employeeId &&
          l.leaveType.id == casualId &&
          _counts(l))
        ..._daysOf(employeeId, l.startDate, l.endDate, isHalfDay: l.isHalfDay),
  ];

  double _sum(Iterable<LeaveModel> leaves) =>
      leaves.fold(0, (sum, l) => sum + l.days);

  /// `GET /employees/{id}/leave-balance`: calculated, never stored.
  LeaveBalanceModel balance(String employeeId) {
    final employee = _employee(employeeId);
    final today = now().dateOnly;
    final mine = _leaves.where((l) => l.employee.id == employeeId);
    bool casual(LeaveModel l) => l.leaveType.id == casualId;
    final accrued = accrual.accruedThrough(employee.joiningDate, today);
    final used = _sum(
      mine.where((l) => casual(l) && l.status == LeaveStatus.approved),
    );
    final pending = _sum(
      mine.where((l) => casual(l) && l.status == LeaveStatus.pending),
    );
    return LeaveBalanceModel(
      asOf: today,
      accrued: accrued,
      used: used,
      pending: pending,
      remaining: accrued - used - pending,
      unpaidTaken: _sum(
        mine.where(
          (l) => l.leaveType.id == unpaidId && l.status == LeaveStatus.approved,
        ),
      ),
    );
  }

  /// Casual days left after [l], counting Casual leave in date order.
  double? _balanceAfter(LeaveModel l) {
    if (l.leaveType.id != casualId || !_counts(l)) return null;
    return accrual.balanceAfter(
      _casualDays(l.employee.id),
      _employee(l.employee.id).joiningDate,
      l.endDate,
    );
  }

  LeaveModel _withBalance(LeaveModel l) =>
      l.copyWith(balanceAfter: _balanceAfter(l));

  /// Active employees matching [query], by name (inactive employees earn
  /// nothing and are left out; TODO — REQUIREMENT CONFIRMATION REQUIRED).
  List<EmployeeModel> _balanceEmployees(LeaveBalanceQuery query) {
    final search = query.search.trim().toLowerCase();
    return employees
        .where(
          (e) =>
              e.status == EmployeeStatus.active &&
              (search.isEmpty ||
                  e.name.toLowerCase().contains(search) ||
                  e.ecNumber.toLowerCase().contains(search)) &&
              (query.department == null || e.department == query.department),
        )
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Future<LeaveBalanceListModel> balances(LeaveBalanceQuery query) async {
    await _wait();
    guard.require(AppPermission.leaveView);
    final rows = [
      for (final e in _balanceEmployees(query))
        EmployeeLeaveBalanceModel(
          employee: _summary(e),
          balance: balance(e.id),
        ),
    ];
    double sum(double Function(LeaveBalanceModel b) of) =>
        rows.fold(0, (total, r) => total + of(r.balance));
    final start = math.min((query.page - 1) * query.pageSize, rows.length);
    final end = math.min(start + query.pageSize, rows.length);
    return LeaveBalanceListModel(
      items: rows.sublist(start, end),
      total: rows.length,
      page: query.page,
      pageSize: query.pageSize,
      summary: LeaveBalanceTotalsModel(
        employees: rows.length,
        accrued: sum((b) => b.accrued),
        used: sum((b) => b.used),
        pending: sum((b) => b.pending),
        remaining: sum((b) => b.remaining),
        unpaidTaken: sum((b) => b.unpaidTaken),
      ),
    );
  }

  /// The dashboard's leave figures (`leaveUsage` in the summary):
  /// - Casual left today across active employees;
  /// - approved Casual and Unpaid days dated in [today]'s year;
  /// - leave requests overlapping [today]'s month, by status.
  ({
    double casualRemaining,
    double casualTaken,
    double unpaidTaken,
    int approved,
    int pending,
    int rejected,
  })
  usage(DateTime today) {
    final active = _balanceEmployees(const LeaveBalanceQuery());
    final yearStart = DateTime(today.year);
    final yearEnd = DateTime(today.year, 12, 31);
    double takenThisYear(String typeId) => [
      for (final l in _leaves)
        if (l.leaveType.id == typeId && l.status == LeaveStatus.approved)
          for (final d in _daysOf(
            l.employee.id,
            l.startDate,
            l.endDate,
            isHalfDay: l.isHalfDay,
          ))
            if (!d.date.isBefore(yearStart) && !d.date.isAfter(yearEnd)) d.days,
    ].fold(0, (sum, d) => sum + d);
    final monthStart = today.monthStart;
    final monthEnd = DateTime(today.year, today.month + 1, 0);
    int thisMonth(LeaveStatus status) => _leaves
        .where(
          (l) =>
              l.status == status &&
              !l.endDate.isBefore(monthStart) &&
              !l.startDate.isAfter(monthEnd),
        )
        .length;
    return (
      casualRemaining: active.fold(
        0,
        (sum, e) => sum + balance(e.id).remaining,
      ),
      casualTaken: takenThisYear(casualId),
      unpaidTaken: takenThisYear(unpaidId),
      approved: thisMonth(LeaveStatus.approved),
      pending: thisMonth(LeaveStatus.pending),
      rejected: thisMonth(LeaveStatus.rejected),
    );
  }

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
        isPaid: l.isPaid,
        balanceAfter: _balanceAfter(l),
      ),
  ];

  /// How many of these days Casual can cover now (the rest would be
  /// Unpaid), next to the employee's other Casual leave.
  double _paidPart(
    String employeeId,
    DateTime start,
    DateTime end, {
    required bool isHalfDay,
    String? exceptId,
  }) => accrual.paidPart(
    _daysOf(employeeId, start, end, isHalfDay: isHalfDay),
    _casualDays(employeeId, exceptId: exceptId),
    _employee(employeeId).joiningDate,
  );

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
    if (type.id == casualId && data.splitExcessAsUnpaid != true) {
      final paid = _paidPart(
        data.employeeId,
        data.startDate,
        end,
        isHalfDay: data.isHalfDay,
        exceptId: exceptId,
      );
      if (paid < days) {
        throw ValidationException(
          paid == 0
              ? 'No Casual leave is available for these dates. Save them '
                    'as Unpaid leave instead?'
              : 'Only ${FormatUtils.days(paid)} of Casual leave '
                    '${paid == 1 ? 'is' : 'are'} available for these dates. '
                    'Save the other ${FormatUtils.days(days - paid)} as '
                    'Unpaid leave?',
          code: ApiConstants.insufficientLeaveBalanceCode,
        );
      }
    }
  }

  /// Saves [data], splitting Casual leave that doesn't fit into a Casual
  /// part (the earliest days) and an Unpaid part (the rest). Returns the
  /// saved leave; [unpaidPartId] links the Unpaid part.
  LeaveModel _save(LeaveFormData data, {LeaveModel? current}) {
    final employee = _employee(data.employeeId);
    final end = data.isHalfDay ? data.startDate : data.endDate;
    var typeId = data.leaveTypeId;
    LeaveModel? unpaid;
    var casualEnd = end;
    if (typeId == casualId && data.splitExcessAsUnpaid == true) {
      final days = _daysOf(
        data.employeeId,
        data.startDate,
        end,
        isHalfDay: data.isHalfDay,
      );
      final paid = _paidPart(
        data.employeeId,
        data.startDate,
        end,
        isHalfDay: data.isHalfDay,
        exceptId: current?.id,
      );
      if (paid == 0) {
        typeId = unpaidId;
      } else if (paid < days.fold<double>(0, (s, d) => s + d.days)) {
        // The Casual part ends on its last covered day; the Unpaid part
        // takes the rest of the range.
        var covered = 0.0;
        for (final d in days) {
          covered += d.days;
          if (covered >= paid) {
            casualEnd = d.date;
            break;
          }
        }
        final unpaidStart = days.firstWhere((d) => d.date.isAfter(casualEnd));
        unpaid = _build(
          employee: employee,
          typeId: unpaidId,
          start: unpaidStart.date,
          end: end,
          reason: data.reason,
          status: data.status,
          addedBy: current?.addedBy ?? _admin,
          remarks: data.remarks,
        );
      }
    }
    final saved = _build(
      id: current?.id,
      employee: employee,
      typeId: typeId,
      start: data.startDate,
      end: casualEnd,
      reason: data.reason,
      status: data.status,
      addedBy: current?.addedBy ?? _admin,
      halfDay: data.isHalfDay,
      remarks: data.remarks,
    ).copyWith(unpaidPartId: unpaid?.id);
    if (current == null) {
      _leaves.add(saved);
    } else {
      _leaves[_leaves.indexOf(current)] = saved;
    }
    if (unpaid != null) {
      _leaves.add(unpaid);
      _audit('leave.create', 'Unpaid leave added (split)', unpaid);
    }
    return saved;
  }

  @override
  Future<LeaveModel> create(LeaveFormData data) async {
    await _wait();
    guard.require(AppPermission.leaveCreate);
    _validate(data);
    final leave = _save(data);
    _audit('leave.create', '${leave.leaveType.name} leave added', leave);
    return _withBalance(leave);
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
    final updated = _save(data, current: current);
    _audit(
      'leave.update',
      '${updated.leaveType.name} leave edited',
      updated,
      before: current,
    );
    return _withBalance(updated);
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
    return _withBalance(updated);
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
    if (request.leaveTypeId != casualId || days == 0) {
      return LeavePreviewModel(
        days: days,
        unpaidDays: request.leaveTypeId == casualId ? 0 : days,
      );
    }
    final paid = _paidPart(
      request.employeeId,
      request.startDate,
      end,
      isHalfDay: request.isHalfDay,
      exceptId: request.leaveId,
    );
    final employee = _employee(request.employeeId);
    final existing = _casualDays(request.employeeId, exceptId: request.leaveId);
    final available = paid < days
        ? paid
        : accrual.balanceAfter(existing, employee.joiningDate, end);
    return LeavePreviewModel(
      days: days,
      paidDays: paid,
      unpaidDays: days - paid,
      availableCasual: available,
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
