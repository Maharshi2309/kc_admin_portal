import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_alert_banner.dart';
import 'package:kc_admin_portal/core/widgets/app_avatar.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_choice_chips.dart';
import 'package:kc_admin_portal/core/widgets/app_dialog.dart';
import 'package:kc_admin_portal/core/widgets/app_field_label.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';
import 'package:kc_admin_portal/core/widgets/app_time_field.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/core/widgets/responsive_grid.dart';
import 'package:kc_admin_portal/features/attendance/data/models/attendance_models.dart';
import 'package:kc_admin_portal/features/attendance/presentation/providers/attendance_providers.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/auth_controller.dart';
import 'package:kc_admin_portal/features/calendar/presentation/providers/calendar_providers.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/employees/presentation/providers/employee_providers.dart';
import 'package:kc_admin_portal/shared/models/clock_time.dart';
import 'package:kc_admin_portal/shared/models/employee_summary_model.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

/// Corrects an attendance record (`/attendance/:id/edit`) or adds a missing
/// one (`/attendance/new?employeeId&date`), shown as a dialog route
/// (design board 07). The new status is decided by the backend.
class AttendanceCorrectionDialog extends ConsumerWidget {
  const AttendanceCorrectionDialog({
    this.recordId,
    this.employeeId,
    this.date,
    super.key,
  }) : assert(
         recordId != null || (employeeId != null && date != null),
         'Pass a record id, or an employee and date for a new record',
       );

  final String? recordId;
  final String? employeeId;
  final DateTime? date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = recordId;
    if (id != null) {
      final record = ref.watch(attendanceRecordProvider(id));
      return record.hasValue
          ? _CorrectionForm(
              recordId: id,
              employee: record.value!.employee,
              date: record.value!.date,
              initial: record.value,
            )
          : _LoadingDialog(
              child: AsyncValueView<AttendanceRecordModel>(
                value: record,
                compact: true,
                onRetry: () => ref.invalidate(attendanceRecordProvider(id)),
                data: (_) => const SizedBox.shrink(),
              ),
            );
    }

    final employee = ref.watch(employeeDetailProvider(employeeId!));
    return employee.hasValue
        ? _CorrectionForm(employee: _summaryOf(employee.value!), date: date!)
        : _LoadingDialog(
            child: AsyncValueView<EmployeeModel>(
              value: employee,
              compact: true,
              onRetry: () =>
                  ref.invalidate(employeeDetailProvider(employeeId!)),
              data: (_) => const SizedBox.shrink(),
            ),
          );
  }

  static EmployeeSummaryModel _summaryOf(EmployeeModel e) =>
      EmployeeSummaryModel(
        id: e.id,
        name: e.name,
        ecNumber: e.ecNumber,
        department: e.department,
        position: e.position,
      );
}

class _LoadingDialog extends StatelessWidget {
  const _LoadingDialog({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      AppDialog(title: 'Attendance', body: child);
}

class _CorrectionForm extends ConsumerStatefulWidget {
  const _CorrectionForm({
    required this.employee,
    required this.date,
    this.recordId,
    this.initial,
  });

  final EmployeeSummaryModel employee;
  final DateTime date;

  /// Null when adding a missing record.
  final String? recordId;
  final AttendanceRecordModel? initial;

  @override
  ConsumerState<_CorrectionForm> createState() => _CorrectionFormState();
}

class _CorrectionFormState extends ConsumerState<_CorrectionForm> {
  final _formKey = GlobalKey<FormState>();
  late TimeOfDay? _punchIn = _timeOf(widget.initial?.punchIn);
  late TimeOfDay? _punchOut = _timeOf(widget.initial?.punchOut);
  CorrectionReason? _reason;
  bool _reasonMissing = false;
  final _remarks = TextEditingController();
  Map<String, String> _serverErrors = const {};

  bool get _isNew => widget.recordId == null;

  static TimeOfDay? _timeOf(DateTime? time) =>
      time == null ? null : TimeOfDay.fromDateTime(time);

  /// On a weekly off or company holiday: what recording hours means.
  /// On a weekly off or company holiday: what recording hours means.
  static String? _offDayNote({
    required String name,
    required bool weekOff,
    required bool holiday,
  }) {
    if (!weekOff && !holiday) return null;
    final day = weekOff ? 'a weekly off' : 'a company holiday';
    return 'This is $day for $name. Hours recorded here are counted as '
        '${weekOff ? 'week-off' : 'holiday'} work, and all of them as '
        'overtime. Nobody is marked absent on this day.';
  }

  static TimeOfDay? _timeOfClock(ClockTime? time) =>
      time == null ? null : TimeOfDay(hour: time.hour, minute: time.minute);

  DateTime _on(TimeOfDay time) => DateTime(
    widget.date.year,
    widget.date.month,
    widget.date.day,
    time.hour,
    time.minute,
  );

  @override
  void dispose() {
    _remarks.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _serverErrors = const {};
      _reasonMissing = _reason == null;
    });
    if (!_formKey.currentState!.validate() || _reason == null) return;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final saved = await ref
        .read(attendanceCorrectionControllerProvider.notifier)
        .save(
          recordId: widget.recordId,
          data: AttendanceCorrectionData(
            employeeId: _isNew ? widget.employee.id : null,
            date: widget.date,
            punchIn: _on(_punchIn!),
            punchOut: _punchOut == null ? null : _on(_punchOut!),
            reason: _reason!,
            remarks: _remarks.text,
          ),
        );
    if (saved == null || !mounted) return;
    showAppSnackBarOn(
      messenger,
      'Attendance ${_isNew ? 'added' : 'corrected'} for ${saved.employee.name}',
      tone: SnackBarTone.success,
    );
    await navigator.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final submission = ref.watch(attendanceCorrectionControllerProvider);
    final isSaving = submission.isLoading;
    final user = ref.watch(authControllerProvider).value;
    final now = ref.watch(clockProvider)();
    final isToday = widget.date == now.dateOnly;

    // The employee's own hours that day, for the quick buttons: from the
    // record, or from the day's list when adding a missing record.
    final dayRecord =
        widget.initial ??
        ref
            .watch(attendanceDayProvider)
            .value
            ?.items
            .where(
              (r) =>
                  r.employee.id == widget.employee.id && r.date == widget.date,
            )
            .firstOrNull;
    // Opened from an employee's calendar: that day's calendar entry (already
    // loaded by the day sheet) gives the schedule and the kind of day.
    final calendarDay = dayRecord != null
        ? null
        : ref
              .watch(
                calendarDayProvider((
                  employeeId: widget.employee.id,
                  date: widget.date,
                )),
              )
              .value
              ?.day;
    final schedule = dayRecord?.schedule ?? calendarDay?.schedule;
    final offDay = _offDayNote(
      name: widget.employee.name,
      weekOff:
          dayRecord?.status == AttendanceDayStatus.weeklyOff ||
          dayRecord?.dayKind == AttendanceDayKind.weekOffWorked ||
          calendarDay?.dayType == CalendarDayType.weekOff,
      holiday:
          dayRecord?.status == AttendanceDayStatus.holiday ||
          dayRecord?.dayKind == AttendanceDayKind.holidayWorked ||
          calendarDay?.dayType == CalendarDayType.holiday,
    );
    final shiftStart = _timeOfClock(schedule?.startTime);
    final shiftEnd = _timeOfClock(schedule?.endTime);

    ref.listen(attendanceCorrectionControllerProvider, (_, next) {
      final error = next.error;
      if (error is ValidationException) {
        setState(() => _serverErrors = error.fieldErrors);
      }
    });

    final error = submission.error;
    final generalError =
        error != null &&
            !isSaving &&
            (error is! ValidationException || error.fieldErrors.isEmpty)
        ? ErrorHandler.messageFor(error)
        : null;

    return AppDialog(
      title: _isNew ? 'Add attendance' : 'Correct attendance',
      subtitle: 'Changes are saved with your name and time for audit',
      footerNote: user == null ? null : 'Logged as: ${user.name}',
      actions: [
        AppButton(
          label: 'Cancel',
          variant: AppButtonVariant.secondary,
          onPressed: isSaving ? null : () => Navigator.of(context).maybePop(),
        ),
        AppButton(
          label: _isNew ? 'Save attendance' : 'Save correction',
          isLoading: isSaving,
          onPressed: _save,
        ),
      ],
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.s20,
          children: [
            _RecordSummary(
              employee: widget.employee,
              date: widget.date,
              initial: widget.initial,
            ),
            if (offDay != null)
              AppAlertBanner(tone: AlertTone.info, message: offDay),
            if (generalError != null) AppAlertBanner(message: generalError),
            ResponsiveGrid(
              minItemWidth: _timeFieldMinWidth,
              maxColumns: 2,
              equalHeight: false,
              children: [
                AppTimeField(
                  label: 'Punch in',
                  isRequired: true,
                  value: _punchIn,
                  enabled: !isSaving,
                  errorText: _serverErrors['punchIn'],
                  validator: (value) =>
                      value == null ? 'Punch in time is required' : null,
                  shortcuts: [
                    if (shiftStart != null)
                      AppTimeShortcut(
                        label: 'Shift start ${AppTimeField.format(shiftStart)}',
                        time: shiftStart,
                      ),
                  ],
                  onChanged: (time) => setState(() => _punchIn = time),
                ),
                AppTimeField(
                  label: 'Punch out',
                  value: _punchOut,
                  enabled: !isSaving,
                  hintText: 'Not punched out',
                  errorText: _serverErrors['punchOut'],
                  validator: (value) {
                    final start = _punchIn;
                    if (value == null || start == null) return null;
                    final after =
                        value.hour * 60 + value.minute >
                        start.hour * 60 + start.minute;
                    return after ? null : 'Must be after punch in';
                  },
                  shortcuts: [
                    if (shiftEnd != null)
                      AppTimeShortcut(
                        label: 'Shift end ${AppTimeField.format(shiftEnd)}',
                        time: shiftEnd,
                      ),
                    if (isToday)
                      AppTimeShortcut(
                        label: 'Now',
                        time: TimeOfDay.fromDateTime(now),
                      ),
                  ],
                  onClear: () => setState(() => _punchOut = null),
                  onChanged: (time) => setState(() => _punchOut = time),
                ),
              ],
            ),
            Text(
              'The attendance status is updated automatically from these '
              'times.',
              style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
            ),
            AppLabeledField(
              label: 'Reason for change',
              isRequired: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppChoiceChips<CorrectionReason>(
                    selected: _reason,
                    onSelected: isSaving
                        ? null
                        : (reason) => setState(() {
                            _reason = reason;
                            _reasonMissing = false;
                          }),
                    choices: [
                      for (final reason in CorrectionReason.values)
                        AppChoice(value: reason, label: reason.label),
                    ],
                  ),
                  AppFieldSubtext(
                    errorText: _reasonMissing
                        ? 'Choose a reason'
                        : _serverErrors['reason'],
                  ),
                ],
              ),
            ),
            AppTextField(
              label: 'Remarks (optional)',
              controller: _remarks,
              enabled: !isSaving,
              maxLines: 3,
              errorText: _serverErrors['remarks'],
            ),
          ],
        ),
      ),
    );
  }

  static const double _timeFieldMinWidth = 220;
}

class _RecordSummary extends StatelessWidget {
  const _RecordSummary({
    required this.employee,
    required this.date,
    required this.initial,
  });

  final EmployeeSummaryModel employee;
  final DateTime date;
  final AttendanceRecordModel? initial;

  @override
  Widget build(BuildContext context) {
    final recorded = initial;
    String time(DateTime? t) => t == null ? '—' : AppDateFormat.time(t);
    final recordedText = recorded == null
        ? 'No record yet'
        : 'Recorded: in ${time(recorded.punchIn)} · '
              'out ${time(recorded.punchOut)}';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: const BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: AppRadius.lgAll,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final identity = Row(
            spacing: AppSpacing.s12,
            children: [
              AppAvatar(name: employee.name),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.s2,
                  children: [
                    Text(employee.name, style: AppTextStyles.bodyBold),
                    Text(
                      [
                        employee.ecNumber,
                        ?employee.position?.label,
                      ].join(' · '),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
          final day = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.s2,
            children: [
              Text(AppDateFormat.long(date), style: AppTextStyles.bodySemibold),
              Text(
                recordedText,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          );

          // Narrow dialogs (phones, or large text): the date goes under the
          // employee.
          final sideBySideMin = MediaQuery.textScalerOf(
            context,
          ).scale(_sideBySideMinWidth);
          if (constraints.maxWidth < sideBySideMin) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.s10,
              children: [identity, day],
            );
          }
          return Row(
            spacing: AppSpacing.s16,
            children: [
              Expanded(child: identity),
              day,
            ],
          );
        },
      ),
    );
  }

  static const double _sideBySideMinWidth = 440;
}
