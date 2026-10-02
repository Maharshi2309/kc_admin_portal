import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/responsive_grid.dart';
import 'package:kc_admin_portal/features/attendance/data/models/attendance_models.dart';

/// The day's counts as tiles; selecting one filters the list (design
/// board 06). Counts come from the backend.
class StatusFilterTiles extends StatelessWidget {
  const StatusFilterTiles({
    required this.summary,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final AttendanceDaySummaryModel summary;
  final AttendanceFilter selected;
  final ValueChanged<AttendanceFilter> onSelected;

  static const double _minTileWidth = 140;

  static Color _swatch(AttendanceFilter filter) => switch (filter) {
    AttendanceFilter.all => AppColors.inverse,
    AttendanceFilter.present => AppColors.successSwatch,
    AttendanceFilter.late => AppColors.lateSwatch,
    AttendanceFilter.onLeave => AppColors.warningSwatch,
    AttendanceFilter.absent => AppColors.dangerSwatch,
  };

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Filter by status',
      container: true,
      child: ResponsiveGrid(
        minItemWidth: _minTileWidth,
        maxColumns: AttendanceFilter.values.length,
        spacing: AppSpacing.s12,
        children: [
          for (final filter in AttendanceFilter.values)
            _Tile(
              label: filter.label,
              count: filter.countIn(summary),
              swatch: _swatch(filter),
              isSelected: filter == selected,
              onTap: () => onSelected(filter),
            ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.label,
    required this.count,
    required this.swatch,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int count;
  final Color swatch;
  final bool isSelected;
  final VoidCallback onTap;

  static const double _swatchSize = 10;
  static const double _selectedBorderWidth = 2;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: '$label: ${FormatUtils.count(count)}',
      excludeSemantics: true,
      child: Material(
        color: isSelected ? AppColors.primarySubtle : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardAll,
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? _selectedBorderWidth : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.cardAll,
          hoverColor: AppColors.primarySubtle,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s18,
              vertical: AppSpacing.s16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s8,
              children: [
                Row(
                  spacing: AppSpacing.s8,
                  children: [
                    Container(
                      width: _swatchSize,
                      height: _swatchSize,
                      decoration: BoxDecoration(
                        color: swatch,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        label,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySemibold.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(FormatUtils.count(count), style: AppTextStyles.statLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
