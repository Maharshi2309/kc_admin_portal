import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_icon_button.dart';

/// "‹  Today · Mon, 28 Sep  ›" from the design. The label opens a calendar;
/// dates after today cannot be chosen.
class DayPicker extends StatelessWidget {
  const DayPicker({
    required this.date,
    required this.today,
    required this.onChanged,
    required this.onPrevious,
    required this.onNext,
    super.key,
  });

  final DateTime date;
  final DateTime today;
  final ValueChanged<DateTime> onChanged;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  /// Earliest date offered by the calendar.
  static final DateTime _firstDate = DateTime(2000);

  @override
  Widget build(BuildContext context) {
    final isToday = date == today;
    final label = isToday
        ? 'Today · ${AppDateFormat.long(date)}'
        : AppDateFormat.long(date);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.borderStrong),
        borderRadius: AppRadius.lgAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIconButton(
            icon: Icons.chevron_left_rounded,
            tooltip: 'Previous day',
            onPressed: onPrevious,
          ),
          Flexible(
            child: TextButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: _firstDate,
                  lastDate: today,
                );
                if (picked != null) onChanged(picked);
              },
              icon: const Icon(
                Icons.calendar_today_outlined,
                size: AppSizes.iconSmall,
              ),
              label: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyBold,
              ),
              style: const ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(AppColors.textPrimary),
              ),
            ),
          ),
          AppIconButton(
            icon: Icons.chevron_right_rounded,
            tooltip: 'Next day',
            onPressed: isToday ? null : onNext,
          ),
        ],
      ),
    );
  }
}
