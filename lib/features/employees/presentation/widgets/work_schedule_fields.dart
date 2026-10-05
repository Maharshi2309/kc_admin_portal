import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/utils/duration_format.dart';
import 'package:kc_admin_portal/core/widgets/app_choice_chips.dart';
import 'package:kc_admin_portal/core/widgets/app_dropdown.dart';
import 'package:kc_admin_portal/core/widgets/app_field_label.dart';
import 'package:kc_admin_portal/core/widgets/app_time_field.dart';
import 'package:kc_admin_portal/core/widgets/responsive_grid.dart';
import 'package:kc_admin_portal/features/employees/domain/utils/schedule_rules.dart';
import 'package:kc_admin_portal/shared/models/clock_time.dart';

/// The working-schedule inputs: start, end, break (length and optional start
/// time), weekly offs, and a live preview of the expected hours per day.
///
/// Stateless: the parent owns the [draft] and gets every change through
/// [onChanged]. [errors] are keyed like the API's field errors (`startTime`,
/// `endTime`, `breakMinutes`, `breakStart`, `weeklyOffDays`).
class WorkScheduleFields extends StatelessWidget {
  const WorkScheduleFields({
    required this.draft,
    required this.onChanged,
    this.errors = const {},
    this.enabled = true,
    super.key,
  });

  final ScheduleDraft draft;
  final ValueChanged<ScheduleDraft> onChanged;
  final Map<String, String> errors;
  final bool enabled;

  static const double _fieldMinWidth = 180;

  /// Break lengths offered in the dropdown (minutes). A saved schedule's own
  /// length is added if it is not one of these.
  static const List<int> _breakOptions = [0, 15, 30, 45, 60, 75, 90, 120];

  static TimeOfDay _toTimeOfDay(ClockTime time) =>
      TimeOfDay(hour: time.hour, minute: time.minute);

  static ClockTime _toClockTime(TimeOfDay time) =>
      ClockTime.hm(time.hour, time.minute);

  @override
  Widget build(BuildContext context) {
    final breakOptions = {..._breakOptions, draft.breakMinutes}.toList()
      ..sort();
    final breakEnd = draft.breakEnd;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s18,
      children: [
        ResponsiveGrid(
          minItemWidth: _fieldMinWidth,
          maxColumns: 4,
          spacing: AppSpacing.s16,
          runSpacing: AppSpacing.s18,
          equalHeight: false,
          children: [
            AppTimeField(
              label: 'Starts at',
              isRequired: true,
              value: _toTimeOfDay(draft.startTime),
              enabled: enabled,
              errorText: errors['startTime'],
              onChanged: (time) =>
                  onChanged(draft.copyWith(startTime: _toClockTime(time))),
            ),
            AppTimeField(
              label: 'Ends at',
              isRequired: true,
              value: _toTimeOfDay(draft.endTime),
              enabled: enabled,
              errorText: errors['endTime'],
              onChanged: (time) =>
                  onChanged(draft.copyWith(endTime: _toClockTime(time))),
            ),
            AppDropdown<int>(
              label: 'Break',
              isRequired: true,
              value: draft.breakMinutes,
              enabled: enabled,
              errorText: errors['breakMinutes'],
              items: [
                for (final minutes in breakOptions)
                  AppDropdownItem(
                    value: minutes,
                    label: minutes == 0
                        ? 'No break'
                        : DurationFormat.full(minutes),
                  ),
              ],
              onChanged: (minutes) {
                if (minutes == null) return;
                onChanged(
                  draft.copyWith(
                    breakMinutes: minutes,
                    clearBreakStart: minutes == 0,
                  ),
                );
              },
            ),
            AppTimeField(
              label: 'Break starts at',
              hintText: 'Optional',
              value: draft.breakStart == null
                  ? null
                  : _toTimeOfDay(draft.breakStart!),
              enabled: enabled && draft.breakMinutes > 0,
              helperText: breakEnd == null
                  ? 'Optional: when the break is taken'
                  : 'Break ends at ${breakEnd.toApi()}',
              errorText: errors['breakStart'],
              onClear: draft.breakStart == null
                  ? null
                  : () => onChanged(draft.copyWith(clearBreakStart: true)),
              onChanged: (time) =>
                  onChanged(draft.copyWith(breakStart: _toClockTime(time))),
            ),
          ],
        ),
        AppLabeledField(
          label: 'Weekly off',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppMultiChoiceChips<int>(
                choices: [
                  for (var day = DateTime.monday; day <= DateTime.sunday; day++)
                    AppChoice(
                      value: day,
                      label: AppDateFormat.weekdayShort(day),
                    ),
                ],
                selected: draft.weeklyOffDays,
                onChanged: enabled
                    ? (days) => onChanged(draft.copyWith(weeklyOffDays: days))
                    : null,
              ),
              AppFieldSubtext(
                errorText: errors['weeklyOffDays'],
                helperText: draft.weeklyOffDays.isEmpty
                    ? 'No weekly off: works every day'
                    : null,
              ),
            ],
          ),
        ),
        _ExpectedHours(draft: draft),
      ],
    );
  }
}

/// "Expected per day 7h 30m · 8h 30m shift − 1 h break".
class _ExpectedHours extends StatelessWidget {
  const _ExpectedHours({required this.draft});

  final ScheduleDraft draft;

  @override
  Widget build(BuildContext context) {
    final valid = draft.shiftMinutes > 0 && draft.expectedMinutes > 0;
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s12,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surfaceSunken,
          borderRadius: AppRadius.mdAll,
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s4,
          children: [
            Text(
              'Expected per day',
              style: AppTextStyles.small.copyWith(color: AppColors.textMuted),
            ),
            Text(
              valid ? DurationFormat.full(draft.expectedMinutes) : '—',
              style: AppTextStyles.bodyBold,
            ),
            if (valid)
              Text(
                '${DurationFormat.full(draft.shiftMinutes)} shift'
                '${draft.breakMinutes == 0 ? '' : ' − ${DurationFormat.full(draft.breakMinutes)} break'}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
