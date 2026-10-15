import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/utils/duration_format.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/utils/phone_utils.dart';
import 'package:kc_admin_portal/core/utils/validation_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_alert_banner.dart';
import 'package:kc_admin_portal/core/widgets/app_breadcrumb.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_date_picker.dart';
import 'package:kc_admin_portal/core/widgets/app_dropdown.dart';
import 'package:kc_admin_portal/core/widgets/app_field_label.dart';
import 'package:kc_admin_portal/core/widgets/app_page.dart';
import 'package:kc_admin_portal/core/widgets/app_segmented_control.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/core/widgets/form_footer_bar.dart';
import 'package:kc_admin_portal/core/widgets/responsive_grid.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/employees/domain/utils/schedule_rules.dart';
import 'package:kc_admin_portal/features/employees/presentation/providers/employee_providers.dart';
import 'package:kc_admin_portal/features/employees/presentation/widgets/employee_preview_card.dart';
import 'package:kc_admin_portal/features/employees/presentation/widgets/work_schedule_card.dart';
import 'package:kc_admin_portal/features/employees/presentation/widgets/work_schedule_fields.dart';
import 'package:kc_admin_portal/features/organization/data/models/organization_models.dart';
import 'package:kc_admin_portal/features/organization/presentation/providers/organization_providers.dart';
import 'package:kc_admin_portal/shared/models/named_ref.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/widgets/phone_number_field.dart';

/// Add employee (`employeeId == null`) or edit one (design board 04).
class EmployeeFormScreen extends ConsumerWidget {
  const EmployeeFormScreen({this.employeeId, super.key});

  final String? employeeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = employeeId;
    if (id == null) return const _EmployeeForm();

    // Editing: load the record first, then fill the form once.
    final employee = ref.watch(employeeDetailProvider(id));
    return employee.hasValue
        ? _EmployeeForm(initial: employee.value)
        : AppPageBody(
            children: [
              AsyncValueView<EmployeeModel>(
                value: employee,
                onRetry: () => ref.invalidate(employeeDetailProvider(id)),
                data: (_) => const SizedBox.shrink(),
              ),
            ],
          );
  }
}

class _EmployeeForm extends ConsumerStatefulWidget {
  const _EmployeeForm({this.initial});

  /// The employee being edited; null when adding.
  final EmployeeModel? initial;

  @override
  ConsumerState<_EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends ConsumerState<_EmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  late final _ecNumber = TextEditingController(text: widget.initial?.ecNumber);
  late final _name = TextEditingController(text: widget.initial?.name);
  late final _mobile = TextEditingController(
    text: widget.initial == null
        ? null
        : PhoneUtils.nationalDigits(
            widget.initial!.mobile,
            country: _phoneCountry,
          ),
  );

  /// The mobile number's country: the saved number's, or the
  /// organization's default (2026-10-13).
  late String _phoneCountry = PhoneUtils.countryOf(
    widget.initial?.mobile,
    fallback: ref.read(defaultPhoneCountryProvider),
  );

  /// The admin picked the country, so the default must not replace it.
  bool _phoneCountryChosen = false;
  late NamedRef? _department = widget.initial?.department;
  late NamedRef? _position = widget.initial?.position;
  late DateTime? _joiningDate = widget.initial?.joiningDate;
  late EmployeeStatus _status =
      widget.initial?.status == EmployeeStatus.inactive
      ? EmployeeStatus.inactive
      : EmployeeStatus.active;

  /// Field errors from the last failed save, keyed like the API fields.
  Map<String, String> _serverErrors = const {};

  /// Adding only: the first working schedule, applied from the joining date.
  /// Starts as the organization's default schedule.
  ScheduleDraft _schedule = ScheduleDraft.standard;

  /// The admin changed the schedule, so the default must not replace it.
  bool _scheduleEdited = false;

  /// Schedule problems found before saving or sent by the server
  /// (`schedule.startTime` → `startTime`).
  Map<String, String> _scheduleErrors = const {};

  /// The EC number was typed by the admin, so a suggestion must not
  /// overwrite it.
  bool _ecEdited = false;

  bool get _isEditing => widget.initial != null;

  /// Wide enough to show the preview beside the form.
  static const double _previewMinWidth = 900;
  static const double _previewWidth = 340;
  static const double _fieldMinWidth = 280;

  /// Window height (at normal text size) below which the action bar scrolls
  /// with the form instead of staying pinned.
  static const double _stickyFooterMinHeight = 560;

  /// Joining dates accepted by the picker.
  ///
  /// TODO — REQUIREMENT CONFIRMATION REQUIRED: the design notes "future
  /// dates allowed up to 60 days"; used here until the rule is confirmed.
  static const int _maxFutureJoiningDays = 60;
  static final DateTime _earliestJoiningDate = DateTime(1970);

  @override
  void initState() {
    super.initState();
    // Adding: fill in the suggested EC number (now or when it arrives)
    // unless the admin has typed one. Set outside build so listeners of the
    // text controller are never notified mid-build.
    if (!_isEditing) {
      ref.listenManual(defaultPhoneCountryProvider, (_, next) {
        if (!_phoneCountryChosen) setState(() => _phoneCountry = next);
      });
      ref.listenManual(organizationSettingsProvider, fireImmediately: true, (
        _,
        next,
      ) {
        final defaults = next.value?.defaultSchedule;
        if (defaults == null || _scheduleEdited) return;
        setState(() => _schedule = ScheduleDraft.fromDefault(defaults));
      });
      ref.listenManual(nextEcNumberProvider, fireImmediately: true, (_, next) {
        final suggestion = next.value;
        if (suggestion != null && !_ecEdited) _ecNumber.text = suggestion;
      });
    }
  }

  @override
  void dispose() {
    for (final controller in [_ecNumber, _name, _mobile]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _clearServerError(String field) {
    if (!_serverErrors.containsKey(field)) return;
    setState(() => _serverErrors = {..._serverErrors}..remove(field));
  }

  /// The number as sent: international (`+919825011234`) when valid.
  String get _storedMobile =>
      PhoneUtils.toStored(_mobile.text, country: _phoneCountry) ??
      _mobile.text.trim();

  List<String> get _missingRequired => [
    if (_ecNumber.text.trim().isEmpty) 'EC number',
    if (_name.text.trim().isEmpty) 'Full name',
    if (_mobile.text.trim().isEmpty) 'Mobile number',
    if (_department == null) 'Department',
    if (_position == null) 'Position',
    if (_joiningDate == null) 'Joining date',
  ];

  Future<void> _save({bool addAnother = false}) async {
    ref.read(employeeFormControllerProvider.notifier).clearError();
    setState(() {
      _serverErrors = const {};
      _scheduleErrors = const {};
    });
    final fieldsValid = _formKey.currentState!.validate();
    final schedule = _isEditing || _joiningDate == null
        ? null
        : _schedule.toInput(_joiningDate!);
    if (schedule != null) {
      final problems = scheduleProblems(schedule);
      if (problems.isNotEmpty) setState(() => _scheduleErrors = problems);
      if (problems.isNotEmpty || !fieldsValid) return;
    }
    if (!fieldsValid) return;

    final saved = await ref
        .read(employeeFormControllerProvider.notifier)
        .save(
          employeeId: widget.initial?.id,
          data: EmployeeFormData(
            ecNumber: _ecNumber.text,
            name: _name.text,
            mobile: _storedMobile,
            departmentId: _department!.id,
            positionId: _position!.id,
            joiningDate: _joiningDate!,
            status: _status,
            schedule: schedule,
          ),
        );
    if (saved == null || !mounted) return;

    showAppSnackBar(
      context,
      '${saved.name} ${_isEditing ? 'updated' : 'added'}',
      tone: SnackBarTone.success,
    );
    if (addAnother) {
      _resetForAnother();
    } else {
      context.goNamed(
        AppRouteNames.employeeProfile,
        pathParameters: {AppRouteParams.id: saved.id},
      );
    }
  }

  void _resetForAnother() {
    _formKey.currentState!.reset();
    for (final controller in [_ecNumber, _name, _mobile]) {
      controller.clear();
    }
    ref.invalidate(nextEcNumberProvider);
    setState(() {
      _ecEdited = false;
      _department = null;
      _position = null;
      _joiningDate = null;
      _status = EmployeeStatus.active;
      _scheduleEdited = false;
      _schedule = switch (ref.read(organizationSettingsProvider).value) {
        final settings? => ScheduleDraft.fromDefault(settings.defaultSchedule),
        null => ScheduleDraft.standard,
      };
      _scheduleErrors = const {};
    });
  }

  void _cancel() {
    final initial = widget.initial;
    if (initial == null) {
      context.goNamed(AppRouteNames.employees);
    } else {
      context.goNamed(
        AppRouteNames.employeeProfile,
        pathParameters: {AppRouteParams.id: initial.id},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final submission = ref.watch(employeeFormControllerProvider);
    final isSaving = submission.isLoading;

    // Show server-side field errors next to their fields.
    ref.listen(employeeFormControllerProvider, (_, next) {
      final error = next.error;
      if (error is ValidationException) {
        const prefix = 'schedule.';
        setState(() {
          _serverErrors = error.fieldErrors;
          _scheduleErrors = {
            for (final MapEntry(:key, :value) in error.fieldErrors.entries)
              if (key.startsWith(prefix)) key.substring(prefix.length): value,
          };
        });
      }
    });

    final title = _isEditing ? 'Edit employee' : 'Add employee';
    final generalError =
        submission.hasError &&
            !isSaving &&
            (submission.error is! ValidationException ||
                (submission.error! as ValidationException).fieldErrors.isEmpty)
        ? ErrorHandler.messageFor(submission.error!)
        : null;

    final footer = ListenableBuilder(
      listenable: Listenable.merge([_ecNumber, _name, _mobile]),
      builder: (context, _) => FormFooterBar(
        hint: _footerHint(),
        actions: [
          AppButton(
            label: 'Cancel',
            variant: AppButtonVariant.secondary,
            onPressed: isSaving ? null : _cancel,
          ),
          if (!_isEditing)
            AppButton(
              label: 'Save & add another',
              variant: AppButtonVariant.secondary,
              onPressed: isSaving ? null : () => _save(addAnother: true),
            ),
          AppButton(
            label: _isEditing ? 'Save changes' : 'Save employee',
            isLoading: isSaving,
            onPressed: _save,
          ),
        ],
      ),
    );
    // On short screens (landscape phones, large text) a sticky bar would
    // hide most of the form, so it scrolls with the form instead.
    final stickyFooter =
        MediaQuery.sizeOf(context).height >=
        MediaQuery.textScalerOf(context).scale(_stickyFooterMinHeight);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            child: AppPageBody(
              maxWidth: _previewMinWidth + _previewWidth,
              children: [
                AppPageHeader(
                  title: title,
                  breadcrumb: AppBreadcrumb(
                    items: [
                      AppBreadcrumbItem(
                        'Employees',
                        onTap: () => context.goNamed(AppRouteNames.employees),
                      ),
                      if (widget.initial != null)
                        AppBreadcrumbItem(widget.initial!.name, onTap: _cancel),
                      AppBreadcrumbItem(title),
                    ],
                  ),
                ),
                if (generalError != null) AppAlertBanner(message: generalError),
                ListenableBuilder(
                  listenable: Listenable.merge([_ecNumber, _name, _mobile]),
                  builder: (context, _) => LayoutBuilder(
                    builder: (context, constraints) =>
                        constraints.maxWidth >= _previewMinWidth
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: AppSpacing.s20,
                            children: [
                              Expanded(child: _formCard(isSaving)),
                              SizedBox(width: _previewWidth, child: _preview()),
                            ],
                          )
                        : _formCard(isSaving),
                  ),
                ),
                if (!stickyFooter) footer,
              ],
            ),
          ),
        ),
        if (stickyFooter) footer,
      ],
    );
  }

  String _footerHint() {
    final missing = _missingRequired;
    if (missing.isEmpty) return '* Required · all required fields filled';
    return '* Required · ${missing.length} '
        '${missing.length == 1 ? 'field' : 'fields'} left: '
        '${missing.join(', ')}';
  }

  Widget _preview() {
    return EmployeePreviewCard(
      name: _name.text,
      ecNumber: _ecNumber.text,
      mobile: _storedMobile,
      departmentName: _department?.name,
      positionName: _position?.name,
      joiningDate: _joiningDate,
    );
  }

  Widget _formCard(bool isSaving) {
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s28,
        vertical: AppSpacing.s24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s20,
        children: [
          Text('IDENTITY', style: AppTextStyles.overline),
          ResponsiveGrid(
            minItemWidth: _fieldMinWidth,
            maxColumns: 2,
            spacing: AppSpacing.s20,
            runSpacing: AppSpacing.s18,
            equalHeight: false,
            children: _identityFields(isSaving),
          ),
          const Divider(color: AppColors.divider),
          Text('JOB DETAILS', style: AppTextStyles.overline),
          ResponsiveGrid(
            minItemWidth: _fieldMinWidth,
            maxColumns: 2,
            spacing: AppSpacing.s20,
            runSpacing: AppSpacing.s18,
            equalHeight: false,
            children: _jobFields(isSaving),
          ),
          const Divider(color: AppColors.divider),
          Text('WORKING SCHEDULE', style: AppTextStyles.overline),
          if (_isEditing)
            _CurrentSchedule(employee: widget.initial!)
          else ...[
            Text(
              'Applies from the joining date. Each employee can have their '
              'own hours.',
              style: AppTextStyles.small.copyWith(color: AppColors.textMuted),
            ),
            WorkScheduleFields(
              draft: _schedule,
              errors: _scheduleErrors,
              enabled: !isSaving,
              onChanged: (draft) => setState(() {
                _scheduleEdited = true;
                _schedule = draft;
                _scheduleErrors = const {};
              }),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _identityFields(bool isSaving) => [
    AppTextField(
      label: 'EC number',
      isRequired: true,
      controller: _ecNumber,
      monospace: true,
      enabled: !isSaving,
      hintText: 'KC1001',
      helperText: _isEditing
          ? null
          : 'Next number suggested · you can change it',
      errorText: _serverErrors['ecNumber'],
      textCapitalization: TextCapitalization.characters,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
        TextInputFormatter.withFunction(
          (_, next) => next.copyWith(text: next.text.toUpperCase()),
        ),
      ],
      validator: (value) => Validators.ecNumber(
        value,
        prefix: ref.read(organizationSettingsProvider).value?.ecNumberPrefix,
      ),
      onChanged: (_) {
        _ecEdited = true;
        _clearServerError('ecNumber');
      },
    ),
    AppTextField(
      label: 'Full name',
      isRequired: true,
      controller: _name,
      enabled: !isSaving,
      textCapitalization: TextCapitalization.words,
      autofillHints: const [AutofillHints.name],
      errorText: _serverErrors['name'],
      validator: (value) => Validators.required(value, field: 'Full name'),
      onChanged: (_) => _clearServerError('name'),
    ),
    PhoneNumberField(
      controller: _mobile,
      country: _phoneCountry,
      enabled: !isSaving,
      onCountryChanged: (country) {
        setState(() {
          _phoneCountry = country;
          _phoneCountryChosen = true;
        });
        _clearServerError('mobile');
      },
      errorText: _serverErrors['mobile'],
      onChanged: (_) => _clearServerError('mobile'),
    ),
  ];

  /// A department or position: the active ones, plus the employee's
  /// current one even if it has been deactivated since.
  Widget _catalogField(
    CatalogKind kind,
    NamedRef? value,
    bool isSaving,
    ValueChanged<NamedRef> onChanged,
  ) {
    final field = kind == CatalogKind.departments
        ? 'departmentId'
        : 'positionId';
    final label = kind.singular;
    final choices = [...ref.watch(catalogChoicesProvider(kind))];
    if (value != null && !choices.any((c) => c.id == value.id)) {
      choices.add(value);
    }
    final loaded = ref.watch(catalogProvider(kind)).hasValue;
    return AppDropdown<String>(
      label: label,
      isRequired: true,
      enabled: !isSaving,
      hintText: 'Select ${label.toLowerCase()}',
      value: value?.id,
      helperText: loaded && choices.isEmpty
          ? 'No ${kind.plural.toLowerCase()} yet: add them in Settings'
          : null,
      errorText: _serverErrors[field],
      validator: Validators.requiredValue(label),
      items: [
        for (final choice in choices)
          AppDropdownItem(value: choice.id, label: choice.name),
      ],
      onChanged: (id) {
        _clearServerError(field);
        final chosen = choices.where((c) => c.id == id).firstOrNull;
        if (chosen != null) onChanged(chosen);
      },
    );
  }

  List<Widget> _jobFields(bool isSaving) {
    final today = ref.watch(clockProvider)().dateOnly;

    return [
      // The organization's own lists (Settings); independent of each other.
      _catalogField(CatalogKind.departments, _department, isSaving, (value) {
        setState(() => _department = value);
      }),
      _catalogField(CatalogKind.positions, _position, isSaving, (value) {
        setState(() => _position = value);
      }),
      AppDatePicker(
        label: 'Joining date',
        isRequired: true,
        enabled: !isSaving,
        value: _joiningDate,
        firstDate: _earliestJoiningDate,
        lastDate: today.add(const Duration(days: _maxFutureJoiningDays)),
        today: today,
        errorText: _serverErrors['joiningDate'],
        validator: Validators.requiredValue('Joining date'),
        onChanged: (date) {
          _clearServerError('joiningDate');
          setState(() => _joiningDate = date);
        },
      ),
      AppLabeledField(
        label: 'Employee status',
        child: AppSegmentedControl<EmployeeStatus>(
          semanticLabel: 'Employee status',
          selected: _status,
          onChanged: isSaving
              ? null
              : (status) => setState(() => _status = status),
          segments: [
            for (final status in [
              EmployeeStatus.active,
              EmployeeStatus.inactive,
            ])
              AppSegment(value: status, label: status.label),
          ],
        ),
      ),
    ];
  }
}

/// Edit mode: the current schedule, changed through its own dialog (a new
/// version from a date), opened over the form so unsaved edits stay.
class _CurrentSchedule extends StatelessWidget {
  const _CurrentSchedule({required this.employee});

  final EmployeeModel employee;

  @override
  Widget build(BuildContext context) {
    final schedule = employee.schedule;
    final summary = schedule == null
        ? 'No working schedule set'
        : [
            '${schedule.startTime.toApi()}–${schedule.endTime.toApi()}',
            WorkScheduleCard.breakText(schedule),
            if (schedule.weeklyOffDays.isNotEmpty)
              '${FormatUtils.weekdays(schedule.weeklyOffDays)} off',
            '${DurationFormat.full(schedule.expectedMinutes)} a day',
          ].join(' · ');

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.s16,
      runSpacing: AppSpacing.s12,
      children: [
        Text(summary, style: AppTextStyles.bodySemibold),
        AppButton(
          label: schedule == null ? 'Set schedule' : 'Change schedule',
          icon: Icons.schedule_rounded,
          variant: AppButtonVariant.secondary,
          size: AppButtonSize.small,
          onPressed: () => context.pushNamed(
            AppRouteNames.employeeSchedule,
            pathParameters: {AppRouteParams.id: employee.id},
          ),
        ),
      ],
    );
  }
}
