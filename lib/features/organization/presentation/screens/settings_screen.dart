import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/files/file_picking.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_dropdown.dart';
import 'package:kc_admin_portal/core/widgets/app_page.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/core/widgets/responsive_grid.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/auth_controller.dart';
import 'package:kc_admin_portal/features/employees/domain/utils/schedule_rules.dart';
import 'package:kc_admin_portal/features/employees/presentation/widgets/work_schedule_fields.dart';
import 'package:kc_admin_portal/features/organization/data/datasources/organization_remote_data_source.dart';
import 'package:kc_admin_portal/features/organization/data/models/organization_models.dart';
import 'package:kc_admin_portal/features/organization/presentation/providers/organization_providers.dart';
import 'package:kc_admin_portal/features/organization/presentation/widgets/catalog_section.dart';
import 'package:kc_admin_portal/features/organization/presentation/widgets/leave_policy_section.dart';
import 'package:kc_admin_portal/shared/models/organization_model.dart';
import 'package:kc_admin_portal/shared/models/time_zones.dart';
import 'package:kc_admin_portal/shared/widgets/organization_logo.dart';
import 'package:kc_admin_portal/shared/widgets/phone_number_field.dart';

/// Settings (`settings.manage`, 2026-10-06): the organization's name, logo
/// and time zone, its departments and positions, and its working defaults
/// (EC numbers, lateness, a new employee's schedule). Every organization
/// sets its own; nothing here is shared with others.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const double _listMinWidth = 360;

  @override
  Widget build(BuildContext context) {
    return const AppPageBody(
      children: [
        AppPageHeader(
          title: 'Settings',
          subtitle: 'Your organization and how it works',
        ),
        _ProfileSection(),
        ResponsiveGrid(
          minItemWidth: _listMinWidth,
          maxColumns: 2,
          equalHeight: false,
          children: [
            CatalogSection(kind: CatalogKind.departments),
            CatalogSection(kind: CatalogKind.positions),
          ],
        ),
        LeavePolicySection(),
        _DefaultsSection(),
      ],
    );
  }
}

String? _fieldError(Object? error, String field) =>
    error is ValidationException ? error.fieldErrors[field] : null;

/// Shows how a save went: success, or the error unless it's on a field.
void _report(
  ScaffoldMessengerState messenger,
  Object? error,
  String success, {
  Set<String> fields = const {},
}) {
  if (error == null) {
    showAppSnackBarOn(messenger, success, tone: SnackBarTone.success);
  } else if (error is! ValidationException ||
      !error.fieldErrors.keys.any(fields.contains)) {
    showAppSnackBarOn(
      messenger,
      ErrorHandler.messageFor(error),
      tone: SnackBarTone.error,
    );
  }
}

class _ProfileSection extends ConsumerStatefulWidget {
  const _ProfileSection();

  @override
  ConsumerState<_ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends ConsumerState<_ProfileSection> {
  late final _name = TextEditingController(text: _organization?.name);
  late String? _timezone = _organization?.timezone;
  Object? _error;

  static const List<String> _logoTypes = ['png', 'jpg', 'jpeg'];
  static const double _logoSize = 72;
  static const double _fieldMinWidth = 260;

  OrganizationModel? get _organization =>
      ref.read(authControllerProvider).value?.organization;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final timezone = _timezone;
    if (_name.text.trim().isEmpty || timezone == null) {
      setState(
        () => _error = const ValidationException(
          'Enter the organization name',
          fieldErrors: {'name': 'Enter the organization name'},
        ),
      );
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    final error = await ref
        .read(organizationSettingsControllerProvider.notifier)
        .updateProfile(name: _name.text, timezone: timezone);
    if (!mounted) return;
    setState(() => _error = error);
    _report(
      messenger,
      error,
      'Organization details saved',
      fields: const {'name', 'timezone'},
    );
  }

  Future<void> _uploadLogo() async {
    final messenger = ScaffoldMessenger.of(context);
    final file = await ref.read(fileChooserProvider)(extensions: _logoTypes);
    if (file == null || !mounted) return;
    if (file.bytes.length > maxLogoBytes) {
      showAppSnackBarOn(
        messenger,
        'The logo must be 1 MB or smaller.',
        tone: SnackBarTone.error,
      );
      return;
    }
    final error = await ref
        .read(organizationSettingsControllerProvider.notifier)
        .uploadLogo(file.bytes, file.name);
    _report(messenger, error, 'Logo updated');
  }

  Future<void> _removeLogo() async {
    final messenger = ScaffoldMessenger.of(context);
    final error = await ref
        .read(organizationSettingsControllerProvider.notifier)
        .removeLogo();
    _report(messenger, error, 'Logo removed');
  }

  @override
  Widget build(BuildContext context) {
    final organization = ref.watch(
      authControllerProvider.select((auth) => auth.value?.organization),
    );
    final busy = ref.watch(organizationSettingsControllerProvider);
    final saving = busy.contains('profile');
    final logoBusy = busy.contains('logo');
    final zone = _timezone;
    final zones = [
      for (final z in timeZoneOptions(include: zone))
        AppDropdownItem(value: z.id, label: z.label),
    ];

    return SectionCard(
      title: 'Organization',
      subtitle: 'Shown at the top of the menu for everyone in it',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s20,
        children: [
          Wrap(
            spacing: AppSpacing.s16,
            runSpacing: AppSpacing.s12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              OrganizationLogo(
                name: organization?.name ?? '',
                logoUrl: organization?.logoUrl,
                size: _logoSize,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.s8,
                children: [
                  Wrap(
                    spacing: AppSpacing.s8,
                    runSpacing: AppSpacing.s8,
                    children: [
                      AppButton(
                        label: organization?.logoUrl == null
                            ? 'Upload logo'
                            : 'Change logo',
                        icon: Icons.upload_rounded,
                        variant: AppButtonVariant.secondary,
                        size: AppButtonSize.small,
                        isLoading: logoBusy,
                        onPressed: _uploadLogo,
                      ),
                      if (organization?.logoUrl != null)
                        AppButton(
                          label: 'Remove',
                          variant: AppButtonVariant.ghost,
                          size: AppButtonSize.small,
                          onPressed: logoBusy ? null : _removeLogo,
                        ),
                    ],
                  ),
                  Text(
                    'PNG or JPEG, up to 1 MB. A square image works best.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          ResponsiveGrid(
            minItemWidth: _fieldMinWidth,
            maxColumns: 2,
            equalHeight: false,
            children: [
              AppTextField(
                label: 'Organization name',
                isRequired: true,
                controller: _name,
                enabled: !saving,
                maxLength: 100,
                textCapitalization: TextCapitalization.words,
                errorText: _fieldError(_error, 'name'),
              ),
              AppDropdown<String>(
                label: 'Time zone',
                isRequired: true,
                searchable: true,
                enabled: !saving,
                value: zone,
                helperText: 'Working days and lateness follow this time zone',
                errorText: _fieldError(_error, 'timezone'),
                items: zones,
                onChanged: (value) => setState(() => _timezone = value),
              ),
            ],
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: AppButton(
              label: 'Save details',
              isLoading: saving,
              onPressed: _save,
            ),
          ),
        ],
      ),
    );
  }
}

/// EC numbers, lateness and a new employee's schedule.
class _DefaultsSection extends ConsumerWidget {
  const _DefaultsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(organizationSettingsProvider);
    return SectionCard(
      title: 'Working defaults',
      subtitle: 'Used for new employees and attendance',
      child: AsyncValueView<OrganizationSettingsModel>(
        value: settings,
        compact: true,
        onRetry: () => ref.invalidate(organizationSettingsProvider),
        data: (value) => _DefaultsForm(initial: value),
      ),
    );
  }
}

class _DefaultsForm extends ConsumerStatefulWidget {
  const _DefaultsForm({required this.initial});

  final OrganizationSettingsModel initial;

  @override
  ConsumerState<_DefaultsForm> createState() => _DefaultsFormState();
}

class _DefaultsFormState extends ConsumerState<_DefaultsForm> {
  late final _prefix = TextEditingController(
    text: widget.initial.ecNumberPrefix,
  );
  late final _grace = TextEditingController(
    text: '${widget.initial.lateGraceMinutes}',
  );
  late ScheduleDraft _schedule = ScheduleDraft.fromDefault(
    widget.initial.defaultSchedule,
  );
  late String _country = widget.initial.defaultCountry;
  Map<String, String> _errors = const {};

  static const int _maxGraceMinutes = 120;
  static const int _prefixMaxLength = 6;
  static const double _fieldMinWidth = 240;

  @override
  void dispose() {
    _prefix.dispose();
    _grace.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final grace = int.tryParse(_grace.text.trim());
    final input = _schedule.toInput(DateTime(2000));
    final errors = {
      if (grace == null || grace < 0 || grace > _maxGraceMinutes)
        'lateGraceMinutes': 'Use 0 to $_maxGraceMinutes minutes',
      for (final MapEntry(:key, :value) in scheduleProblems(input).entries)
        'defaultSchedule.$key': value,
    };
    if (errors.isNotEmpty) {
      setState(() => _errors = errors);
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    final error = await ref
        .read(organizationSettingsControllerProvider.notifier)
        .updateSettings(
          OrganizationSettingsModel(
            ecNumberPrefix: _prefix.text.trim().toUpperCase(),
            lateGraceMinutes: grace!,
            defaultSchedule: DefaultScheduleModel(
              startTime: input.startTime,
              endTime: input.endTime,
              breakMinutes: input.breakMinutes,
              breakStart: input.breakStart,
              weeklyOffDays: input.weeklyOffDays,
            ),
            defaultCountry: _country,
          ),
        );
    if (!mounted) return;
    setState(
      () =>
          _errors = error is ValidationException ? error.fieldErrors : const {},
    );
    _report(
      messenger,
      error,
      'Working defaults saved',
      fields: const {'ecNumberPrefix', 'lateGraceMinutes', 'defaultCountry'},
    );
  }

  Map<String, String> get _scheduleErrors => {
    for (final MapEntry(:key, :value) in _errors.entries)
      if (key.startsWith('defaultSchedule.'))
        key.substring('defaultSchedule.'.length): value,
  };

  @override
  Widget build(BuildContext context) {
    final saving = ref
        .watch(organizationSettingsControllerProvider)
        .contains('settings');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s20,
      children: [
        ResponsiveGrid(
          minItemWidth: _fieldMinWidth,
          maxColumns: 2,
          equalHeight: false,
          children: [
            AppTextField(
              label: 'EC number prefix',
              controller: _prefix,
              enabled: !saving,
              hintText: 'e.g. KC',
              helperText:
                  'EC numbers are these letters and a number, '
                  'e.g. ${_prefix.text.isEmpty ? 'KC' : _prefix.text}1001',
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[A-Za-z]')),
                LengthLimitingTextInputFormatter(_prefixMaxLength),
              ],
              errorText: _errors['ecNumberPrefix'],
              onChanged: (_) => setState(() {}),
            ),
            AppTextField(
              label: 'Late after (minutes)',
              controller: _grace,
              enabled: !saving,
              keyboardType: TextInputType.number,
              helperText: 'A punch-in this long after the start is late',
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              errorText: _errors['lateGraceMinutes'],
            ),
            AppDropdown<String>(
              label: 'Country for phone numbers',
              searchable: true,
              enabled: !saving,
              value: _country,
              helperText:
                  'New mobile numbers start with this country code; '
                  'numbers saved without one are read as this country',
              errorText: _errors['defaultCountry'],
              items: phoneCountryItems(),
              onChanged: (code) {
                if (code != null) setState(() => _country = code);
              },
            ),
          ],
        ),
        Text('DEFAULT WORKING SCHEDULE', style: AppTextStyles.overline),
        Text(
          'Filled in for each new employee; everyone can still have their '
          'own hours.',
          style: AppTextStyles.small.copyWith(color: AppColors.textMuted),
        ),
        WorkScheduleFields(
          draft: _schedule,
          errors: _scheduleErrors,
          enabled: !saving,
          onChanged: (draft) => setState(() {
            _schedule = draft;
            _errors = const {};
          }),
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: AppButton(
            label: 'Save defaults',
            isLoading: saving,
            onPressed: _save,
          ),
        ),
      ],
    );
  }
}
