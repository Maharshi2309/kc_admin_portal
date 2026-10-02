import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'package:kc_admin_portal/app/theme/app_dimensions.dart';

/// Lays children out in equal-width columns. The number of columns is as many
/// as fit at [minItemWidth], capped at [maxColumns], so the grid adapts to
/// any width without breakpoints (4 KPI cards → 2 → 1).
///
/// Items in the same row share the tallest item's height when [equalHeight]
/// is set.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    required this.children,
    required this.minItemWidth,
    this.maxColumns = 4,
    this.spacing = AppSpacing.s16,
    this.runSpacing,
    this.equalHeight = true,
    super.key,
  });

  final List<Widget> children;
  final double minItemWidth;
  final int maxColumns;
  final double spacing;

  /// Vertical gap between rows; defaults to [spacing].
  final double? runSpacing;
  final bool equalHeight;

  /// Number of columns for [itemCount] items in [width]. Exposed for tests.
  ///
  /// Uses as many columns as fit, then balances the rows so the last row is
  /// not left with a lone item (4 items in 3 columns → 2 + 2).
  static int columnsFor({
    required double width,
    required double minItemWidth,
    required double spacing,
    required int maxColumns,
    required int itemCount,
  }) {
    final fitting = ((width + spacing) / (minItemWidth + spacing)).floor();
    final columns = math.max(1, math.min(fitting, maxColumns));
    if (itemCount <= 1) return columns;

    final rows = (itemCount / columns).ceil();
    return (itemCount / rows).ceil();
  }

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = columnsFor(
          width: constraints.maxWidth,
          // Items need more room as the system font grows, so large text
          // gives fewer, wider columns instead of words broken mid-way.
          minItemWidth: MediaQuery.textScalerOf(context).scale(minItemWidth),
          spacing: spacing,
          maxColumns: maxColumns,
          itemCount: children.length,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: runSpacing ?? spacing,
          children: [
            for (var start = 0; start < children.length; start += columns)
              _buildRow(start, columns),
          ],
        );
      },
    );
  }

  Widget _buildRow(int start, int columns) {
    final row = Row(
      crossAxisAlignment: equalHeight
          ? CrossAxisAlignment.stretch
          : CrossAxisAlignment.start,
      spacing: spacing,
      children: [
        for (var i = start; i < start + columns; i++)
          Expanded(
            child: i < children.length ? children[i] : const SizedBox.shrink(),
          ),
      ],
    );
    return equalHeight ? IntrinsicHeight(child: row) : row;
  }
}
