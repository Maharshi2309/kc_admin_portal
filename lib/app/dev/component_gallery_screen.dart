import 'package:flutter/material.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/widgets/app_avatar.dart';
import 'package:kc_admin_portal/core/widgets/app_breadcrumb.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_choice_chips.dart';
import 'package:kc_admin_portal/core/widgets/app_date_picker.dart';
import 'package:kc_admin_portal/core/widgets/app_dialog.dart';
import 'package:kc_admin_portal/core/widgets/app_dropdown.dart';
import 'package:kc_admin_portal/core/widgets/app_empty_view.dart';
import 'package:kc_admin_portal/core/widgets/app_error_view.dart';
import 'package:kc_admin_portal/core/widgets/app_filter_dropdown.dart';
import 'package:kc_admin_portal/core/widgets/app_icon_button.dart';
import 'package:kc_admin_portal/core/widgets/app_link.dart';
import 'package:kc_admin_portal/core/widgets/app_loader.dart';
import 'package:kc_admin_portal/core/widgets/app_page.dart';
import 'package:kc_admin_portal/core/widgets/app_pagination.dart';
import 'package:kc_admin_portal/core/widgets/app_progress_bar.dart';
import 'package:kc_admin_portal/core/widgets/app_search_field.dart';
import 'package:kc_admin_portal/core/widgets/app_segmented_control.dart';
import 'package:kc_admin_portal/core/widgets/app_side_sheet.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';
import 'package:kc_admin_portal/core/widgets/app_status_badge.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';
import 'package:kc_admin_portal/core/widgets/ec_number_text.dart';
import 'package:kc_admin_portal/core/widgets/form_footer_bar.dart';
import 'package:kc_admin_portal/core/widgets/responsive_data_view.dart';
import 'package:kc_admin_portal/core/widgets/responsive_grid.dart';

/// DEV ONLY: shows every design-system widget for visual review.
/// All labels here are placeholder text, not application data.
class ComponentGalleryScreen extends StatelessWidget {
  const ComponentGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AppPageBody(
          spacing: 0,
          children: [
            AppPageHeader(
              title: 'Design system',
              subtitle: 'Dev-only gallery of core widgets',
              breadcrumb: const AppBreadcrumb(
                items: [AppBreadcrumbItem('Dev'), AppBreadcrumbItem('Gallery')],
              ),
              actions: [
                AppButton(
                  label: 'Side sheet',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => _openSideSheet(context),
                ),
                AppButton(
                  label: 'Primary action',
                  icon: Icons.add_rounded,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s32),
            const _Section(title: 'Responsive', child: _ResponsiveDemo()),
            const _Section(title: 'Typography', child: _TypographyDemo()),
            const _Section(title: 'Buttons', child: _ButtonsDemo()),
            const _Section(title: 'Form fields', child: _FormDemo()),
            const _Section(title: 'Selection', child: _SelectionDemo()),
            const _Section(title: 'Status & identity', child: _StatusDemo()),
            const _Section(title: 'Cards', child: _CardsDemo()),
            const _Section(title: 'Feedback states', child: _FeedbackDemo()),
            const _Section(title: 'Dialogs & messages', child: _DialogsDemo()),
          ],
        ),
      ),
    );
  }

  void _openSideSheet(BuildContext context) {
    showAppSideSheet<void>(
      context,
      builder: (sheetContext) => AppSideSheet(
        title: 'Side sheet',
        footerNote: 'Footer note',
        body: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.s18,
          children: [
            AppTextField(label: 'Field one', isRequired: true),
            AppTextField(label: 'Field two', maxLines: 4),
          ],
        ),
        actions: [
          AppButton(
            label: 'Cancel',
            variant: AppButtonVariant.secondary,
            onPressed: () => Navigator.of(sheetContext).pop(),
          ),
          AppButton(
            label: 'Save',
            onPressed: () => Navigator.of(sheetContext).pop(),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: AppTextStyles.overline),
          const SizedBox(height: AppSpacing.s12),
          child,
        ],
      ),
    );
  }
}

class _TypographyDemo extends StatelessWidget {
  const _TypographyDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s8,
      children: [
        Text('Display 44', style: AppTextStyles.display),
        Text('124', style: AppTextStyles.kpiValue),
        Text('Page title 26', style: AppTextStyles.pageTitle),
        Text('Section title 16', style: AppTextStyles.sectionTitle),
        Text('Body 14 regular', style: AppTextStyles.body),
        Text('Body 14 semibold', style: AppTextStyles.bodySemibold),
        Text(
          'Caption 12 muted',
          style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
        ),
        Text('TABLE HEADER', style: AppTextStyles.tableHeader),
        const EcNumberText('KC0000'),
      ],
    );
  }
}

class _ButtonsDemo extends StatelessWidget {
  const _ButtonsDemo();

  @override
  Widget build(BuildContext context) {
    void noop() {}

    return Wrap(
      spacing: AppSpacing.s12,
      runSpacing: AppSpacing.s12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AppButton(label: 'Primary', icon: Icons.add_rounded, onPressed: noop),
        AppButton(
          label: 'Secondary',
          variant: AppButtonVariant.secondary,
          icon: Icons.download_rounded,
          onPressed: noop,
        ),
        AppButton(
          label: 'Danger',
          variant: AppButtonVariant.danger,
          onPressed: noop,
        ),
        AppButton(
          label: 'Ghost',
          variant: AppButtonVariant.ghost,
          onPressed: noop,
        ),
        AppButton(label: 'Small', size: AppButtonSize.small, onPressed: noop),
        AppButton(label: 'Saving', isLoading: true, onPressed: noop),
        const AppButton(label: 'Disabled', onPressed: null),
        AppIconButton(
          icon: Icons.notifications_none_rounded,
          tooltip: 'Notifications',
          variant: AppIconButtonVariant.outlined,
          onPressed: noop,
        ),
        AppIconButton(
          icon: Icons.edit_outlined,
          tooltip: 'Edit',
          onPressed: noop,
        ),
        AppLink(label: 'View all', onPressed: noop),
      ],
    );
  }
}

class _FormDemo extends StatefulWidget {
  const _FormDemo();

  @override
  State<_FormDemo> createState() => _FormDemoState();
}

class _FormDemoState extends State<_FormDemo> {
  final _formKey = GlobalKey<FormState>();
  String? _option;
  DateTime? _date;

  String? _required(Object? value) =>
      (value == null || (value is String && value.trim().isEmpty))
      ? 'This field is required'
      : null;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return AppCard(
      padding: EdgeInsets.zero,
      clip: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: Wrap(
                spacing: AppSpacing.s20,
                runSpacing: AppSpacing.s18,
                children: [
                  _field(
                    AppTextField(
                      label: 'Text field',
                      isRequired: true,
                      hintText: 'Type here',
                      helperText: 'Helper text',
                      validator: _required,
                    ),
                  ),
                  _field(
                    const AppTextField(
                      label: 'With prefix',
                      prefixText: '+00',
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  _field(
                    const AppTextField(
                      label: 'Locked',
                      initialValue: 'KC0000',
                      readOnly: true,
                      monospace: true,
                    ),
                  ),
                  _field(
                    const AppTextField(label: 'Password', isPassword: true),
                  ),
                  _field(
                    AppDropdown<String>(
                      label: 'Dropdown',
                      isRequired: true,
                      hintText: 'Select an option',
                      searchable: true,
                      value: _option,
                      validator: _required,
                      onChanged: (value) => setState(() => _option = value),
                      items: const [
                        AppDropdownItem(
                          value: 'a',
                          label: 'Option A',
                          meta: 'meta',
                        ),
                        AppDropdownItem(value: 'b', label: 'Option B'),
                        AppDropdownItem(value: 'c', label: 'Option C'),
                      ],
                    ),
                  ),
                  _field(
                    AppDatePicker(
                      label: 'Date',
                      isRequired: true,
                      value: _date,
                      firstDate: DateTime(now.year - 1),
                      lastDate: DateTime(now.year + 1),
                      validator: _required,
                      onChanged: (value) => setState(() => _date = value),
                    ),
                  ),
                  _field(AppSearchField(hintText: 'Search', onChanged: (_) {})),
                ],
              ),
            ),
            FormFooterBar(
              hint: '* Required',
              actions: [
                AppButton(
                  label: 'Reset',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => _formKey.currentState!.reset(),
                ),
                AppButton(
                  label: 'Validate',
                  onPressed: () => _formKey.currentState!.validate(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(Widget child) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 320),
    child: child,
  );
}

class _SelectionDemo extends StatefulWidget {
  const _SelectionDemo();

  @override
  State<_SelectionDemo> createState() => _SelectionDemoState();
}

class _SelectionDemoState extends State<_SelectionDemo> {
  int _segment = 0;
  int? _chip;
  String? _filter;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s16,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: AppSegmentedControl<int>(
            semanticLabel: 'Segmented demo',
            selected: _segment,
            onChanged: (value) => setState(() => _segment = value),
            segments: const [
              AppSegment(value: 0, label: 'First'),
              AppSegment(value: 1, label: 'Second'),
            ],
          ),
        ),
        AppChoiceChips<int>(
          selected: _chip,
          onSelected: (value) => setState(() => _chip = value),
          choices: const [
            AppChoice(value: 0, label: 'Choice one'),
            AppChoice(value: 1, label: 'Choice two'),
            AppChoice(value: 2, label: 'Choice three'),
          ],
        ),
        AppFilterDropdown<String>(
          label: 'Filter',
          value: _filter,
          onChanged: (value) => setState(() => _filter = value),
          items: const [
            AppDropdownItem(value: 'x', label: 'Value X'),
            AppDropdownItem(value: 'y', label: 'Value Y'),
          ],
        ),
        AppBreadcrumb(
          items: [
            AppBreadcrumbItem('Parent', onTap: () {}),
            const AppBreadcrumbItem('Current page'),
          ],
        ),
      ],
    );
  }
}

class _StatusDemo extends StatelessWidget {
  const _StatusDemo();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s8,
      runSpacing: AppSpacing.s8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final tone in StatusTone.values)
          AppStatusBadge(label: tone.name, tone: tone, showDot: true),
        const AppAvatar(name: 'Sample Person'),
        const AppAvatar(name: 'Another Name', size: AppSizes.avatarLarge),
        const EcNumberText('KC0000', large: true, copyable: true),
      ],
    );
  }
}

class _CardsDemo extends StatelessWidget {
  const _CardsDemo();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s16,
      runSpacing: AppSpacing.s16,
      children: [
        SizedBox(
          width: 280,
          child: AppCard(
            onTap: () {},
            semanticLabel: 'Clickable card',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s14,
              children: [
                Text(
                  'Clickable card',
                  style: AppTextStyles.bodySemibold.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                Text('0', style: AppTextStyles.kpiValue),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 320,
          child: SectionCard(
            title: 'Section card',
            subtitle: 'Subtitle',
            trailing: AppLink(label: 'Details', onPressed: () {}),
            child: const AppProgressBar(value: 0.4, thick: true),
          ),
        ),
      ],
    );
  }
}

class _FeedbackDemo extends StatelessWidget {
  const _FeedbackDemo();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s16,
      runSpacing: AppSpacing.s16,
      children: [
        const SizedBox(
          width: 280,
          child: AppCard(child: AppLoader(message: 'Loading…')),
        ),
        SizedBox(
          width: 320,
          child: AppCard(
            child: AppErrorView(
              compact: true,
              message: 'We could not load this section.',
              onRetry: () {},
            ),
          ),
        ),
        const SizedBox(
          width: 320,
          child: AppCard(
            child: AppEmptyView(
              compact: true,
              title: 'Nothing here yet',
              message: 'Records will appear here.',
            ),
          ),
        ),
      ],
    );
  }
}

class _DialogsDemo extends StatelessWidget {
  const _DialogsDemo();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s12,
      runSpacing: AppSpacing.s12,
      children: [
        AppButton(
          label: 'Confirm dialog',
          variant: AppButtonVariant.secondary,
          onPressed: () async {
            final confirmed = await showAppConfirmDialog(
              context,
              title: 'Delete item?',
              message: 'This action cannot be undone.',
              confirmLabel: 'Delete',
              isDestructive: true,
            );
            if (context.mounted) {
              showAppSnackBar(
                context,
                confirmed ? 'Confirmed' : 'Cancelled',
                tone: confirmed ? SnackBarTone.success : SnackBarTone.info,
              );
            }
          },
        ),
        AppButton(
          label: 'Dialog',
          variant: AppButtonVariant.secondary,
          onPressed: () => showDialog<void>(
            context: context,
            builder: (dialogContext) => AppDialog(
              title: 'Dialog title',
              subtitle: 'Dialog subtitle',
              footerNote: 'Footer note',
              body: const Text('Dialog body content.'),
              actions: [
                AppButton(
                  label: 'Cancel',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
                AppButton(
                  label: 'Save',
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
              ],
            ),
          ),
        ),
        AppButton(
          label: 'Error snackbar',
          variant: AppButtonVariant.secondary,
          onPressed: () => showAppSnackBar(
            context,
            'Something went wrong',
            tone: SnackBarTone.error,
          ),
        ),
      ],
    );
  }
}

/// Placeholder row for the table demo.
class _SampleRow {
  const _SampleRow(this.index);

  final int index;

  String get name => 'Person ${index + 1}';
  String get code => 'EC-${(index + 1).toString().padLeft(4, '0')}';
  String get group => 'Group ${String.fromCharCode(65 + index % 3)}';
  String get detail => 'Detail ${index + 1}';
  StatusTone get tone => StatusTone.values[index % 4];
}

class _ResponsiveDemo extends StatefulWidget {
  const _ResponsiveDemo();

  @override
  State<_ResponsiveDemo> createState() => _ResponsiveDemoState();
}

class _ResponsiveDemoState extends State<_ResponsiveDemo> {
  static const _totalRows = 124;
  int _page = 1;
  int _pageSize = 10;

  List<_SampleRow> get _rows {
    final start = (_page - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0, _totalRows);
    return [for (var i = start; i < end; i++) _SampleRow(i)];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s16,
        children: [
          ResponsiveGrid(
            minItemWidth: 200,
            children: [
              for (var i = 1; i <= 4; i++)
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSpacing.s8,
                    children: [
                      Text(
                        'Grid item $i',
                        style: AppTextStyles.bodySemibold.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text('$i', style: AppTextStyles.kpiValue),
                    ],
                  ),
                ),
            ],
          ),
          AppCard(
            padding: EdgeInsets.zero,
            clip: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.s16),
                  child: Wrap(
                    spacing: AppSpacing.s10,
                    runSpacing: AppSpacing.s10,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: AppSearchField(
                          hintText: 'Search',
                          compact: true,
                          onChanged: (_) {},
                        ),
                      ),
                      AppFilterDropdown<String>(
                        label: 'Group',
                        value: null,
                        onChanged: (_) {},
                        items: const [
                          AppDropdownItem(value: 'a', label: 'Group A'),
                        ],
                      ),
                    ],
                  ),
                ),
                ResponsiveDataView<_SampleRow>(
                  rows: _rows,
                  rowKey: (row) => row.index,
                  onRowTap: (row) => showAppSnackBar(context, row.name),
                  columns: _columns,
                  mobileItemBuilder: _mobileItem,
                ),
                AppPagination(
                  page: _page,
                  pageSize: _pageSize,
                  totalItems: _totalRows,
                  onPageChanged: (page) => setState(() => _page = page),
                  onPageSizeChanged: (size) => setState(() {
                    _pageSize = size;
                    _page = 1;
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static final List<AppDataColumn<_SampleRow>> _columns = [
    AppDataColumn(
      label: 'Name',
      flex: 2,
      minWidth: 200,
      cellBuilder: (context, row) => Row(
        spacing: AppSpacing.s12,
        children: [
          AppAvatar(name: row.name),
          Flexible(
            child: Text(
              row.name,
              style: AppTextStyles.bodySemibold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
    AppDataColumn(
      label: 'Code',
      cellBuilder: (context, row) => EcNumberText(row.code),
    ),
    AppDataColumn(
      label: 'Group',
      priority: 2,
      cellBuilder: (context, row) => Text(row.group),
    ),
    AppDataColumn(
      label: 'Detail',
      priority: 3,
      minWidth: 160,
      cellBuilder: (context, row) => Text(
        row.detail,
        style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
      ),
    ),
    AppDataColumn(
      label: 'Status',
      priority: 1,
      cellBuilder: (context, row) =>
          AppStatusBadge(label: row.tone.name, tone: row.tone, showDot: true),
    ),
    AppDataColumn(
      label: '',
      fixedWidth: 72,
      alignment: AlignmentDirectional.centerEnd,
      cellBuilder: (context, row) => AppIconButton(
        icon: Icons.more_vert_rounded,
        tooltip: 'More actions for ${row.name}',
        onPressed: () {},
      ),
    ),
  ];

  static Widget _mobileItem(BuildContext context, _SampleRow row) {
    return Row(
      spacing: AppSpacing.s12,
      children: [
        AppAvatar(name: row.name),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.s2,
            children: [
              Text(row.name, style: AppTextStyles.bodySemibold),
              Text(
                '${row.code} · ${row.group}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        AppStatusBadge(label: row.tone.name, tone: row.tone),
      ],
    );
  }
}
