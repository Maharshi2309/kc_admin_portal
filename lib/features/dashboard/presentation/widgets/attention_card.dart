import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_empty_view.dart';
import 'package:kc_admin_portal/core/widgets/app_status_badge.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/dashboard_summary_model.dart';

/// "Needs your attention": each item links to the section where it is
/// resolved.
class AttentionCard extends StatelessWidget {
  const AttentionCard({required this.items, required this.onOpen, super.key});

  final List<AttentionItemModel> items;

  /// Opens the section that resolves [kind].
  /// Opens the section for an item; null for items the role can't open.
  final VoidCallback? Function(AttentionKind kind) onOpen;

  @override
  Widget build(BuildContext context) {
    final visible = items
        .where((item) => item.kind != AttentionKind.unknown && item.count > 0)
        .toList();

    return SectionCard(
      title: 'Needs your attention',
      gap: AppSpacing.s12,
      padding: const EdgeInsets.all(AppSpacing.s20),
      trailing: visible.isEmpty
          ? null
          : AppStatusBadge(
              label: FormatUtils.count(visible.length),
              tone: StatusTone.inverse,
            ),
      child: visible.isEmpty
          ? const AppEmptyView(
              compact: true,
              icon: Icons.task_alt_rounded,
              title: 'All clear',
              message: 'Nothing needs your attention right now.',
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.s10,
              children: [
                for (final item in visible)
                  _AttentionTile(item: item, onTap: onOpen(item.kind)),
              ],
            ),
    );
  }
}

class _AttentionTile extends StatelessWidget {
  const _AttentionTile({required this.item, required this.onTap});

  final AttentionItemModel item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final count = FormatUtils.count(item.count);
    final (icon, tone, title, hint) = switch (item.kind) {
      AttentionKind.notPunchedIn => (
        Icons.schedule_rounded,
        StatusTone.danger,
        '$count not punched in',
        'Mark them in or confirm absent',
      ),
      AttentionKind.pendingLeave => (
        Icons.event_note_outlined,
        StatusTone.warning,
        item.count == 1
            ? '1 leave request pending'
            : '$count leave requests pending',
        'Review the pending requests',
      ),
      AttentionKind.lateArrival => (
        Icons.running_with_errors_rounded,
        StatusTone.late,
        item.count == 1 ? '1 late arrival' : '$count late arrivals',
        'Review or correct punch time',
      ),
      AttentionKind.unknown => (
        Icons.info_outline_rounded,
        StatusTone.neutral,
        count,
        '',
      ),
    };

    return Semantics(
      button: onTap != null,
      label: onTap == null ? title : '$title. $hint',
      excludeSemantics: true,
      child: Material(
        color: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
          side: BorderSide(color: AppColors.divider),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.lgAll,
          hoverColor: AppColors.primarySubtle,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s16,
              vertical: AppSpacing.s14,
            ),
            child: Row(
              spacing: AppSpacing.s14,
              children: [
                Container(
                  width: AppSizes.iconTile,
                  height: AppSizes.iconTile,
                  decoration: BoxDecoration(
                    color: tone.background,
                    borderRadius: AppRadius.lgAll,
                  ),
                  child: Icon(
                    icon,
                    size: AppSizes.icon,
                    color: tone.foreground,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSpacing.s2,
                    children: [
                      Text(title, style: AppTextStyles.bodyBold),
                      if (onTap != null)
                        Text(
                          hint,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                    ],
                  ),
                ),
                if (onTap != null)
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: AppSizes.iconSmall,
                    color: AppColors.textMuted,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
