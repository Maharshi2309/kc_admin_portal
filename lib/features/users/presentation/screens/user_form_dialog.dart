import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/utils/validation_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_alert_banner.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_dialog.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/permission_providers.dart';
import 'package:kc_admin_portal/features/users/data/models/user_account_models.dart';
import 'package:kc_admin_portal/features/users/presentation/providers/user_providers.dart';
import 'package:kc_admin_portal/shared/models/employee_summary_model.dart';
import 'package:kc_admin_portal/shared/widgets/employee_picker.dart';

/// Adds a staff user, or edits one ([userId]): name, email, and an optional
/// link to their employee record. A new user starts with no permissions and
/// opens on their permissions page, to choose what they can do.
class UserFormDialog extends ConsumerWidget {
  const UserFormDialog({this.userId, super.key});

  final String? userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = userId;
    if (id == null) return const _UserForm();
    final user = ref.watch(userDetailProvider(id));
    final loaded = user.value;
    if (loaded != null) return _UserForm(initial: loaded);
    return AppDialog(
      title: 'Edit user',
      body: AsyncValueView<UserAccountModel>(
        value: user,
        compact: true,
        onRetry: () => ref.invalidate(userDetailProvider(id)),
        data: (_) => const SizedBox.shrink(),
      ),
    );
  }
}

class _UserForm extends ConsumerStatefulWidget {
  const _UserForm({this.initial});

  final UserAccountModel? initial;

  @override
  ConsumerState<_UserForm> createState() => _UserFormState();
}

class _UserFormState extends ConsumerState<_UserForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial?.name);
  late final _email = TextEditingController(text: widget.initial?.email);
  late EmployeeSummaryModel? _employee = widget.initial?.employee;
  Map<String, String> _serverErrors = const {};

  bool get _isEditing => widget.initial != null;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _serverErrors = const {});
    if (!_formKey.currentState!.validate()) return;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final controller = ref.read(userFormControllerProvider.notifier);
    final initial = widget.initial;
    final saved = initial == null
        ? await controller.create(
            UserAccountInput(
              name: _name.text,
              email: _email.text,
              employeeId: _employee?.id,
            ),
          )
        : await controller.edit(
            initial.id,
            UserAccountUpdate(
              name: _name.text,
              email: _email.text,
              employeeId: _employee?.id,
            ),
          );
    if (saved == null || !mounted) return;
    showAppSnackBarOn(
      messenger,
      _isEditing
          ? '${saved.name} updated'
          : '${saved.name} added. Now choose what they can do.',
      tone: SnackBarTone.success,
    );
    if (_isEditing) {
      await navigator.maybePop();
    } else {
      context.goNamed(
        AppRouteNames.userAccess,
        pathParameters: {AppRouteParams.id: saved.id},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(userFormControllerProvider, (_, next) {
      final error = next.error;
      if (error is ValidationException) {
        setState(() => _serverErrors = error.fieldErrors);
      }
    });
    final submission = ref.watch(userFormControllerProvider);
    final isSaving = submission.isLoading;
    final error = submission.error;
    final generalError =
        error != null &&
            !isSaving &&
            (error is! ValidationException || error.fieldErrors.isEmpty)
        ? ErrorHandler.messageFor(error)
        : null;
    // Picking an employee searches employees (`employee.view`); without it
    // an existing link is only shown.
    final canPickEmployee = ref.can(AppPermission.employeeView);

    return AppDialog(
      title: _isEditing ? 'Edit user' : 'Add user',
      // TODO — REQUIREMENT CONFIRMATION REQUIRED: the password invitation
      // email is assumed (API_CONTRACT `POST /users`).
      subtitle: _isEditing
          ? null
          : 'They get an email to set their password. You choose their '
                'permissions next.',
      actions: [
        AppButton(
          label: 'Cancel',
          variant: AppButtonVariant.secondary,
          onPressed: isSaving ? null : () => Navigator.of(context).maybePop(),
        ),
        AppButton(
          label: _isEditing ? 'Save changes' : 'Add user',
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
            AppTextField(
              label: 'Full name',
              isRequired: true,
              controller: _name,
              enabled: !isSaving,
              textCapitalization: TextCapitalization.words,
              errorText: _serverErrors['name'],
              validator: (value) =>
                  Validators.required(value, field: 'Full name'),
            ),
            AppTextField(
              label: 'Email',
              isRequired: true,
              controller: _email,
              enabled: !isSaving,
              keyboardType: TextInputType.emailAddress,
              hintText: 'name@keshav.in',
              errorText: _serverErrors['email'],
              validator: Validators.email,
            ),
            if (canPickEmployee || _employee != null)
              EmployeePicker(
                label: 'Linked employee (optional)',
                isRequired: false,
                selected: _employee,
                canChange: canPickEmployee && !isSaving,
                changeLabel: 'Remove',
                helperText: 'Link the employee record of this person, if any',
                errorText: _serverErrors['employeeId'],
                onSelected: (picked) => setState(() {
                  _employee = picked;
                  _serverErrors = {..._serverErrors}..remove('employeeId');
                }),
              ),
          ],
        ),
      ),
    );
  }
}
