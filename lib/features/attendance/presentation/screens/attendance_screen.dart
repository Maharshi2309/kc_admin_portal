import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/widgets/app_alert_banner.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_dialog.dart';
import 'package:kc_admin_portal/core/widgets/app_dropdown.dart';
import 'package:kc_admin_portal/core/widgets/app_empty_view.dart';
import 'package:kc_admin_portal/core/widgets/app_filter_dropdown.dart';
import 'package:kc_admin_portal/core/widgets/app_page.dart';
import 'package:kc_admin_portal/core/widgets/app_pagination.dart';
import 'package:kc_admin_portal/core/widgets/app_search_field.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/features/attendance/data/models/attendance_models.dart';
import 'package:kc_admin_portal/features/attendance/presentation/providers/attendance_providers.dart';
import 'package:kc_admin_portal/features/attendance/presentation/widgets/attendance_table.dart';
import 'package:kc_admin_portal/features/attendance/presentation/widgets/day_picker.dart';
import 'package:kc_admin_portal/features/attendance/presentation/widgets/status_filter_tiles.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/permission_providers.dart';
import 'package:kc_admin_portal/shared/models/job_role.dart';

/// Daily attendance (design board 06): pick a day, filter by status tile,
/// punch employees in and out, and correct records.
///
/// TODO — REQUIREMENT CONFIRMATION REQUIRED: the design's "Export" button is
/// not in the requirement document and is left out.
class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  late final _search = TextEditingController(
    text: ref.read(attendanceQueryProvider).search,
  );
  bool _punchingAll = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _punchInAll(int count, DateTime date) async {
    final confirmed = await showAppConfirmDialog(
      context,
      title: 'Punch in $count ${count == 1 ? 'employee' : 'employees'}?',
      message:
          'Everyone who has not punched in yet will be punched in at the '
          'current time. You can correct individual times afterwards.',
      confirmLabel: 'Punch in all',
    );
    if (!confirmed || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    setState(() => _punchingAll = true);
    try {
      final done = await ref
          .read(attendanceActionsProvider.notifier)
          .punchInAll(date);
      showAppSnackBarOn(
        messenger,
        '$done ${done == 1 ? 'employee' : 'employees'} punched in',
        tone: SnackBarTone.success,
      );
    } on Object catch (error) {
      showAppSnackBarOn(
        messenger,
        ErrorHandler.messageFor(error),
        tone: SnackBarTone.error,
      );
    } finally {
      if (mounted) setState(() => _punchingAll = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(attendanceQueryProvider);
    final queryNotifier = ref.read(attendanceQueryProvider.notifier);
    final day = ref.watch(attendanceDayProvider);
    final today = ref.watch(clockProvider)().dateOnly;
    final isToday = query.date == today;

    return AppPageBody(
      children: [
        AppPageHeader(
          title: 'Attendance',
          subtitle: "Hours follow each employee's own schedule",
          actions: [
            DayPicker(
              date: query.date,
              today: today,
              onChanged: queryNotifier.setDate,
              onPrevious: queryNotifier.previousDay,
              onNext: queryNotifier.nextDay,
            ),
          ],
        ),
        AsyncValueView<AttendanceDayModel>(
          value: day,
          onRetry: () => ref.invalidate(attendanceDayProvider),
          data: (data) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.s20,
            children: [
              StatusFilterTiles(
                summary: data.summary,
                selected: query.filter,
                onSelected: queryNotifier.setFilter,
              ),
              if (isToday && data.summary.notPunchedIn > 0)
                _NotPunchedInBanner(
                  count: data.summary.notPunchedIn,
                  isPunchingAll: _punchingAll,
                  onShow: () =>
                      queryNotifier.setFilter(AttendanceFilter.absent),
                  onPunchInAll: ref.can(AppPermission.attendancePunch)
                      ? () => _punchInAll(data.summary.notPunchedIn, query.date)
                      : null,
                ),
              _ListCard(
                day: data,
                isToday: isToday,
                search: _search,
                isRefreshing: day.isLoading,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NotPunchedInBanner extends StatelessWidget {
  const _NotPunchedInBanner({
    required this.count,
    required this.isPunchingAll,
    required this.onShow,
    required this.onPunchInAll,
  });

  final int count;
  final bool isPunchingAll;
  final VoidCallback onShow;

  /// Null hides "Punch in all" (the role can't punch).
  final VoidCallback? onPunchInAll;

  @override
  Widget build(BuildContext context) {
    final people = count == 1 ? '1 employee has' : '$count employees have';
    return AppAlertBanner(
      title: '$people not punched in yet',
      message: onPunchInAll == null
          ? 'They show as absent until they are punched in.'
          : 'Punch them in now, or leave them as absent for today.',
      action: Wrap(
        spacing: AppSpacing.s8,
        runSpacing: AppSpacing.s8,
        children: [
          AppButton(
            label: 'See who',
            size: AppButtonSize.small,
            variant: AppButtonVariant.secondary,
            onPressed: onShow,
          ),
          if (onPunchInAll != null)
            AppButton(
              label: 'Punch in all',
              size: AppButtonSize.small,
              isLoading: isPunchingAll,
              onPressed: onPunchInAll,
            ),
        ],
      ),
    );
  }
}

class _ListCard extends ConsumerWidget {
  const _ListCard({
    required this.day,
    required this.isToday,
    required this.search,
    required this.isRefreshing,
  });

  final AttendanceDayModel day;
  final bool isToday;
  final TextEditingController search;
  final bool isRefreshing;

  static const double _searchMaxWidth = 280;
  static const double _progressLineHeight = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(attendanceQueryProvider);
    final notifier = ref.read(attendanceQueryProvider.notifier);

    return AppCard(
      padding: EdgeInsets.zero,
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s16),
            child: Wrap(
              spacing: AppSpacing.s10,
              runSpacing: AppSpacing.s10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(query.filter.listTitle, style: AppTextStyles.sectionTitle),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _searchMaxWidth),
                  child: AppSearchField(
                    hintText: 'Find by name or EC number',
                    compact: true,
                    controller: search,
                    onChanged: notifier.setSearch,
                    onSubmitted: notifier.applySearch,
                  ),
                ),
                AppFilterDropdown<JobRole>(
                  label: 'Department',
                  value: query.department,
                  onChanged: notifier.setDepartment,
                  items: [
                    for (final d in JobRole.choices)
                      AppDropdownItem(value: d, label: d.label),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: _progressLineHeight,
            child: isRefreshing
                ? const LinearProgressIndicator()
                : const Divider(height: 1, color: AppColors.border),
          ),
          if (day.items.isEmpty)
            const AppEmptyView(
              compact: true,
              icon: Icons.person_search_outlined,
              title: 'Nobody in this list for this day',
            )
          else ...[
            AttendanceTable(records: day.items, isToday: isToday),
            LoadMoreFooter(
              shownCount: day.items.length,
              totalCount: day.total,
              onLoadMore: ref.read(attendanceDayProvider.notifier).loadMore,
            ),
          ],
        ],
      ),
    );
  }
}
