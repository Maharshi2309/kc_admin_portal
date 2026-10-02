import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_guard.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/employee_remote_data_source.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/mock_schedule_book.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/employees/domain/utils/schedule_rules.dart';
import 'package:kc_admin_portal/features/holidays/data/datasources/mock_holiday_store.dart';
import 'package:kc_admin_portal/features/leave/data/datasources/leave_mock_data_source.dart';
import 'package:kc_admin_portal/features/master_data/data/datasources/master_data_mock_data_source.dart';
import 'package:kc_admin_portal/shared/models/leave_balance_model.dart';
import 'package:kc_admin_portal/shared/models/named_ref.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/models/work_schedule_model.dart';

/// DEV ONLY (`USE_MOCK_API=true`): an in-memory employee store that behaves
/// like the assumed API (search, filters, paging, duplicate checks), so the
/// screens can be built and tried before the backend exists. Sample data is
/// illustrative. Changes last until the app restarts.
class EmployeeMockDataSource implements EmployeeRemoteDataSource {
  /// Checks the signed-in user's permissions, like the backend (§4.2).
  final MockGuard guard;

  EmployeeMockDataSource({
    this.guard = const MockGuard.allowAll(),
    required this.now,
    this.latency = Duration.zero,
    List<EmployeeModel>? store,
    this.leaves,
    MockScheduleBook? schedules,
    this.holidays,
  }) : _employees = store ?? seed(now()),
       _schedules = schedules ?? _seededBook(now, store ?? seed(now()));

  final DateTime Function() now;
  final Duration latency;

  /// Shared with the other dev mocks (see [mockEmployeeStoreProvider]).
  final List<EmployeeModel> _employees;

  /// When set, balances and history come from the leave mock, so they
  /// change as leave is added.
  final LeaveMockDataSource? leaves;

  /// Schedule versions (shared with the attendance mock in the app).
  final MockScheduleBook _schedules;

  /// Company holidays, when shared with the holiday mock.
  final MockHolidayStore? holidays;

  static MockScheduleBook _seededBook(
    DateTime Function() now,
    List<EmployeeModel> employees,
  ) =>
      MockScheduleBook(now: now)
        ..seed([for (final e in employees) (id: e.id, joined: e.joiningDate)]);

  /// The employee with today's schedule, as the API returns it.
  EmployeeModel _withSchedule(EmployeeModel employee) =>
      employee.copyWith(schedule: _schedules.on(employee.id, now()));

  static const String _ecPrefix = 'KC';

  // (name, departmentId, designationId, mobile, joined, status, today)
  static final List<(String, String, String, String, DateTime, bool)> _people =
      [
        (
          'Aarav Shah',
          'it',
          'senior-developer',
          '9825011234',
          DateTime(2021, 1, 12),
          true,
        ),
        (
          'Priya Desai',
          'operations',
          'operations-executive',
          '9879520417',
          DateTime(2021, 6, 3),
          true,
        ),
        (
          'Rohan Patel',
          'sales',
          'sales-manager',
          '9909044120',
          DateTime(2022, 11, 18),
          true,
        ),
        (
          'Kavya Mehta',
          'accounts',
          'accountant',
          '9727730981',
          DateTime(2023, 3, 9),
          true,
        ),
        (
          'Harsh Vaghela',
          'it',
          'qa-engineer',
          '9099081264',
          DateTime(2023, 5, 22),
          true,
        ),
        (
          'Meera Rathod',
          'hr',
          'hr-executive',
          '9898056310',
          DateTime(2023, 8, 1),
          true,
        ),
        (
          'Arjun Joshi',
          'operations',
          'supervisor',
          '9327011845',
          DateTime(2023, 12, 14),
          true,
        ),
        (
          'Dhruv Parmar',
          'sales',
          'sales-executive',
          '9714062209',
          DateTime(2024, 2, 5),
          true,
        ),
        (
          'Nisha Solanki',
          'hr',
          'recruiter',
          '9824177053',
          DateTime(2024, 6, 17),
          true,
        ),
        (
          'Sanjay Makwana',
          'accounts',
          'accounts-assistant',
          '9662048117',
          DateTime(2024, 9, 2),
          true,
        ),
        (
          'Ishaan Trivedi',
          'it',
          'senior-developer',
          '9825502211',
          DateTime(2022, 4, 11),
          true,
        ),
        (
          'Ananya Bhatt',
          'sales',
          'sales-executive',
          '9978812345',
          DateTime(2022, 7, 25),
          true,
        ),
        (
          'Vivek Chauhan',
          'operations',
          'supervisor',
          '9426055123',
          DateTime(2020, 10, 5),
          true,
        ),
        (
          'Riya Pandya',
          'accounts',
          'accountant',
          '9737011122',
          DateTime(2021, 12, 1),
          true,
        ),
        (
          'Karan Thakkar',
          'it',
          'qa-engineer',
          '9898765432',
          DateTime(2024, 1, 15),
          true,
        ),
        (
          'Pooja Jadeja',
          'hr',
          'hr-executive',
          '9510022334',
          DateTime(2025, 3, 3),
          true,
        ),
        (
          'Manav Dave',
          'operations',
          'operations-executive',
          '9624412233',
          DateTime(2025, 6, 9),
          true,
        ),
        (
          'Sneha Raval',
          'sales',
          'sales-manager',
          '9909911223',
          DateTime(2019, 8, 19),
          true,
        ),
        (
          'Yash Gohil',
          'operations',
          'operations-executive',
          '9825133221',
          DateTime(2025, 9, 1),
          true,
        ),
        (
          'Tanvi Oza',
          'accounts',
          'accounts-assistant',
          '9879001122',
          DateTime(2022, 2, 14),
          false,
        ),
        (
          'Nirav Shukla',
          'it',
          'senior-developer',
          '9428011233',
          DateTime(2020, 5, 4),
          false,
        ),
        (
          'Hetal Vyas',
          'sales',
          'sales-executive',
          '9537744556',
          DateTime(2021, 9, 20),
          false,
        ),
      ];

  static const List<AttendanceDayStatus> _todayCycle = [
    AttendanceDayStatus.present,
    AttendanceDayStatus.present,
    AttendanceDayStatus.absent,
    AttendanceDayStatus.present,
    AttendanceDayStatus.onLeave,
    AttendanceDayStatus.present,
    AttendanceDayStatus.late,
    AttendanceDayStatus.halfDay,
  ];

  /// The sample employees, also used by other dev mocks (attendance) so
  /// they show the same people.
  static List<EmployeeModel> seed(DateTime today) => [
    for (var i = 0; i < _people.length; i++)
      _build(
        id: '${i + 1}',
        ecNumber: '$_ecPrefix${1001 + i * 3}',
        person: _people[i],
        today: _people[i].$6 ? _todayCycle[i % _todayCycle.length] : null,
        updatedAt: today.subtract(Duration(days: 10 + i)),
      ),
  ];

  static EmployeeModel _build({
    required String id,
    required String ecNumber,
    required (String, String, String, String, DateTime, bool) person,
    AttendanceDayStatus? today,
    DateTime? updatedAt,
  }) {
    final (name, departmentId, designationId, mobile, joined, active) = person;
    final email = '${name.toLowerCase().replaceAll(' ', '.')}@keshav.in';
    return EmployeeModel(
      id: id,
      ecNumber: ecNumber,
      name: name,
      email: email,
      mobile: mobile,
      department: _department(departmentId),
      designation: _designation(departmentId, designationId),
      joiningDate: joined,
      status: active ? EmployeeStatus.active : EmployeeStatus.inactive,
      todayStatus: today,
      updatedAt: updatedAt,
      updatedBy: 'Admin',
    );
  }

  static NamedRef _department(String id) {
    final department = MasterDataMockDataSource.sampleDepartments
        .where((d) => d.id == id)
        .firstOrNull;
    if (department == null) {
      throw const ValidationException(
        'Choose a department',
        fieldErrors: {'departmentId': 'Choose a department'},
      );
    }
    return NamedRef(id: department.id, name: department.name);
  }

  static NamedRef _designation(String departmentId, String id) {
    final designation = MasterDataMockDataSource
        .sampleDesignations[departmentId]
        ?.where((d) => d.id == id)
        .firstOrNull;
    if (designation == null) {
      throw const ValidationException(
        'Choose a designation of the selected department',
        fieldErrors: {'designationId': 'Choose a designation'},
      );
    }
    return NamedRef(id: designation.id, name: designation.name);
  }

  Future<void> _wait() => Future<void>.delayed(latency);

  EmployeeModel _find(String id) {
    final employee = _employees.where((e) => e.id == id).firstOrNull;
    if (employee == null) {
      throw const NotFoundException('This employee could not be found.');
    }
    return employee;
  }

  /// Rejects duplicate EC numbers and emails, like a real server would.
  void _checkUnique(EmployeeFormData data, {String? exceptId}) {
    final others = _employees.where((e) => e.id != exceptId);
    final errors = <String, String>{
      if (others.any((e) => e.ecNumber == data.ecNumber))
        'ecNumber': 'This EC number is already in use',
      if (others.any((e) => e.email.toLowerCase() == data.email.toLowerCase()))
        'email': 'This email is already in use',
    };
    if (errors.isNotEmpty) {
      throw ValidationException(errors.values.first, fieldErrors: errors);
    }
  }

  @override
  Future<EmployeeListModel> list(EmployeeQuery query) async {
    await _wait();
    guard.require(AppPermission.employeeView);
    final search = query.search.trim().toLowerCase();
    final joinedFrom = query.joinedFrom;
    final joinedTo = query.joinedTo;
    final filtered = _employees
        .where(
          (e) =>
              search.isEmpty ||
              e.name.toLowerCase().contains(search) ||
              e.ecNumber.toLowerCase().contains(search),
        )
        .where(
          (e) =>
              query.departmentId == null ||
              e.department.id == query.departmentId,
        )
        .where(
          (e) =>
              query.designationId == null ||
              e.designation.id == query.designationId,
        )
        .where(
          (e) =>
              (joinedFrom == null || !e.joiningDate.isBefore(joinedFrom)) &&
              (joinedTo == null || !e.joiningDate.isAfter(joinedTo)),
        )
        .toList();
    final matches =
        filtered
            .where((e) => query.status == null || e.status == query.status)
            .toList()
          ..sort((a, b) => a.ecNumber.compareTo(b.ecNumber));

    final start = math.min((query.page - 1) * query.pageSize, matches.length);
    final end = math.min(start + query.pageSize, matches.length);
    return EmployeeListModel(
      items: matches.sublist(start, end).map(_withSchedule).toList(),
      total: matches.length,
      page: query.page,
      pageSize: query.pageSize,
      counts: EmployeeStatusCounts(
        active: filtered.where((e) => e.status == EmployeeStatus.active).length,
        inactive: filtered
            .where((e) => e.status == EmployeeStatus.inactive)
            .length,
      ),
    );
  }

  @override
  Future<EmployeeModel> getById(String id) async {
    await _wait();
    guard.require(AppPermission.employeeView);
    return _withSchedule(_find(id));
  }

  @override
  Future<String> nextEcNumber() async {
    await _wait();
    guard.require(AppPermission.employeeView);
    final highest = _employees
        .map((e) => int.tryParse(e.ecNumber.substring(_ecPrefix.length)) ?? 0)
        .fold(0, math.max);
    return '$_ecPrefix${highest + 1}';
  }

  @override
  Future<EmployeeModel> create(EmployeeFormData data) async {
    await _wait();
    guard.require(AppPermission.employeeCreate);
    _checkUnique(data);
    final schedule = data.schedule;
    if (schedule == null) {
      throw const ValidationException(
        'Set the working schedule',
        fieldErrors: {'schedule': 'Set the working schedule'},
      );
    }
    final problems = scheduleProblems(schedule);
    if (problems.isNotEmpty) {
      throw ValidationException(
        problems.values.first,
        fieldErrors: {
          for (final MapEntry(:key, :value) in problems.entries)
            'schedule.$key': value,
        },
      );
    }
    final employee = EmployeeModel(
      id: '${_employees.length + 1}',
      ecNumber: data.ecNumber,
      name: data.name,
      email: data.email,
      mobile: data.mobile,
      department: _department(data.departmentId),
      designation: _designation(data.departmentId, data.designationId),
      joiningDate: data.joiningDate,
      status: data.status,
      updatedAt: now(),
      updatedBy: 'Admin',
    );
    _employees.add(employee);
    _schedules.add(employee.id, schedule);
    return _withSchedule(employee);
  }

  @override
  Future<EmployeeModel> update(String id, EmployeeFormData data) async {
    await _wait();
    guard.require(AppPermission.employeeEdit);
    final current = _find(id);
    _checkUnique(data, exceptId: id);
    final updated = current.copyWith(
      ecNumber: data.ecNumber,
      name: data.name,
      email: data.email,
      mobile: data.mobile,
      department: _department(data.departmentId),
      designation: _designation(data.departmentId, data.designationId),
      joiningDate: data.joiningDate,
      status: data.status,
      updatedAt: now(),
      updatedBy: 'Admin',
    );
    _employees[_employees.indexOf(current)] = updated;
    return _withSchedule(updated);
  }

  @override
  Future<EmployeeModel> setStatus(String id, EmployeeStatus status) async {
    await _wait();
    guard.require(AppPermission.employeeDeactivate);
    final current = _find(id);
    final updated = current.copyWith(
      status: status,
      updatedAt: now(),
      updatedBy: 'Admin',
    );
    _employees[_employees.indexOf(current)] = updated;
    return _withSchedule(updated);
  }

  @override
  Future<List<LeaveBalanceModel>> leaveBalance(String id) async {
    await _wait();
    guard.require(AppPermission.employeeView);
    _find(id);
    final source = leaves;
    if (source != null) return source.balances(id);
    return const [
      LeaveBalanceModel(
        leaveType: 'Casual leave',
        quota: 12,
        used: 5,
        remaining: 7,
      ),
      LeaveBalanceModel(
        leaveType: 'Sick leave',
        quota: 8,
        used: 2,
        remaining: 6,
      ),
      LeaveBalanceModel(
        leaveType: 'Earned leave',
        quota: 15,
        used: 2,
        remaining: 13,
      ),
      LeaveBalanceModel(leaveType: 'Unpaid leave', used: 0),
    ];
  }

  @override
  Future<List<LeaveHistoryItemModel>> leaveHistory(String id) async {
    await _wait();
    guard.require(AppPermission.employeeView);
    _find(id);
    final source = leaves;
    if (source != null) return source.history(id);
    final year = now().year;
    LeaveHistoryItemModel item(
      int n,
      DateTime start,
      DateTime end,
      String type,
      double days,
      String reason,
    ) => LeaveHistoryItemModel(
      id: '$id-$n',
      startDate: start,
      endDate: end,
      leaveType: type,
      days: days,
      reason: reason,
      status: LeaveStatus.approved,
    );
    return [
      item(
        1,
        DateTime(year, 9, 21),
        DateTime(year, 9, 22),
        'Casual',
        2,
        'Family function',
      ),
      item(
        2,
        DateTime(year, 8, 11),
        DateTime(year, 8, 11),
        'Casual',
        1,
        'Personal work',
      ),
      item(3, DateTime(year, 7, 4), DateTime(year, 7, 4), 'Sick', 1, 'Medical'),
      item(
        4,
        DateTime(year, 5, 14),
        DateTime(year, 5, 15),
        'Earned',
        2,
        'Travel',
      ),
      item(
        5,
        DateTime(year, 3, 2),
        DateTime(year, 3, 3),
        'Casual',
        2,
        'Family function',
      ),
      item(
        6,
        DateTime(year, 2, 16),
        DateTime(year, 2, 16),
        'Sick',
        1,
        'Medical',
      ),
    ];
  }

  @override
  Future<List<WorkScheduleModel>> schedules(String id) async {
    await _wait();
    guard.require(AppPermission.employeeView);
    _find(id);
    return _schedules.versions(id);
  }

  @override
  Future<WorkScheduleModel> addSchedule(
    String id,
    WorkScheduleInput input,
  ) async {
    await _wait();
    guard.require(AppPermission.scheduleEdit);
    _find(id);
    return _schedules.add(id, input);
  }
}

/// DEV ONLY: the one list of sample employees shared by the employee,
/// attendance and leave mocks, so changes in one show up in the others.
final mockEmployeeStoreProvider = Provider<List<EmployeeModel>>(
  (ref) => EmployeeMockDataSource.seed(ref.watch(clockProvider)()),
);
