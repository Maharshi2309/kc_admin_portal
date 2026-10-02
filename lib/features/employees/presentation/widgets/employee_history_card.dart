import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/features/attendance/presentation/widgets/attendance_log_list.dart';
import 'package:kc_admin_portal/features/calendar/presentation/providers/calendar_providers.dart';
import 'package:kc_admin_portal/features/employees/presentation/widgets/leave_history_list.dart';

/// Profile history with the design's two tabs: leave history and the
/// attendance log of the month shown in the calendar.
class EmployeeHistoryCard extends ConsumerStatefulWidget {
  const EmployeeHistoryCard({
    required this.employeeId,
    this.showAttendanceLog = true,
    super.key,
  });

  final String employeeId;

  /// False when the role can't view attendance: only leave history shows.
  final bool showAttendanceLog;

  @override
  ConsumerState<EmployeeHistoryCard> createState() =>
      _EmployeeHistoryCardState();
}

class _EmployeeHistoryCardState extends ConsumerState<EmployeeHistoryCard>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  // Created up front (not lazily): when only leave history shows, the
  // controller would otherwise first be built in dispose().
  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showAttendanceLog) {
      return AppCard(
        padding: EdgeInsets.zero,
        clip: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s24,
                AppSpacing.s20,
                AppSpacing.s24,
                AppSpacing.s14,
              ),
              child: Semantics(
                header: true,
                child: Text('Leave history', style: AppTextStyles.sectionTitle),
              ),
            ),
            const Divider(height: 1, color: AppColors.divider),
            LeaveHistoryList(employeeId: widget.employeeId),
          ],
        ),
      );
    }
    // The log follows the month shown in the calendar.
    final month = ref.watch(calendarMonthProvider(widget.employeeId));

    return AppCard(
      padding: EdgeInsets.zero,
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s24,
              AppSpacing.s8,
              AppSpacing.s24,
              0,
            ),
            child: TabBar(
              controller: _tabs,
              isScrollable: true,
              tabs: [
                const Tab(text: 'Leave history'),
                Tab(text: 'Attendance log · ${AppDateFormat.monthYear(month)}'),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          // Sized by content (no TabBarView), so the card grows with rows;
          // the log follows the month chosen in the calendar.
          if (_tabs.index == 0)
            LeaveHistoryList(employeeId: widget.employeeId)
          else
            AttendanceLogList(employeeId: widget.employeeId, month: month),
        ],
      ),
    );
  }
}
