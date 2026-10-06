import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/shared/mock/mock_audit_log.dart';
import 'package:kc_admin_portal/shared/mock/mock_tenant.dart';
import 'package:kc_admin_portal/shared/models/audit_entry_model.dart';
import 'package:kc_admin_portal/shared/models/holiday_model.dart';

/// DEV ONLY (`USE_MOCK_API=true`): the company holidays, playing the
/// backend's role (docs/DATABASE_V2.md §2.2): one holiday per date, soft
/// deletes, and a change notice so other mocks recalculate the affected
/// days (§3.5), like the server does.
class MockHolidayStore {
  MockHolidayStore({
    required DateTime Function() now,
    this.audit,
    List<(int month, int day, String name)> extra = const [],
  }) {
    final year = now().year;
    for (final y in [year - 1, year, year + 1]) {
      _add(y, 1, 26, 'Republic Day');
      _add(y, 8, 15, 'Independence Day');
      _add(y, 10, 2, 'Gandhi Jayanti');
      for (final (month, day, name) in extra) {
        _add(y, month, day, name);
      }
    }
  }

  final List<HolidayModel> _holidays = [];

  /// The change history, when shared.
  final MockAuditLog? audit;
  final List<void Function()> _listeners = [];
  int _nextId = 1;

  static const int nameMaxLength = 100;

  void _add(int year, int month, int day, String name) => _holidays.add(
    HolidayModel(
      id: 'h${_nextId++}',
      date: DateTime(year, month, day),
      name: name,
    ),
  );

  /// Called after every change (the server's recalculation hook).
  void addListener(void Function() listener) => _listeners.add(listener);

  void _changed() {
    for (final listener in _listeners) {
      listener();
    }
  }

  /// The holiday on [date], if any.
  HolidayModel? on(DateTime date) {
    final day = date.dateOnly;
    return _holidays.where((h) => h.date == day).firstOrNull;
  }

  /// Sorted by date; [year] and [search] (name) optional.
  List<HolidayModel> list({int? year, String search = ''}) {
    final text = search.trim().toLowerCase();
    return _holidays
        .where((h) => year == null || h.date.year == year)
        .where((h) => text.isEmpty || h.name.toLowerCase().contains(text))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  HolidayModel byId(String id) {
    final holiday = _holidays.where((h) => h.id == id).firstOrNull;
    if (holiday == null) {
      throw const NotFoundException('This holiday was not found.');
    }
    return holiday;
  }

  HolidayModel create(HolidayInput input) {
    final holiday = HolidayModel(
      id: 'h${_nextId++}',
      date: input.date.dateOnly,
      name: _validName(input),
      description: _description(input),
    );
    _checkDate(holiday.date);
    _holidays.add(holiday);
    audit?.record(
      action: 'holiday.create',
      summary: 'Company holiday added: ${holiday.name}',
      from: holiday.date,
    );
    _changed();
    return holiday;
  }

  HolidayModel update(String id, HolidayInput input) {
    final current = byId(id);
    final updated = current.copyWith(
      date: input.date.dateOnly,
      name: _validName(input),
      description: _description(input),
    );
    _checkDate(updated.date, exceptId: id);
    _holidays[_holidays.indexOf(current)] = updated;
    for (final date in {current.date, updated.date}) {
      audit?.record(
        action: 'holiday.update',
        summary: 'Company holiday changed: ${updated.name}',
        from: date,
        changes: [
          if (current.name != updated.name)
            AuditChangeModel(
              field: 'name',
              label: 'Name',
              before: current.name,
              after: updated.name,
            ),
          if (current.date != updated.date)
            AuditChangeModel(
              field: 'date',
              label: 'Date',
              before: '${current.date.day}/${current.date.month}',
              after: '${updated.date.day}/${updated.date.month}',
            ),
        ],
      );
    }
    _changed();
    return updated;
  }

  void delete(String id) {
    final holiday = byId(id);
    _holidays.remove(holiday);
    audit?.record(
      action: 'holiday.delete',
      summary: 'Company holiday removed: ${holiday.name}',
      from: holiday.date,
    );
    _changed();
  }

  static String _validName(HolidayInput input) {
    final name = input.name.trim();
    if (name.isEmpty) {
      throw const ValidationException(
        'Enter the holiday name',
        fieldErrors: {'name': 'Enter the holiday name'},
      );
    }
    if (name.length > nameMaxLength) {
      throw const ValidationException(
        'Use at most $nameMaxLength characters',
        fieldErrors: {'name': 'Use at most $nameMaxLength characters'},
      );
    }
    return name;
  }

  static String? _description(HolidayInput input) {
    final text = input.description?.trim();
    return text == null || text.isEmpty ? null : text;
  }

  void _checkDate(DateTime date, {String? exceptId}) {
    final clash = _holidays.where((h) => h.id != exceptId && h.date == date);
    if (clash.isNotEmpty) {
      final message = '${clash.first.name} is already on this date';
      throw ValidationException(message, fieldErrors: {'date': message});
    }
  }
}

/// DEV ONLY: the active organization's holidays, shared by the holiday,
/// leave and attendance mocks.
final mockHolidayStoreProvider = Provider<MockHolidayStore>(
  (ref) => ref.watch(mockActiveTenantProvider).holidays,
);
