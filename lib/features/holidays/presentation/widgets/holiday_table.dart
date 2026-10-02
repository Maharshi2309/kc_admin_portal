import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_dialog.dart';
import 'package:kc_admin_portal/core/widgets/app_icon_button.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';
import 'package:kc_admin_portal/core/widgets/app_status_badge.dart';
import 'package:kc_admin_portal/core/widgets/responsive_data_view.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/permission_providers.dart';
import 'package:kc_admin_portal/features/holidays/presentation/providers/holiday_providers.dart';
import 'package:kc_admin_portal/shared/models/holiday_model.dart';

/// The year's company holidays with edit and delete actions.
class HolidayTable extends StatelessWidget {
  const HolidayTable({required this.holidays, super.key});

  final List<HolidayModel> holidays;

  /// Two icon buttons at touch size (44 px) plus cell padding.
  static const double _actionsWidth = 136;

  @override
  Widget build(BuildContext context) {
    return ResponsiveDataView<HolidayModel>(
      rows: holidays,
      rowKey: (h) => h.id,
      mobileItemBuilder: (context, h) => _MobileItem(holiday: h),
      columns: [
        AppDataColumn(
          label: 'Date',
          minWidth: 170,
          cellBuilder: (context, h) =>
              Text(AppDateFormat.long(h.date), style: AppTextStyles.bodyBold),
        ),
        AppDataColumn(
          label: 'Holiday',
          flex: 3,
          minWidth: 220,
          cellBuilder: (context, h) => _NameCell(holiday: h),
        ),
        AppDataColumn(
          label: 'When',
          minWidth: 130,
          priority: 2,
          cellBuilder: (context, h) => _WhenBadge(date: h.date),
        ),
        AppDataColumn(
          label: '',
          fixedWidth: _actionsWidth,
          alignment: AlignmentDirectional.centerEnd,
          cellBuilder: (context, h) => _Actions(holiday: h),
        ),
      ],
    );
  }
}

class _NameCell extends StatelessWidget {
  const _NameCell({required this.holiday});

  final HolidayModel holiday;

  @override
  Widget build(BuildContext context) {
    final description = holiday.description;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s2,
      children: [
        Text(
          holiday.name,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodySemibold,
        ),
        if (description != null)
          Text(
            description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
          ),
      ],
    );
  }
}

/// "Today", "In 4 days" or "Past".
class _WhenBadge extends ConsumerWidget {
  const _WhenBadge({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(clockProvider)().dateOnly;
    final days = date.difference(today).inDays;
    return switch (days) {
      0 => const AppStatusBadge(label: 'Today', tone: StatusTone.success),
      1 => const AppStatusBadge(label: 'Tomorrow', tone: StatusTone.info),
      > 1 => AppStatusBadge(label: 'In $days days', tone: StatusTone.info),
      _ => const AppStatusBadge(label: 'Past', tone: StatusTone.neutral),
    };
  }
}

class _Actions extends ConsumerWidget {
  const _Actions({required this.holiday});

  final HolidayModel holiday;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showAppConfirmDialog(
      context,
      title: 'Delete ${holiday.name}?',
      message:
          '${AppDateFormat.long(holiday.date)} becomes a normal working day. '
          'Attendance and leave days on that date are recalculated; anyone '
          'who worked keeps their hours as a normal day.',
      confirmLabel: 'Delete holiday',
      isDestructive: true,
    );
    if (!confirmed) return;
    final error = await ref
        .read(holidayActionsProvider.notifier)
        .delete(holiday.id);
    showAppSnackBarOn(
      messenger,
      error ?? '${holiday.name} deleted',
      tone: error == null ? SnackBarTone.success : SnackBarTone.error,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = ref.watch(holidayActionsProvider).contains(holiday.id);
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s8,
      children: [
        if (ref.can(AppPermission.holidayEdit))
          AppIconButton(
            icon: Icons.edit_outlined,
            tooltip: 'Edit ${holiday.name}',
            onPressed: busy
                ? null
                : () => context.goNamed(
                    AppRouteNames.holidayEdit,
                    pathParameters: {AppRouteParams.id: holiday.id},
                  ),
          ),
        if (ref.can(AppPermission.holidayDelete))
          AppIconButton(
            icon: Icons.delete_outline_rounded,
            tooltip: 'Delete ${holiday.name}',
            onPressed: busy ? null : () => _delete(context, ref),
          ),
      ],
    );
  }
}

class _MobileItem extends StatelessWidget {
  const _MobileItem({required this.holiday});

  final HolidayModel holiday;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.s12,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.s4,
            children: [
              Text(holiday.name, style: AppTextStyles.bodySemibold),
              Text(
                AppDateFormat.long(holiday.date),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              _WhenBadge(date: holiday.date),
            ],
          ),
        ),
        _Actions(holiday: holiday),
      ],
    );
  }
}
