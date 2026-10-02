import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/responsive/app_breakpoints.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_dropdown.dart';
import 'package:kc_admin_portal/core/widgets/app_filter_dropdown.dart';
import 'package:kc_admin_portal/core/widgets/app_icon_button.dart';

/// Table footer: "Showing 1–10 of 124", rows per page, and page buttons
/// (1 2 3 … 13). Below tablet width it collapses to "Page 1 of 13" with
/// previous/next buttons.
class AppPagination extends StatelessWidget {
  const AppPagination({
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.onPageChanged,
    this.onPageSizeChanged,
    this.pageSizeOptions = const [10, 25, 50],
    super.key,
  });

  /// 1-based current page.
  final int page;
  final int pageSize;
  final int totalItems;
  final ValueChanged<int> onPageChanged;

  /// Hides the rows-per-page picker when null.
  final ValueChanged<int>? onPageSizeChanged;
  final List<int> pageSizeOptions;

  int get totalPages => math.max(1, (totalItems / pageSize).ceil());

  /// Page numbers to show, with `null` for an ellipsis:
  /// first, last, and the current page with one neighbour on each side.
  static List<int?> visiblePages(int current, int total) {
    if (total <= 7) return [for (var i = 1; i <= total; i++) i];

    final pages = <int>{1, total};
    for (var i = current - 1; i <= current + 1; i++) {
      if (i > 1 && i < total) pages.add(i);
    }
    // Near an edge, show enough pages that the ellipsis replaces 2+ pages.
    if (current <= 3) pages.addAll([2, 3, 4]);
    if (current >= total - 2) pages.addAll([total - 3, total - 2, total - 1]);

    final sorted = pages.toList()..sort();
    final result = <int?>[];
    for (final p in sorted) {
      if (result.isNotEmpty && p - result.last! > 1) result.add(null);
      result.add(p);
    }
    return result;
  }

  Widget _arrow({required bool previous}) {
    final canMove = previous ? page > 1 : page < totalPages;
    return AppIconButton(
      icon: previous ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
      tooltip: previous ? 'Previous page' : 'Next page',
      bordered: true,
      onPressed: canMove
          ? () => onPageChanged(previous ? page - 1 : page + 1)
          : null,
    );
  }

  String get _rangeText {
    if (totalItems == 0) return 'No results';
    final first = (page - 1) * pageSize + 1;
    final last = math.min(page * pageSize, totalItems);
    return '$first–$last of $totalItems';
  }

  @override
  Widget build(BuildContext context) {
    final muted = AppTextStyles.small.copyWith(color: AppColors.textMuted);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < AppBreakpoints.tablet;

        const padding = EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s12,
        );

        if (compact) {
          // Phones: ‹  Page 2 of 13 / 11–20 of 124  ›
          return Padding(
            padding: padding,
            child: Row(
              children: [
                _arrow(previous: true),
                Expanded(
                  child: Column(
                    spacing: AppSpacing.s2,
                    children: [
                      Text(
                        'Page $page of $totalPages',
                        style: AppTextStyles.smallSemibold,
                      ),
                      Text(_rangeText, style: muted),
                    ],
                  ),
                ),
                _arrow(previous: false),
              ],
            ),
          );
        }

        // Wider screens: controls move to a second line when they don't fit
        // next to the range text (touch devices use 48 px tap targets).
        return Padding(
          padding: padding,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.s12,
            runSpacing: AppSpacing.s8,
            children: [
              Text('Showing $_rangeText', style: muted),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: AppSpacing.s12,
                children: [
                  if (onPageSizeChanged != null)
                    AppFilterDropdown<int>(
                      label: 'Rows',
                      allLabel: null,
                      value: pageSize,
                      onChanged: (size) {
                        if (size != null) onPageSizeChanged!(size);
                      },
                      items: [
                        for (final size in pageSizeOptions)
                          AppDropdownItem(value: size, label: '$size'),
                      ],
                    ),
                  _PageNumbers(
                    page: page,
                    totalPages: totalPages,
                    onPageChanged: onPageChanged,
                    previous: _arrow(previous: true),
                    next: _arrow(previous: false),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PageNumbers extends StatelessWidget {
  const _PageNumbers({
    required this.page,
    required this.totalPages,
    required this.onPageChanged,
    required this.previous,
    required this.next,
  });

  final int page;
  final int totalPages;
  final ValueChanged<int> onPageChanged;
  final Widget previous;
  final Widget next;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s4,
      children: [
        previous,
        for (final p in AppPagination.visiblePages(page, totalPages))
          p == null
              ? const _Ellipsis()
              : _PageNumber(
                  number: p,
                  isCurrent: p == page,
                  onTap: () => onPageChanged(p),
                ),
        next,
      ],
    );
  }
}

class _PageNumber extends StatelessWidget {
  const _PageNumber({
    required this.number,
    required this.isCurrent,
    required this.onTap,
  });

  final int number;
  final bool isCurrent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Page $number',
      selected: isCurrent,
      button: true,
      excludeSemantics: true,
      child: TextButton(
        onPressed: isCurrent ? null : onTap,
        style: ButtonStyle(
          fixedSize: const WidgetStatePropertyAll(
            Size.square(AppSizes.iconButtonGhost),
          ),
          minimumSize: const WidgetStatePropertyAll(
            Size.square(AppSizes.iconButtonGhost),
          ),
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppRadius.smAll),
          ),
          textStyle: WidgetStatePropertyAll(
            AppTextStyles.smallSemibold.copyWith(
              fontWeight: isCurrent ? AppTextStyles.bold : null,
            ),
          ),
          backgroundColor: WidgetStatePropertyAll(
            isCurrent ? AppColors.inverse : Colors.transparent,
          ),
          foregroundColor: WidgetStatePropertyAll(
            isCurrent ? AppColors.onPrimary : AppColors.textSecondary,
          ),
          overlayColor: const WidgetStatePropertyAll(AppColors.neutralBg),
        ),
        child: Text('$number'),
      ),
    );
  }
}

class _Ellipsis extends StatelessWidget {
  const _Ellipsis();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.s24,
      child: Text(
        '…',
        textAlign: TextAlign.center,
        style: AppTextStyles.small.copyWith(color: AppColors.textMuted),
      ),
    );
  }
}

/// Footer for lists that grow with "Load more" (attendance in the design).
class LoadMoreFooter extends StatelessWidget {
  const LoadMoreFooter({
    required this.shownCount,
    required this.totalCount,
    required this.onLoadMore,
    this.isLoading = false,
    super.key,
  });

  final int shownCount;
  final int totalCount;
  final VoidCallback onLoadMore;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final hasMore = shownCount < totalCount;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Showing $shownCount of $totalCount',
              style: AppTextStyles.small.copyWith(color: AppColors.textMuted),
            ),
          ),
          if (hasMore)
            AppButton(
              label: 'Load more',
              variant: AppButtonVariant.secondary,
              size: AppButtonSize.small,
              isLoading: isLoading,
              onPressed: onLoadMore,
            ),
        ],
      ),
    );
  }
}
