import 'package:flutter/widgets.dart';

import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_status_badge.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

/// Colors follow the design's badge classes (b-present, b-absent, …).
extension EmployeeStatusTone on EmployeeStatus {
  StatusTone get tone => switch (this) {
    EmployeeStatus.active => StatusTone.success,
    _ => StatusTone.neutral,
  };
}

extension AttendanceDayStatusTone on AttendanceDayStatus {
  StatusTone get tone => switch (this) {
    AttendanceDayStatus.present => StatusTone.success,
    AttendanceDayStatus.late => StatusTone.late,
    AttendanceDayStatus.halfDay => StatusTone.halfDay,
    AttendanceDayStatus.onLeave => StatusTone.warning,
    AttendanceDayStatus.absent => StatusTone.danger,
    _ => StatusTone.neutral,
  };
}

extension LeaveStatusTone on LeaveStatus {
  StatusTone get tone => switch (this) {
    LeaveStatus.approved => StatusTone.success,
    LeaveStatus.pending => StatusTone.warning,
    LeaveStatus.rejected => StatusTone.danger,
    _ => StatusTone.neutral,
  };
}

class EmployeeStatusBadge extends StatelessWidget {
  const EmployeeStatusBadge(this.status, {super.key});

  final EmployeeStatus status;

  @override
  Widget build(BuildContext context) =>
      AppStatusBadge(label: status.label, tone: status.tone);
}

/// Daily attendance status with a leading dot, as in the design's "Today".
class AttendanceStatusBadge extends StatelessWidget {
  const AttendanceStatusBadge(this.status, {super.key});

  final AttendanceDayStatus status;

  @override
  Widget build(BuildContext context) =>
      AppStatusBadge(label: status.label, tone: status.tone, showDot: true);
}

class LeaveStatusBadge extends StatelessWidget {
  const LeaveStatusBadge(this.status, {super.key});

  final LeaveStatus status;

  @override
  Widget build(BuildContext context) =>
      AppStatusBadge(label: status.label, tone: status.tone, showDot: true);
}

/// Overtime on a day or in a period: "+1h 30m overtime".
class OvertimeBadge extends StatelessWidget {
  const OvertimeBadge(this.minutes, {super.key});

  final int minutes;

  @override
  Widget build(BuildContext context) => AppStatusBadge(
    label: '+${FormatUtils.compactDuration(minutes)} overtime',
    tone: StatusTone.info,
  );
}

/// "Holiday worked" / "Week off worked"; nothing for normal working days.
class DayKindBadge extends StatelessWidget {
  const DayKindBadge(this.kind, {super.key});

  final AttendanceDayKind kind;

  @override
  Widget build(BuildContext context) => switch (kind) {
    AttendanceDayKind.holidayWorked || AttendanceDayKind.weekOffWorked =>
      AppStatusBadge(label: kind.label, tone: StatusTone.offDayWorked),
    _ => const SizedBox.shrink(),
  };
}
