import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_alert_banner.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_choice_chips.dart';
import 'package:kc_admin_portal/core/widgets/app_field_label.dart';
import 'package:kc_admin_portal/core/widgets/app_loader.dart';
import 'package:kc_admin_portal/core/widgets/app_segmented_control.dart';
import 'package:kc_admin_portal/core/widgets/app_side_sheet.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/employees/presentation/providers/employee_providers.dart';
import 'package:kc_admin_portal/features/leave/data/models/leave_models.dart';
import 'package:kc_admin_portal/features/leave/presentation/providers/leave_providers.dart';
import 'package:kc_admin_portal/features/leave/presentation/widgets/leave_range_calendar.dart';
import 'package:kc_admin_portal/features/leave/presentation/widgets/leave_type_cards.dart';
import 'package:kc_admin_portal/shared/models/employee_summary_model.dart';
import 'package:kc_admin_portal/shared/models/leave_balance_model.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/widgets/employee_picker.dart';
import 'package:kc_admin_portal/shared/widgets/status_badges.dart';

/// Add leave (`/leave/add`, optionally `?employeeId=`) or edit one
/// (`/leave/:id/edit`), shown as a side sheet (design board 09).
class LeaveFormSheet extends ConsumerWidget {
  const LeaveFormSheet({
    this.leaveId,
    this.employeeId,
    this.initialDate,
    super.key,
  });

  final String? leaveId;

  /// Pre-selected employee (e.g. "Add leave" on a profile).
  final String? employeeId;

  /// Pre-selected day when adding (e.g. from a calendar day).
  final DateTime? initialDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = leaveId;
    if (id != null) {
      final leave = ref.watch(leaveDetailProvider(id));
      final loaded = leave.value;
      if (loaded != null && !loaded.canEdit) {
        return _NotEditable(leave: loaded);
      }
      return loaded != null
          ? _LeaveForm(initial: loaded, employee: loaded.employee)
          : _Loading(
              title: 'Edit leave',
              child: AsyncValueView<LeaveModel>(
                value: leave,
                compact: true,
                onRetry: () => ref.invalidate(leaveDetailProvider(id)),
                data: (_) => const SizedBox.shrink(),
              ),
            );
    }

    final preselect = employeeId;
    if (preselect == null) return _LeaveForm(initialDate: initialDate);
    final employee = ref.watch(employeeDetailProvider(preselect));
    return switch (employee) {
      AsyncData(:final value) => _LeaveForm(
        employee: _summaryOf(value),
        initialDate: initialDate,
      ),
      // An unknown employee just means nobody is pre-selected.
      AsyncError() => _LeaveForm(initialDate: initialDate),
      _ => const _Loading(title: 'Add leave', child: AppLoader(small: true)),
    };
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

/// Opened for leave that is no longer pending (an old link, or decided by
/// someone else meanwhile): explains why it can't be edited.
class _NotEditable extends StatelessWidget {
  const _NotEditable({required this.leave});

  final LeaveModel leave;

  @override
  Widget build(BuildContext context) {
    final status = leave.status.label.toLowerCase();
    return AppSideSheet(
      title: 'Edit leave',
      subtitle: leave.employee.name,
      actions: [
        AppButton(
          label: 'Close',
          variant: AppButtonVariant.secondary,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s16,
        children: [
          AppAlertBanner(
            tone: AlertTone.info,
            title: 'This leave can no longer be edited',
            message:
                'Only pending leave can be edited, and this one is $status. '
                '${leave.canCancel ? 'It can still be cancelled from the '
                          'Leaves list; it then stays in the history.' : 'It stays in the leave history as it is.'}',
          ),
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                '${leave.leaveType.name} leave · '
                '${AppDateFormat.range(leave.startDate, leave.endDate)}',
                style: AppTextStyles.bodySemibold,
              ),
              LeaveStatusBadge(leave.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => AppSideSheet(title: title, body: child);
}

class _LeaveForm extends ConsumerStatefulWidget {
  const _LeaveForm({this.initial, this.employee, this.initialDate});

  /// The leave being edited; null when adding.
  final LeaveModel? initial;
  final EmployeeSummaryModel? employee;

  /// Adding: the first (and last) day to start with.
  final DateTime? initialDate;

  @override
  ConsumerState<_LeaveForm> createState() => _LeaveFormState();
}

class _LeaveFormState extends ConsumerState<_LeaveForm> {
  late EmployeeSummaryModel? _employee = widget.employee;
  late String? _typeId = widget.initial?.leaveType.id;
  late bool _halfDay = widget.initial?.isHalfDay ?? false;
  late DateTime? _start = widget.initial?.startDate ?? widget.initialDate;
  late DateTime? _end = widget.initial?.endDate ?? widget.initialDate;
  late DateTime _month = (_start ?? ref.read(clockProvider)()).monthStart;
  late LeaveReason? _reason = widget.initial?.reason;
  late LeaveStatus _status = widget.initial?.status == LeaveStatus.pending
      ? LeaveStatus.pending
      : LeaveStatus.approved;
  late final _remarks = TextEditingController(text: widget.initial?.remarks);

  /// Save Casual days beyond the balance as a separate Unpaid leave.
  bool _splitExcess = false;

  /// Show "required" messages after the first save attempt.
  bool _submitted = false;
  Map<String, String> _serverErrors = const {};

  bool get _isEditing => widget.initial != null;

  @override
  void dispose() {
    _remarks.dispose();
    super.dispose();
  }

  LeavePreviewRequest? get _previewRequest {
    final employee = _employee;
    final typeId = _typeId;
    final start = _start;
    final end = _end;
    if (employee == null || typeId == null || start == null || end == null) {
      return null;
    }
    return LeavePreviewRequest(
      employeeId: employee.id,
      leaveTypeId: typeId,
      startDate: start,
      endDate: _halfDay ? start : end,
      isHalfDay: _halfDay,
      leaveId: widget.initial?.id,
    );
  }

  String? _required(Object? value, String message) =>
      _submitted && value == null ? message : null;

  void _clearServerError(String field) {
    if (_serverErrors.containsKey(field)) {
      setState(() => _serverErrors = {..._serverErrors}..remove(field));
    }
  }

  Future<void> _save() async {
    setState(() {
      _submitted = true;
      _serverErrors = const {};
    });
    final employee = _employee;
    final typeId = _typeId;
    final start = _start;
    final end = _end;
    final reason = _reason;
    if (employee == null ||
        typeId == null ||
        start == null ||
        end == null ||
        reason == null) {
      return;
    }

    // Only sent while the dates still go over the balance.
    final request = _previewRequest;
    final needsSplit =
        request != null &&
        (ref.read(leavePreviewProvider(request)).value?.needsSplit ?? false);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final saved = await ref
        .read(leaveFormControllerProvider.notifier)
        .save(
          leaveId: widget.initial?.id,
          data: LeaveFormData(
            employeeId: employee.id,
            leaveTypeId: typeId,
            startDate: start,
            endDate: _halfDay ? start : end,
            isHalfDay: _halfDay,
            reason: reason,
            remarks: _remarks.text,
            status: _status,
            splitExcessAsUnpaid: needsSplit && _splitExcess ? true : null,
          ),
        );
    if (saved == null || !mounted) return;
    showAppSnackBarOn(
      messenger,
      'Leave ${_isEditing ? 'updated' : 'added'} for ${saved.employee.name}',
      tone: SnackBarTone.success,
    );
    await navigator.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final submission = ref.watch(leaveFormControllerProvider);
    final isSaving = submission.isLoading;
    final types = ref.watch(leaveTypesProvider).value ?? const [];
    final employee = _employee;
    final balance = employee == null
        ? null
        : ref.watch(employeeLeaveBalanceProvider(employee.id)).value;
    final calendar = ref
        .watch(leaveCalendarProvider((month: _month, employeeId: employee?.id)))
        .value;

    ref.listen(leaveFormControllerProvider, (_, next) {
      final error = next.error;
      if (error is ValidationException) {
        setState(() => _serverErrors = error.fieldErrors);
      }
    });
    final error = submission.error;
    final generalError = error != null && !isSaving
        ? ErrorHandler.messageFor(error)
        : null;

    return AppSideSheet(
      title: _isEditing ? 'Edit leave' : 'Add leave',
      footerNote: 'Balance updates as soon as you save',
      actions: [
        AppButton(
          label: 'Cancel',
          variant: AppButtonVariant.secondary,
          onPressed: isSaving ? null : () => Navigator.of(context).maybePop(),
        ),
        AppButton(label: 'Save leave', isLoading: isSaving, onPressed: _save),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s24,
        children: [
          if (generalError != null) AppAlertBanner(message: generalError),
          EmployeePicker(
            selected: employee,
            canChange: !_isEditing && !isSaving,
            errorText:
                _serverErrors['employeeId'] ??
                _required(employee, 'Choose an employee'),
            onSelected: (picked) {
              _clearServerError('employeeId');
              setState(() => _employee = picked);
            },
          ),
          AppLabeledField(
            label: 'Leave type',
            isRequired: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LeaveTypeCards(
                  types: types,
                  balance: _withEditedLeaveReturned(balance),
                  selectedId: _typeId,
                  enabled: !isSaving,
                  onSelected: (id) {
                    _clearServerError('leaveTypeId');
                    setState(() => _typeId = id);
                  },
                ),
                AppFieldSubtext(
                  errorText:
                      _serverErrors['leaveTypeId'] ??
                      _required(_typeId, 'Choose a leave type'),
                ),
              ],
            ),
          ),
          _datesField(calendar, isSaving),
          if (_previewRequest case final request?)
            _Summary(
              request: request,
              splitExcess: _splitExcess,
              onSplitChanged: isSaving
                  ? null
                  : (split) => setState(() => _splitExcess = split),
            ),
          AppLabeledField(
            label: 'Reason',
            isRequired: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.s10,
              children: [
                AppChoiceChips<LeaveReason>(
                  selected: _reason,
                  onSelected: isSaving
                      ? null
                      : (reason) => setState(() => _reason = reason),
                  choices: [
                    for (final reason in LeaveReason.values)
                      AppChoice(value: reason, label: reason.label),
                  ],
                ),
                AppFieldSubtext(
                  errorText: _required(_reason, 'Choose a reason'),
                ),
                AppTextField(
                  controller: _remarks,
                  hintText: 'Remarks (optional)',
                  maxLines: 3,
                  enabled: !isSaving,
                ),
              ],
            ),
          ),
          AppLabeledField(
            label: 'Status',
            child: AppSegmentedControl<LeaveStatus>(
              semanticLabel: 'Leave status',
              selected: _status,
              onChanged: isSaving
                  ? null
                  : (status) => setState(() => _status = status),
              segments: [
                for (final status in [
                  LeaveStatus.approved,
                  LeaveStatus.pending,
                ])
                  AppSegment(value: status, label: status.label),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// When editing, the leave's own Casual days are not yet "used", so the
  /// cards show the balance the change would start from (as the summary
  /// does).
  LeaveBalanceModel? _withEditedLeaveReturned(LeaveBalanceModel? balance) {
    final initial = widget.initial;
    if (balance == null ||
        initial == null ||
        !initial.isPaid ||
        initial.status == LeaveStatus.cancelled ||
        initial.status == LeaveStatus.rejected) {
      return balance;
    }
    return balance.copyWith(remaining: balance.remaining + initial.days);
  }

  Widget _datesField(LeaveCalendarModel? calendar, bool isSaving) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s6,
      children: [
        Row(
          spacing: AppSpacing.s12,
          children: [
            const Expanded(child: AppFieldLabel('Dates', isRequired: true)),
            SizedBox(
              width: _durationToggleWidth,
              child: AppSegmentedControl<bool>(
                semanticLabel: 'Duration',
                compact: true,
                selected: _halfDay,
                onChanged: isSaving
                    ? null
                    : (half) => setState(() {
                        _halfDay = half;
                        if (half && _start != null) _end = _start;
                      }),
                segments: const [
                  AppSegment(value: false, label: 'Full day'),
                  AppSegment(value: true, label: 'Half day'),
                ],
              ),
            ),
          ],
        ),
        LeaveRangeCalendar(
          month: _month,
          calendar: calendar,
          start: _start,
          end: _halfDay ? _start : _end,
          singleDay: _halfDay,
          enabled: !isSaving,
          onMonthChanged: (month) => setState(() => _month = month),
          onRangeChanged: (start, end) {
            _clearServerError('startDate');
            _clearServerError('endDate');
            setState(() {
              _start = start;
              _end = end;
            });
          },
        ),
        AppFieldSubtext(
          errorText:
              _serverErrors['startDate'] ??
              _serverErrors['endDate'] ??
              _required(_start, 'Choose the leave dates'),
          helperText: _halfDay
              ? 'Tap the day of the half-day leave'
              : 'Tap the first day, then the last day',
        ),
      ],
    );
  }

  static const double _durationToggleWidth = 200;
}

/// "Selected · Leave days · Casual available" summary calculated by the
/// backend. When Casual leave goes over the balance it offers to save the
/// extra days as Unpaid (approved 2026-10-05).
class _Summary extends ConsumerWidget {
  const _Summary({
    required this.request,
    required this.splitExcess,
    required this.onSplitChanged,
  });

  final LeavePreviewRequest request;
  final bool splitExcess;
  final ValueChanged<bool>? onSplitChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preview = ref.watch(leavePreviewProvider(request));
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: const BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: AppRadius.lgAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s8,
        children: [
          _Line(
            label: 'Selected',
            value: request.isHalfDay
                ? '${AppDateFormat.shortRange(request.startDate, request.startDate)} · half day'
                : AppDateFormat.shortRange(request.startDate, request.endDate),
          ),
          switch (preview) {
            AsyncData(:final value) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.s8,
              children: [
                _Line(
                  label: 'Leave days',
                  value: '${FormatUtils.days(value.days)} · calculated',
                ),
                if (value.availableCasual case final available?)
                  _Line(
                    label: 'Casual available',
                    value: FormatUtils.days(available),
                  ),
                if (value.needsSplit) ...[
                  _Line(
                    label: 'Paid / unpaid',
                    value:
                        '${FormatUtils.count(value.paidDays)} Casual + '
                        '${FormatUtils.count(value.unpaidDays)} Unpaid',
                    isWarning: true,
                  ),
                  _SplitChoice(
                    preview: value,
                    value: splitExcess,
                    onChanged: onSplitChanged,
                  ),
                ],
              ],
            ),
            AsyncError(:final error) => _Line(
              label: 'Leave days',
              value: ErrorHandler.messageFor(error),
              isWarning: true,
            ),
            _ => const _Line(label: 'Leave days', value: 'Calculating…'),
          },
        ],
      ),
    );
  }
}

/// "Not enough Casual leave" with the choice to save the extra days as a
/// separate Unpaid leave (`splitExcessAsUnpaid`); the latest days become
/// Unpaid. Without it, saving is refused (422 `INSUFFICIENT_LEAVE_BALANCE`).
class _SplitChoice extends StatelessWidget {
  const _SplitChoice({
    required this.preview,
    required this.value,
    required this.onChanged,
  });

  final LeavePreviewModel preview;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;
    final extra = FormatUtils.days(preview.unpaidDays);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s8,
      children: [
        AppAlertBanner(
          tone: AlertTone.info,
          title: 'Not enough Casual leave',
          message: preview.paidDays > 0
              ? 'Only ${FormatUtils.days(preview.paidDays)} of Casual leave '
                    'can be used for these dates. Choose fewer days, or save '
                    'the last $extra as Unpaid leave.'
              : 'No Casual leave is available for these dates. Choose other '
                    'dates, or save the leave as Unpaid.',
        ),
        MergeSemantics(
          child: InkWell(
            onTap: enabled ? () => onChanged!(!value) : null,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
              child: Row(
                spacing: AppSpacing.s8,
                children: [
                  Checkbox(
                    value: value,
                    onChanged: enabled
                        ? (checked) => onChanged!(checked!)
                        : null,
                  ),
                  Flexible(
                    child: Text(
                      preview.paidDays > 0
                          ? 'Save the extra $extra as Unpaid'
                          : 'Save all $extra as Unpaid',
                      style: AppTextStyles.body.copyWith(
                        color: enabled
                            ? AppColors.textSecondary
                            : AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({
    required this.label,
    required this.value,
    this.isWarning = false,
  });

  final String label;
  final String value;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    // The value moves under the label when both don't fit.
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.s12,
      runSpacing: AppSpacing.s2,
      children: [
        Text(
          label,
          style: AppTextStyles.small.copyWith(color: AppColors.textMuted),
        ),
        Text(
          value,
          textAlign: TextAlign.end,
          style: AppTextStyles.bodyBold.copyWith(
            color: isWarning ? AppColors.dangerFg : null,
          ),
        ),
      ],
    );
  }
}
