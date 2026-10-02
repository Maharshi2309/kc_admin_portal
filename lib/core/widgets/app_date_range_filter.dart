import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_filter_dropdown.dart';
import 'package:kc_admin_portal/core/widgets/app_icon_button.dart';

/// Toolbar filter for a date range ("Dates  1 Sep – 31 Oct 2026 ▾"), with a
/// clear button while a range is set.
class AppDateRangeFilter extends StatelessWidget {
  const AppDateRangeFilter({
    required this.from,
    required this.to,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.label = 'Dates',
    this.anyLabel = 'Any time',
    super.key,
  });

  final DateTime? from;
  final DateTime? to;

  /// Called with both dates, or both null when cleared.
  final void Function(DateTime? from, DateTime? to) onChanged;
  final DateTime firstDate;
  final DateTime lastDate;
  final String label;
  final String anyLabel;

  @override
  Widget build(BuildContext context) {
    final start = from;
    final end = to;
    final isActive = start != null && end != null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s2,
      children: [
        Flexible(
          child: AppFilterChipButton(
            label: label,
            valueLabel: isActive ? AppDateFormat.range(start, end) : anyLabel,
            isActive: isActive,
            onPressed: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: firstDate,
                lastDate: lastDate,
                initialDateRange: isActive
                    ? DateTimeRange(start: start, end: end)
                    : null,
              );
              if (picked != null) onChanged(picked.start, picked.end);
            },
          ),
        ),
        if (isActive)
          AppIconButton(
            icon: Icons.close_rounded,
            tooltip: 'Clear dates',
            onPressed: () => onChanged(null, null),
          ),
      ],
    );
  }
}
