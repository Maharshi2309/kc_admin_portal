import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/shell/account_widgets.dart';
import 'package:kc_admin_portal/app/shell/app_header.dart';
import 'package:kc_admin_portal/app/shell/app_sidebar.dart';
import 'package:kc_admin_portal/app/shell/nav_destinations.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/responsive/responsive_utils.dart';
import 'package:kc_admin_portal/features/auth/data/models/user_model.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/auth_controller.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/permission_providers.dart';
import 'package:kc_admin_portal/shared/widgets/brand_mark.dart';

/// Navigation labels grow with the system font size only this far, so the
/// short labels never break mid-word; page content scales fully. The bottom
/// bar's slots are the narrowest, so its labels keep their size, as on iOS
/// tab bars.
const double _navMaxTextScale = 1.2;
const double _bottomBarMaxTextScale = 1;

/// The one app frame around every signed-in screen. It adapts to the window
/// width:
///
/// - desktop: sidebar + header + content (as in the design)
/// - tablet: navigation rail + header + content
/// - phone: top bar + content + bottom navigation bar
///
/// [navigationShell] is go_router's indexed stack, so each section keeps its
/// own state (scroll position, filters) when switching sections.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  final _searchFocusNode = FocusNode(debugLabel: 'header search');

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  int get _currentBranch => widget.navigationShell.currentIndex;

  /// Only the sections the user's role may open are shown; [branches] maps
  /// their positions back to the shell's branch indexes.
  void _onDestinationSelected(List<int> branches, int position) {
    final branch = branches[position];
    // Tapping the current section again returns to its first page.
    widget.navigationShell.goBranch(
      branch,
      initialLocation: branch == _currentBranch,
    );
  }

  void _onSearchSubmitted(String text) {
    final query = text.trim();
    context.goNamed(
      AppRouteNames.employees,
      queryParameters: {if (query.isNotEmpty) AppRouteParams.search: query},
    );
  }

  void _signOut() => ref.read(authControllerProvider.notifier).signOut();

  Widget? _accountMenu(UserModel? user) =>
      user == null ? null : AccountMenuButton(user: user, onSignOut: _signOut);

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    // The shell is only reachable when signed in (see route_guards.dart).
    final user = ref.watch(authControllerProvider).value;
    final grants = ref.watch(grantsProvider);
    final branches = visibleBranches(grants);
    final destinations = [for (final b in branches) appNavDestinations[b]];
    final selected = branches.indexOf(_currentBranch);
    void onSelected(int position) => _onDestinationSelected(branches, position);
    final canSearch = grants.contains(AppPermission.employeeView);
    final Widget frame;

    // The rail and the bottom bar need two sections or more; with fewer, the
    // phone frame (account in the top bar) is used without a bottom bar.
    if (size.isMobile || (!size.isDesktop && destinations.length < 2)) {
      frame = _MobileFrame(
        destinations: destinations,
        selectedIndex: selected,
        onSelected: onSelected,
        body: widget.navigationShell,
        account: _accountMenu(user),
      );
    } else {
      final navigation = size.isDesktop
          ? AppSidebar(
              destinations: destinations,
              selectedIndex: selected,
              onSelected: onSelected,
              footer: user == null
                  ? null
                  : SidebarUserCard(user: user, onSignOut: _signOut),
            )
          : _TabletRail(
              destinations: destinations,
              selectedIndex: selected,
              onSelected: onSelected,
              account: _accountMenu(user),
            );
      frame = Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Keeps the navigation's items together when tabbing.
            FocusTraversalGroup(child: navigation),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SafeArea(
                    bottom: false,
                    left: false,
                    child: AppHeader(
                      searchFocusNode: _searchFocusNode,
                      onSearchSubmitted: canSearch ? _onSearchSubmitted : null,
                    ),
                  ),
                  Expanded(child: widget.navigationShell),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // "/" focuses the header search, as hinted in the design. Text fields
    // consume "/" themselves, so typing a slash is unaffected.
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.slash): () {
          if (canSearch) _searchFocusNode.requestFocus();
        },
      },
      // Holds focus so the "/" shortcut works, but is not a Tab stop.
      child: Focus(autofocus: true, skipTraversal: true, child: frame),
    );
  }
}

class _TabletRail extends StatelessWidget {
  const _TabletRail({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
    required this.account,
  });

  final List<AppNavDestination> destinations;

  /// -1 when the current page is not a shown section.
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Widget? account;

  /// Below this height the rail scrolls.
  static const double _scrollBelowHeight = 600;

  @override
  Widget build(BuildContext context) {
    final short = MediaQuery.sizeOf(context).height < _scrollBelowHeight;
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: MediaQuery.withClampedTextScaling(
        maxScaleFactor: _navMaxTextScale,
        child: NavigationRail(
          selectedIndex: selectedIndex < 0 ? null : selectedIndex,
          onDestinationSelected: onSelected,
          labelType: NavigationRailLabelType.all,
          // Short screens (landscape phones) can't fit every section: the
          // rail scrolls, and the account sits right after the sections.
          scrollable: short,
          leading: const BrandMark(showName: false),
          trailing: account == null
              ? null
              : short
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s16),
                  child: account,
                )
              : Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                      child: account,
                    ),
                  ),
                ),
          destinations: [
            for (final destination in destinations)
              NavigationRailDestination(
                icon: Icon(destination.icon),
                selectedIcon: Icon(destination.selectedIcon),
                label: Text(destination.label),
              ),
          ],
        ),
      ),
    );
  }
}

class _MobileFrame extends StatelessWidget {
  const _MobileFrame({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
    required this.body,
    required this.account,
  });

  final List<AppNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Widget body;
  final Widget? account;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BrandMark(),
        actions: [
          if (account != null)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.s8),
              child: account,
            ),
        ],
      ),
      body: body,
      bottomNavigationBar: destinations.length < 2
          ? null
          : MediaQuery.withClampedTextScaling(
              maxScaleFactor: _bottomBarMaxTextScale,
              child: _BottomBar(
                destinations: destinations,
                selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
                onSelected: onSelected,
              ),
            ),
    );
  }
}

/// The phone bottom bar. Up to [_maxItems] sections fit; with more, the bar
/// shows the first ones and a "More" item that lists the rest in a sheet.
class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<AppNavDestination> destinations;

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const int _maxItems = 5;

  Future<void> _openMore(BuildContext context, int firstHidden) async {
    final chosen = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = firstHidden; i < destinations.length; i++)
              ListTile(
                leading: Icon(
                  i == selectedIndex
                      ? destinations[i].selectedIcon
                      : destinations[i].icon,
                ),
                title: Text(
                  destinations[i].label,
                  style: AppTextStyles.bodySemibold,
                ),
                iconColor: AppColors.textMuted,
                textColor: AppColors.textPrimary,
                selectedColor: AppColors.primary,
                selected: i == selectedIndex,
                onTap: () => Navigator.of(context).pop(i),
              ),
            const SizedBox(height: AppSpacing.s8),
          ],
        ),
      ),
    );
    if (chosen != null) onSelected(chosen);
  }

  @override
  Widget build(BuildContext context) {
    final overflow = destinations.length > _maxItems;
    final shown = overflow
        ? destinations.take(_maxItems - 1).toList()
        : destinations;
    final moreSelected = overflow && selectedIndex >= shown.length;
    return NavigationBar(
      selectedIndex: moreSelected ? shown.length : selectedIndex,
      onDestinationSelected: (index) => index < shown.length
          ? onSelected(index)
          : _openMore(context, shown.length),
      destinations: [
        for (final destination in shown)
          NavigationDestination(
            icon: Icon(destination.icon),
            selectedIcon: Icon(destination.selectedIcon),
            label: destination.label,
          ),
        if (overflow)
          const NavigationDestination(
            icon: Icon(Icons.more_horiz_rounded),
            label: 'More',
          ),
      ],
    );
  }
}
