import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_dropdown.dart';
import 'package:kc_admin_portal/core/widgets/app_field_label.dart';
import 'package:kc_admin_portal/core/widgets/app_segmented_control.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/core/widgets/responsive_grid.dart';
import 'package:kc_admin_portal/features/organization/data/models/organization_models.dart';
import 'package:kc_admin_portal/features/organization/presentation/providers/organization_providers.dart';

/// The organization's leave policy (2026-10-06): one paid type earning days
/// every month (or none), and one unpaid type. Balances are always
/// calculated from the leave records, so a change applies at once,
/// including to leave already taken.
class LeavePolicySection extends ConsumerWidget {
  const LeavePolicySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policy = ref.watch(leavePolicyProvider);
    return SectionCard(
      title: 'Leave',
      subtitle: 'Paid leave earned every month, and unpaid leave',
      child: AsyncValueView<LeavePolicyModel>(
        value: policy,
        compact: true,
        onRetry: () => ref.invalidate(leavePolicyProvider),
        data: (value) => _PolicyForm(initial: value),
      ),
    );
  }
}

class _PolicyForm extends ConsumerStatefulWidget {
  const _PolicyForm({required this.initial});

  final LeavePolicyModel initial;

  @override
  ConsumerState<_PolicyForm> createState() => _PolicyFormState();
}

class _PolicyFormState extends ConsumerState<_PolicyForm> {
  late bool _paid = widget.initial.paidLeaveEnabled;
  late final _paidName = TextEditingController(
    text: widget.initial.paidLeaveName,
  );
  late final _unpaidName = TextEditingController(
    text: widget.initial.unpaidLeaveName,
  );
  late double _perMonth = widget.initial.daysPerMonth;
  late bool _capped = widget.initial.carryForwardCap != null;
  late final _cap = TextEditingController(
    text: widget.initial.carryForwardCap == null
        ? ''
        : FormatUtils.count(widget.initial.carryForwardCap!),
  );
  late DateTime _start = widget.initial.accrualStartMonth.monthStart;
  Map<String, String> _errors = const {};

  static const List<double> _perMonthChoices = [0.5, 1, 1.5, 2, 2.5, 3, 4, 5];
  static const double _fieldMinWidth = 240;
  static const int _nameMaxLength = 40;

  /// Start months offered: three years back to one year ahead.
  static const int _yearsBack = 3;
  static const int _monthsAhead = 12;

  @override
  void dispose() {
    _paidName.dispose();
    _unpaidName.dispose();
    _cap.dispose();
    super.dispose();
  }

  List<DateTime> _months() {
    final now = ref.read(clockProvider)().monthStart;
    final first = DateTime(now.year - _yearsBack, now.month);
    return [
      for (
        var m = first;
        !m.isAfter(DateTime(now.year, now.month + _monthsAhead));
        m = DateTime(m.year, m.month + 1)
      )
        m,
      if (_start.isBefore(first)) _start,
    ]..sort();
  }

  Future<void> _save() async {
    final cap = _capped ? double.tryParse(_cap.text.trim()) : null;
    final errors = {
      if (_paidName.text.trim().isEmpty) 'paidLeaveName': 'Enter a name',
      if (_unpaidName.text.trim().isEmpty) 'unpaidLeaveName': 'Enter a name',
      if (_capped && (cap == null || cap < _perMonth))
        'carryForwardCap': 'At least ${FormatUtils.days(_perMonth)}',
    };
    if (errors.isNotEmpty) {
      setState(() => _errors = errors);
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    final error = await ref
        .read(organizationSettingsControllerProvider.notifier)
        .updateLeavePolicy(
          LeavePolicyModel(
            paidLeaveEnabled: _paid,
            paidLeaveName: _paidName.text,
            unpaidLeaveName: _unpaidName.text,
            daysPerMonth: _perMonth,
            carryForwardCap: cap,
            accrualStartMonth: _start,
          ),
        );
    if (!mounted) return;
    final fieldErrors = error is ValidationException
        ? error.fieldErrors
        : const <String, String>{};
    setState(() => _errors = fieldErrors);
    if (error == null) {
      showAppSnackBarOn(
        messenger,
        'Leave settings saved. Balances are recalculated.',
        tone: SnackBarTone.success,
      );
    } else if (fieldErrors.isEmpty) {
      showAppSnackBarOn(
        messenger,
        ErrorHandler.messageFor(error),
        tone: SnackBarTone.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final saving = ref
        .watch(organizationSettingsControllerProvider)
        .contains('leave-policy');
    final muted = AppTextStyles.small.copyWith(color: AppColors.textMuted);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s20,
      children: [
        AppLabeledField(
          label: 'Leave types',
          child: AppSegmentedControl<bool>(
            semanticLabel: 'Leave types',
            selected: _paid,
            onChanged: saving ? null : (paid) => setState(() => _paid = paid),
            segments: const [
              AppSegment(value: true, label: 'Paid and unpaid'),
              AppSegment(value: false, label: 'Unpaid only'),
            ],
          ),
        ),
        ResponsiveGrid(
          minItemWidth: _fieldMinWidth,
          maxColumns: 2,
          equalHeight: false,
          children: [
            if (_paid)
              AppTextField(
                label: 'Paid leave name',
                controller: _paidName,
                enabled: !saving,
                hintText: 'e.g. Casual',
                maxLength: _nameMaxLength,
                textCapitalization: TextCapitalization.words,
                errorText: _errors['paidLeaveName'],
              ),
            AppTextField(
              label: 'Unpaid leave name',
              controller: _unpaidName,
              enabled: !saving,
              hintText: 'e.g. Unpaid',
              maxLength: _nameMaxLength,
              textCapitalization: TextCapitalization.words,
              errorText: _errors['unpaidLeaveName'],
            ),
            if (_paid) ...[
              AppDropdown<double>(
                label: 'Paid days earned each month',
                value: _perMonth,
                enabled: !saving,
                errorText: _errors['daysPerMonth'],
                items: [
                  for (final days in _perMonthChoices)
                    AppDropdownItem(value: days, label: FormatUtils.days(days)),
                ],
                onChanged: (days) {
                  if (days != null) setState(() => _perMonth = days);
                },
              ),
              AppDropdown<DateTime>(
                label: 'Earned from',
                value: _start,
                enabled: !saving,
                helperText: 'People who join later start in their first month',
                errorText: _errors['accrualStartMonth'],
                items: [
                  for (final month in _months())
                    AppDropdownItem(
                      value: month,
                      label: AppDateFormat.monthYear(month),
                    ),
                ],
                onChanged: (month) {
                  if (month != null) setState(() => _start = month);
                },
              ),
            ],
          ],
        ),
        if (_paid) ...[
          AppLabeledField(
            label: 'Unused paid days carry forward',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.s10,
              children: [
                AppSegmentedControl<bool>(
                  semanticLabel: 'Unused paid days carry forward',
                  selected: _capped,
                  onChanged: saving
                      ? null
                      : (capped) => setState(() => _capped = capped),
                  segments: const [
                    AppSegment(value: false, label: 'No limit'),
                    AppSegment(value: true, label: 'Up to a limit'),
                  ],
                ),
                if (_capped)
                  AppTextField(
                    controller: _cap,
                    enabled: !saving,
                    hintText: 'Days, e.g. 12',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    helperText:
                        'A full balance stops earning until days are used',
                    errorText: _errors['carryForwardCap'],
                  ),
              ],
            ),
          ),
          Text(
            "A later month's days can't be used early. Leave beyond the "
            'paid days left can be saved as unpaid.',
            style: muted,
          ),
        ],
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.s12,
          runSpacing: AppSpacing.s12,
          children: [
            Text(
              'Balances are recalculated from the leave already taken.',
              style: muted,
            ),
            AppButton(
              label: 'Save leave settings',
              isLoading: saving,
              onPressed: _save,
            ),
          ],
        ),
      ],
    );
  }
}
