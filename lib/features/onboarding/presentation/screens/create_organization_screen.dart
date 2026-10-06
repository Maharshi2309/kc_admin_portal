import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/utils/validation_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_dropdown.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/auth_controller.dart';
import 'package:kc_admin_portal/features/auth/presentation/screens/login_screen.dart';
import 'package:kc_admin_portal/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:kc_admin_portal/features/onboarding/presentation/widgets/account_page_parts.dart';
import 'package:kc_admin_portal/shared/models/time_zones.dart';

/// "Create your organization": only its name and time zone. Everything else
/// (logo, departments, leave, holidays, people) is set up inside it later.
/// The creator becomes its owner, with every permission.
class CreateOrganizationScreen extends ConsumerStatefulWidget {
  const CreateOrganizationScreen({super.key});

  @override
  ConsumerState<CreateOrganizationScreen> createState() =>
      _CreateOrganizationScreenState();
}

class _CreateOrganizationScreenState
    extends ConsumerState<CreateOrganizationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  late String _timezone = suggestedTimeZone(
    ref.read(clockProvider)().timeZoneOffset,
  );

  /// The one-tap leave preset (approved 2026-10-06): 1 paid day a month,
  /// carried forward. Off: unpaid leave only, set up later in Settings.
  bool _paidLeave = true;

  static const int _nameMaxLength = 100;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final created = await ref
        .read(createOrganizationControllerProvider.notifier)
        .submit(name: _name.text, timezone: _timezone, paidLeave: _paidLeave);
    // The first organization: open it. (Creating another one replaces the
    // whole app, which then opens on its own.)
    if (created && mounted) context.goNamed(AppRouteNames.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final submission = ref.watch(createOrganizationControllerProvider);
    final sending = submission.isLoading;
    final error = sending ? null : submission.error;
    final firstOne =
        ref.watch(authControllerProvider).value?.needsOrganization ?? true;

    return AuthLayout(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.s20,
          children: [
            AccountPageHeader(
              title: firstOne
                  ? 'Create your organization'
                  : 'Create another organization',
              subtitle:
                  'It has its own employees, attendance, leave and '
                  "settings. You'll be its owner and can invite others.",
            ),
            SubmissionError(error: error),
            AppTextField(
              label: 'Organization name',
              isRequired: true,
              controller: _name,
              large: true,
              hintText: 'e.g. Sunrise Garments',
              prefixIcon: Icons.business_outlined,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              maxLength: _nameMaxLength,
              enabled: !sending,
              errorText: fieldErrorOf(error, 'name'),
              validator: (value) =>
                  Validators.required(value, field: 'Organization name'),
              onFieldSubmitted: (_) => _submit(),
            ),
            AppDropdown<String>(
              label: 'Time zone',
              isRequired: true,
              searchable: true,
              value: _timezone,
              enabled: !sending,
              helperText: 'Working days and lateness follow this time zone',
              errorText: fieldErrorOf(error, 'timezone'),
              onChanged: (zone) {
                if (zone != null) setState(() => _timezone = zone);
              },
              items: [
                for (final zone in timeZoneChoices)
                  AppDropdownItem(value: zone.id, label: timeZoneLabel(zone)),
              ],
            ),
            _PaidLeaveChoice(
              value: _paidLeave,
              onChanged: sending
                  ? null
                  : (value) => setState(() => _paidLeave = value),
            ),
            AppButton(
              label: 'Create organization',
              size: AppButtonSize.large,
              expand: true,
              isLoading: sending,
              onPressed: _submit,
            ),
            AccountLinkLine(
              text: firstOne ? 'Changed your mind?' : 'Not now?',
              linkLabel: 'Go back',
              onPressed: sending
                  ? null
                  : () => context.goNamed(
                      firstOne
                          ? AppRouteNames.welcome
                          : AppRouteNames.dashboard,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Start with paid leave" and what it means; changeable later in Settings.
class _PaidLeaveChoice extends StatelessWidget {
  const _PaidLeaveChoice({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;
    return MergeSemantics(
      child: InkWell(
        onTap: enabled ? () => onChanged!(!value) : null,
        borderRadius: AppRadius.lgAll,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.s12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: AppRadius.lgAll,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.s8,
            children: [
              Checkbox(
                value: value,
                onChanged: enabled ? (checked) => onChanged!(checked!) : null,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.s2,
                  children: [
                    Text(
                      'Start with paid leave',
                      style: AppTextStyles.bodySemibold,
                    ),
                    Text(
                      value
                          ? 'Everyone earns 1 paid day a month, carried '
                                'forward. Extra days can be taken as unpaid. '
                                'Change it any time in Settings.'
                          : 'Only unpaid leave for now. You can set up paid '
                                'leave later in Settings.',
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
