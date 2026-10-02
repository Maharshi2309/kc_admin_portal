import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/utils/validation_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_alert_banner.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_date_picker.dart';
import 'package:kc_admin_portal/core/widgets/app_dialog.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/employees/domain/utils/schedule_rules.dart';
import 'package:kc_admin_portal/features/employees/presentation/providers/employee_providers.dart';
import 'package:kc_admin_portal/features/employees/presentation/widgets/work_schedule_fields.dart';

/// Changes an employee's working schedule from a chosen date. Earlier days
/// keep the schedule they were worked under.
class ScheduleChangeDialog extends ConsumerWidget {
  const ScheduleChangeDialog({required this.employeeId, super.key});

  final String employeeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employee = ref.watch(employeeDetailProvider(employeeId));
    if (employee.hasValue) return _ScheduleForm(employee: employee.value!);
    return AppDialog(
      title: 'Change schedule',
      body: AsyncValueView<EmployeeModel>(
        value: employee,
        compact: true,
        onRetry: () => ref.invalidate(employeeDetailProvider(employeeId)),
        data: (_) => const SizedBox.shrink(),
      ),
    );
  }
}

class _ScheduleForm extends ConsumerStatefulWidget {
  const _ScheduleForm({required this.employee});

  final EmployeeModel employee;

  @override
  ConsumerState<_ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends ConsumerState<_ScheduleForm> {
  final _formKey = GlobalKey<FormState>();
  late ScheduleDraft _draft = widget.employee.schedule == null
      ? ScheduleDraft.standard
      : ScheduleDraft.fromSchedule(widget.employee.schedule!);
  late DateTime? _effectiveFrom = ref.read(clockProvider)().dateOnly;

  /// Problems found before saving, or field errors from the server.
  Map<String, String> _errors = const {};

  /// How far ahead a change can be planned.
  static const int _maxDaysAhead = 365;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final input = _draft.toInput(_effectiveFrom!);
    final problems = scheduleProblems(input);
    setState(() => _errors = problems);
    if (problems.isNotEmpty) return;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final saved = await ref
        .read(scheduleFormControllerProvider.notifier)
        .save(widget.employee.id, input);
    if (saved == null || !mounted) return;
    showAppSnackBarOn(
      messenger,
      'New schedule for ${widget.employee.name} from '
      '${AppDateFormat.medium(saved.effectiveFrom)}',
      tone: SnackBarTone.success,
    );
    await navigator.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(scheduleFormControllerProvider, (_, next) {
      final error = next.error;
      if (error is ValidationException && error.fieldErrors.isNotEmpty) {
        setState(() => _errors = error.fieldErrors);
      }
    });
    final submission = ref.watch(scheduleFormControllerProvider);
    final isSaving = submission.isLoading;
    final today = ref.watch(clockProvider)().dateOnly;
    final error = submission.error;
    final generalError =
        error != null &&
            !isSaving &&
            (error is! ValidationException || error.fieldErrors.isEmpty)
        ? ErrorHandler.messageFor(error)
        : null;
    final from = _effectiveFrom;

    return AppDialog(
      title: 'Change schedule',
      subtitle: widget.employee.name,
      actions: [
        AppButton(
          label: 'Cancel',
          variant: AppButtonVariant.secondary,
          onPressed: isSaving ? null : () => Navigator.of(context).maybePop(),
        ),
        AppButton(
          label: 'Save schedule',
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
            if (generalError != null) AppAlertBanner(message: generalError),
            AppDatePicker(
              label: 'Applies from',
              isRequired: true,
              value: from,
              firstDate: widget.employee.joiningDate,
              lastDate: today.add(const Duration(days: _maxDaysAhead)),
              today: today,
              enabled: !isSaving,
              errorText: _errors['effectiveFrom'],
              helperText: from != null && from.isBefore(today)
                  ? 'A past date recalculates attendance and overtime from '
                        'that day'
                  : 'Days before this keep the current schedule',
              validator: Validators.requiredValue('Applies from'),
              onChanged: (date) => setState(() {
                _effectiveFrom = date;
                _errors = {..._errors}..remove('effectiveFrom');
              }),
            ),
            WorkScheduleFields(
              draft: _draft,
              errors: _errors,
              enabled: !isSaving,
              onChanged: (draft) => setState(() {
                _draft = draft;
                _errors = const {};
              }),
            ),
          ],
        ),
      ),
    );
  }
}
