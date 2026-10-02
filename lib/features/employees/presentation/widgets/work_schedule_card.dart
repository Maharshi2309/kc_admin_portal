import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_link.dart';
import 'package:kc_admin_portal/core/widgets/app_status_badge.dart';
import 'package:kc_admin_portal/core/widgets/responsive_grid.dart';
import 'package:kc_admin_portal/features/employees/presentation/providers/employee_providers.dart';
import 'package:kc_admin_portal/shared/models/work_schedule_model.dart';

/// "Working schedule" on the profile: today's schedule, an upcoming change
/// if one is planned, and the earlier versions.
class WorkScheduleCard extends ConsumerWidget {
  const WorkScheduleCard({
    required this.employeeId,
    required this.current,
    required this.onChange,
    super.key,
  });

  final String employeeId;

  /// The schedule in effect today (from the employee record).
  final WorkScheduleModel? current;

  /// Opens the change-schedule dialog; null hides the action.
  final VoidCallback? onChange;

  static const double _factMinWidth = 150;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedule = current;
    final today = ref.watch(clockProvider)().dateOnly;
    final versions =
        ref.watch(employeeSchedulesProvider(employeeId)).value ?? const [];
    final upcoming = versions
        .where((v) => v.effectiveFrom.isAfter(today))
        .toList()
        .reversed
        .toList();
    final earlier = versions
        .where((v) => v.effectiveTo != null && v.effectiveTo!.isBefore(today))
        .toList();

    return SectionCard(
      title: 'Working schedule',
      subtitle: schedule == null
          ? null
          : 'Since ${AppDateFormat.medium(schedule.effectiveFrom)}',
      trailing: onChange == null
          ? null
          : AppLink(
              label: schedule == null ? 'Set schedule' : 'Change',
              onPressed: onChange,
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s16,
        children: [
          if (schedule == null)
            Text(
              'No working schedule is set, so expected hours and overtime '
              "can't be worked out.",
              style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
            )
          else
            ResponsiveGrid(
              minItemWidth: _factMinWidth,
              maxColumns: 4,
              spacing: AppSpacing.s16,
              runSpacing: AppSpacing.s12,
              equalHeight: false,
              children: [
                _Fact(
                  label: 'Hours',
                  value:
                      '${schedule.startTime.toApi()} – '
                      '${schedule.endTime.toApi()}',
                ),
                _Fact(label: 'Break', value: breakText(schedule)),
                _Fact(
                  label: 'Weekly off',
                  value: schedule.weeklyOffDays.isEmpty
                      ? 'None'
                      : FormatUtils.weekdays(schedule.weeklyOffDays),
                ),
                _Fact(
                  label: 'Expected per day',
                  value: FormatUtils.duration(schedule.expectedMinutes),
                  emphasised: true,
                ),
              ],
            ),
          for (final version in upcoming)
            _VersionRow(version: version, tag: 'Upcoming'),
          if (earlier.isNotEmpty) ...[
            const Divider(color: AppColors.divider, height: 1),
            Text('EARLIER SCHEDULES', style: AppTextStyles.overline),
            for (final version in earlier) _VersionRow(version: version),
          ],
        ],
      ),
    );
  }

  /// "1 h (13:00–14:00)", "30 min" or "No break".
  static String breakText(WorkScheduleModel schedule) {
    if (schedule.breakMinutes == 0) return 'No break';
    final length = FormatUtils.minutes(schedule.breakMinutes);
    final start = schedule.breakStart;
    final end = schedule.breakEnd;
    return start == null || end == null
        ? length
        : '$length (${start.toApi()}–${end.toApi()})';
  }
}

class _Fact extends StatelessWidget {
  const _Fact({
    required this.label,
    required this.value,
    this.emphasised = false,
  });

  final String label;
  final String value;
  final bool emphasised;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.s2,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
          ),
          Text(
            value,
            style: emphasised
                ? AppTextStyles.bodyBold
                : AppTextStyles.bodySemibold,
          ),
        ],
      ),
    );
  }
}

/// One schedule version: its dates and a one-line summary.
class _VersionRow extends StatelessWidget {
  const _VersionRow({required this.version, this.tag});

  final WorkScheduleModel version;
  final String? tag;

  @override
  Widget build(BuildContext context) {
    final to = version.effectiveTo;
    final dates = to == null
        ? 'From ${AppDateFormat.medium(version.effectiveFrom)}'
        : AppDateFormat.range(version.effectiveFrom, to);
    final summary = [
      '${version.startTime.toApi()}–${version.endTime.toApi()}',
      WorkScheduleCard.breakText(version),
      if (version.weeklyOffDays.isNotEmpty)
        '${FormatUtils.weekdays(version.weeklyOffDays)} off',
      '${FormatUtils.duration(version.expectedMinutes)} a day',
    ].join(' · ');

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.s8,
      runSpacing: AppSpacing.s4,
      children: [
        Text(dates, style: AppTextStyles.smallSemibold),
        if (tag != null) AppStatusBadge(label: tag!, tone: StatusTone.info),
        Text(
          summary,
          style: AppTextStyles.small.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}
