import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/features/employees/domain/utils/schedule_rules.dart';
import 'package:kc_admin_portal/shared/models/clock_time.dart';

Map<String, String> _problems(ScheduleDraft draft) =>
    scheduleProblems(draft.toInput(DateTime(2026, 10)));

void main() {
  group('expected minutes = end − start − break', () {
    test('the requirement examples', () {
      // A: 09:00–17:30, 1 h lunch → 7.5 h.
      const a = ScheduleDraft(
        startTime: ClockTime.hm(9, 0),
        endTime: ClockTime.hm(17, 30),
        breakMinutes: 60,
        weeklyOffDays: {7},
      );
      expect(a.shiftMinutes, 510);
      expect(a.expectedMinutes, 450);

      // B: 10:00–18:30, 1 h → 7.5 h. C: 09:30–18:00, 30 min → 8 h.
      expect(
        a
            .copyWith(
              startTime: const ClockTime.hm(10, 0),
              endTime: const ClockTime.hm(18, 30),
            )
            .expectedMinutes,
        450,
      );
      expect(
        a
            .copyWith(
              startTime: const ClockTime.hm(9, 30),
              endTime: const ClockTime.hm(18, 0),
              breakMinutes: 30,
            )
            .expectedMinutes,
        480,
      );
    });
  });

  group('break window', () {
    test('ends break-length after its start', () {
      final draft = ScheduleDraft.standard.copyWith(
        breakStart: const ClockTime.hm(13, 0),
      );
      expect(draft.breakEnd, const ClockTime.hm(14, 0));
      final input = draft.toInput(DateTime(2026, 10));
      expect(input.breakStart, const ClockTime.hm(13, 0));
      expect(input.breakEnd, const ClockTime.hm(14, 0));
    });

    test('is optional and can be cleared', () {
      final draft = ScheduleDraft.standard
          .copyWith(breakStart: const ClockTime.hm(13, 0))
          .copyWith(clearBreakStart: true);
      expect(draft.breakStart, isNull);
      expect(draft.toInput(DateTime(2026, 10)).breakEnd, isNull);
    });
  });

  group('problems the backend would reject', () {
    test('a valid schedule has none', () {
      expect(_problems(ScheduleDraft.standard), isEmpty);
    });

    test('end must be after start', () {
      final draft = ScheduleDraft.standard.copyWith(
        endTime: const ClockTime.hm(9, 30),
      );
      expect(_problems(draft).keys, ['endTime']);
    });

    test('the break must be shorter than the shift', () {
      final draft = ScheduleDraft.standard.copyWith(
        startTime: const ClockTime.hm(9, 0),
        endTime: const ClockTime.hm(10, 0),
        breakMinutes: 60,
      );
      expect(_problems(draft).keys, ['breakMinutes']);
    });

    test('the break window must be inside the working hours', () {
      final draft = ScheduleDraft.standard.copyWith(
        breakStart: const ClockTime.hm(18, 0),
      );
      expect(_problems(draft).keys, ['breakStart']);
    });

    test('at least one working day a week', () {
      final draft = ScheduleDraft.standard.copyWith(
        weeklyOffDays: {1, 2, 3, 4, 5, 6, 7},
      );
      expect(_problems(draft).keys, ['weeklyOffDays']);
      expect(
        _problems(ScheduleDraft.standard.copyWith(weeklyOffDays: {})),
        isEmpty,
      );
    });
  });
}
