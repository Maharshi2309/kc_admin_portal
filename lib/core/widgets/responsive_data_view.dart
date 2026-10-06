import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/responsive/app_breakpoints.dart';
import 'package:kc_admin_portal/core/responsive/layout_mode.dart';

/// One table column of a [ResponsiveDataView].
class AppDataColumn<T> {
  const AppDataColumn({
    required this.label,
    required this.cellBuilder,
    this.flex = 1,
    this.minWidth = 120,
    this.fixedWidth,
    this.priority = 0,
    this.alignment = AlignmentDirectional.centerStart,
  });

  /// Header text; empty for action columns.
  final String label;
  final Widget Function(BuildContext context, T row) cellBuilder;

  /// Share of the remaining width once minimum widths are met.
  final int flex;

  /// Width below which the column should be hidden or the table scrolled
  /// (includes cell padding).
  final double minWidth;

  /// Exact width (checkbox or action columns). Overrides [flex]/[minWidth].
  final double? fixedWidth;

  /// 0 = always shown. When space runs out, the column with the highest
  /// priority number is hidden first.
  final int priority;
  final AlignmentGeometry alignment;

  double get requiredWidth => fixedWidth ?? minWidth;
}

/// Shows rows as a table on tablet and wider, and as a divided list of
/// compact items on phones.
///
/// As the table narrows, columns are hidden by [AppDataColumn.priority]. If
/// the always-shown columns still do not fit, the table scrolls horizontally
/// inside its own box, never the page.
///
/// Rows are laid out eagerly: use with paginated or "load more" data, not
/// unbounded lists.
class ResponsiveDataView<T> extends StatelessWidget {
  const ResponsiveDataView({
    required this.rows,
    required this.columns,
    required this.mobileItemBuilder,
    this.onRowTap,
    this.rowKey,
    this.tableMinWidth = AppBreakpoints.tablet,
    super.key,
  });

  final List<T> rows;
  final List<AppDataColumn<T>> columns;

  /// Content of one list item on phones.
  final Widget Function(BuildContext context, T row) mobileItemBuilder;
  final ValueChanged<T>? onRowTap;

  /// Stable identity for each row (e.g. its id) to keep row state on updates.
  final Object Function(T row)? rowKey;

  /// Below this available width rows show as list items. Defaults to the
  /// phone breakpoint; small tables inside cards may lower it.
  final double tableMinWidth;

  /// Columns that fit in [width], in their original order. Exposed for tests.
  static List<AppDataColumn<R>> visibleColumnsFor<R>(
    List<AppDataColumn<R>> columns,
    double width,
  ) {
    final visible = [...columns];
    double totalWidth() =>
        visible.fold(0, (sum, column) => sum + column.requiredWidth);

    while (totalWidth() > width) {
      final hideable = visible.where((column) => column.priority > 0).toList();
      if (hideable.isEmpty) break;
      // Highest priority number goes first; among equals, the rightmost.
      final toHide = hideable.reduce(
        (a, b) => b.priority >= a.priority ? b : a,
      );
      visible.remove(toHide);
    }
    return visible;
  }

  /// Width of each of [columns] in a table [width] wide: every column gets
  /// at least its required width, then leftover space is shared by flex.
  /// Exposed for tests.
  static List<double> columnWidthsFor<R>(
    List<AppDataColumn<R>> columns,
    double width,
  ) {
    final required = columns.fold<double>(0, (s, c) => s + c.requiredWidth);
    final totalFlex = columns
        .where((c) => c.fixedWidth == null)
        .fold<int>(0, (s, c) => s + c.flex);
    final extra = width > required ? width - required : 0.0;
    return [
      for (final column in columns)
        column.fixedWidth ??
            column.minWidth +
                (totalFlex == 0 ? 0 : extra * column.flex / totalFlex),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Desktop mode shows the table (scrolling sideways if needed)
        // wherever the screen has room for the desktop layout.
        final desktopMode =
            LayoutModeScope.of(context) == LayoutMode.desktop &&
            LayoutMode.desktopFits(MediaQuery.sizeOf(context).width);
        if (constraints.maxWidth < tableMinWidth && !desktopMode) {
          return _MobileList<T>(
            rows: rows,
            itemBuilder: mobileItemBuilder,
            onRowTap: onRowTap,
            rowKey: rowKey,
          );
        }

        final visible = visibleColumnsFor(columns, constraints.maxWidth);
        final requiredWidth = visible.fold<double>(
          0,
          (sum, column) => sum + column.requiredWidth,
        );
        final tableWidth = requiredWidth > constraints.maxWidth
            ? requiredWidth
            : constraints.maxWidth;
        final table = _Table<T>(
          rows: rows,
          columns: visible,
          widths: columnWidthsFor(visible, tableWidth),
          onRowTap: onRowTap,
          rowKey: rowKey,
        );

        if (requiredWidth <= constraints.maxWidth) return table;
        return _HorizontalScroll(width: requiredWidth, child: table);
      },
    );
  }
}

class _HorizontalScroll extends StatefulWidget {
  const _HorizontalScroll({required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  State<_HorizontalScroll> createState() => _HorizontalScrollState();
}

class _HorizontalScrollState extends State<_HorizontalScroll> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _controller,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        child: SizedBox(width: widget.width, child: widget.child),
      ),
    );
  }
}

class _Table<T> extends StatelessWidget {
  const _Table({
    required this.rows,
    required this.columns,
    required this.widths,
    required this.onRowTap,
    required this.rowKey,
  });

  final List<T> rows;
  final List<AppDataColumn<T>> columns;
  final List<double> widths;
  final ValueChanged<T>? onRowTap;
  final Object Function(T row)? rowKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TableHeader(columns: columns, widths: widths),
        for (final row in rows)
          _TableRow<T>(
            key: rowKey == null ? null : ValueKey(rowKey!(row)),
            row: row,
            columns: columns,
            widths: widths,
            onTap: onRowTap == null ? null : () => onRowTap!(row),
          ),
      ],
    );
  }
}

/// A cell of exactly [width] (from [ResponsiveDataView.columnWidthsFor]).
Widget _sized<T>(AppDataColumn<T> column, double width, Widget child) =>
    SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
        child: Align(alignment: column.alignment, child: child),
      ),
    );

class _TableHeader<T> extends StatelessWidget {
  const _TableHeader({required this.columns, required this.widths});

  final List<AppDataColumn<T>> columns;
  final List<double> widths;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
      decoration: const BoxDecoration(
        color: AppColors.surfaceSubtle,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < columns.length; i++)
            _sized(
              columns[i],
              widths[i],
              Semantics(
                header: true,
                child: Text(
                  columns[i].label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.tableHeader,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TableRow<T> extends StatelessWidget {
  const _TableRow({
    required this.row,
    required this.columns,
    required this.widths,
    required this.onTap,
    super.key,
  });

  final T row;
  final List<AppDataColumn<T>> columns;
  final List<double> widths;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: InkWell(
        onTap: onTap,
        hoverColor: AppColors.surfaceHover,
        splashColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(minHeight: AppSizes.tableRowHeight),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s10),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.divider)),
          ),
          child: Row(
            children: [
              for (var i = 0; i < columns.length; i++)
                _sized(
                  columns[i],
                  widths[i],
                  columns[i].cellBuilder(context, row),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileList<T> extends StatelessWidget {
  const _MobileList({
    required this.rows,
    required this.itemBuilder,
    required this.onRowTap,
    required this.rowKey,
  });

  final List<T> rows;
  final Widget Function(BuildContext context, T row) itemBuilder;
  final ValueChanged<T>? onRowTap;
  final Object Function(T row)? rowKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final row in rows)
          Material(
            key: rowKey == null ? null : ValueKey(rowKey!(row)),
            color: AppColors.surface,
            child: InkWell(
              onTap: onRowTap == null ? null : () => onRowTap!(row),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.s16),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.divider)),
                ),
                child: itemBuilder(context, row),
              ),
            ),
          ),
      ],
    );
  }
}
