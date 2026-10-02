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
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/features/holidays/presentation/providers/holiday_providers.dart';
import 'package:kc_admin_portal/shared/models/holiday_model.dart';

/// Adds a company holiday, or edits one ([holidayId]).
class HolidayFormDialog extends ConsumerWidget {
  const HolidayFormDialog({this.holidayId, this.initialDate, super.key});

  final String? holidayId;

  /// Adding: the date to start with (e.g. from a calendar day).
  final DateTime? initialDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = holidayId;
    if (id == null) return _HolidayForm(initialDate: initialDate);
    final holiday = ref.watch(holidayDetailProvider(id));
    if (holiday.hasValue) return _HolidayForm(initial: holiday.value);
    return AppDialog(
      title: 'Edit holiday',
      body: AsyncValueView<HolidayModel>(
        value: holiday,
        compact: true,
        onRetry: () => ref.invalidate(holidayDetailProvider(id)),
        data: (_) => const SizedBox.shrink(),
      ),
    );
  }
}

class _HolidayForm extends ConsumerStatefulWidget {
  const _HolidayForm({this.initial, this.initialDate});

  final HolidayModel? initial;
  final DateTime? initialDate;

  @override
  ConsumerState<_HolidayForm> createState() => _HolidayFormState();
}

class _HolidayFormState extends ConsumerState<_HolidayForm> {
  final _formKey = GlobalKey<FormState>();
  late DateTime? _date = widget.initial?.date ?? widget.initialDate;
  late final _name = TextEditingController(text: widget.initial?.name);
  late final _description = TextEditingController(
    text: widget.initial?.description,
  );
  Map<String, String> _serverErrors = const {};

  bool get _isEditing => widget.initial != null;

  /// How far back and ahead holidays can be set.
  static const int _yearsBack = 2;
  static const int _yearsAhead = 3;
  static const int _nameMaxLength = 100;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _serverErrors = const {});
    if (!_formKey.currentState!.validate()) return;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final saved = await ref
        .read(holidayFormControllerProvider.notifier)
        .save(
          holidayId: widget.initial?.id,
          input: HolidayInput(
            date: _date!,
            name: _name.text,
            description: _description.text,
          ),
        );
    if (saved == null || !mounted) return;
    // Show the year the holiday is in.
    ref.read(holidayQueryProvider.notifier).setYear(saved.date.year);
    showAppSnackBarOn(
      messenger,
      '${saved.name} ${_isEditing ? 'updated' : 'added'} for '
      '${AppDateFormat.long(saved.date)}',
      tone: SnackBarTone.success,
    );
    await navigator.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(holidayFormControllerProvider, (_, next) {
      final error = next.error;
      if (error is ValidationException) {
        setState(() => _serverErrors = error.fieldErrors);
      }
    });
    final submission = ref.watch(holidayFormControllerProvider);
    final isSaving = submission.isLoading;
    final today = ref.watch(clockProvider)().dateOnly;
    final error = submission.error;
    final generalError =
        error != null &&
            !isSaving &&
            (error is! ValidationException || error.fieldErrors.isEmpty)
        ? ErrorHandler.messageFor(error)
        : null;

    return AppDialog(
      title: _isEditing ? 'Edit holiday' : 'Add holiday',
      subtitle: 'Applies to every employee',
      actions: [
        AppButton(
          label: 'Cancel',
          variant: AppButtonVariant.secondary,
          onPressed: isSaving ? null : () => Navigator.of(context).maybePop(),
        ),
        AppButton(
          label: _isEditing ? 'Save changes' : 'Add holiday',
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
              label: 'Date',
              isRequired: true,
              value: _date,
              today: today,
              firstDate: DateTime(today.year - _yearsBack),
              lastDate: DateTime(today.year + _yearsAhead, 12, 31),
              enabled: !isSaving,
              errorText: _serverErrors['date'],
              helperText: 'Attendance and leave on this date are recalculated',
              validator: Validators.requiredValue('Date'),
              onChanged: (date) => setState(() {
                _date = date;
                _serverErrors = {..._serverErrors}..remove('date');
              }),
            ),
            AppTextField(
              label: 'Holiday name',
              isRequired: true,
              controller: _name,
              enabled: !isSaving,
              hintText: 'e.g. Company Holiday',
              maxLength: _nameMaxLength,
              textCapitalization: TextCapitalization.words,
              errorText: _serverErrors['name'],
              validator: (value) =>
                  Validators.required(value, field: 'Holiday name'),
            ),
            AppTextField(
              label: 'Description (optional)',
              controller: _description,
              enabled: !isSaving,
              maxLines: 3,
              errorText: _serverErrors['description'],
            ),
          ],
        ),
      ),
    );
  }
}
