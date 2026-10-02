import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_empty_view.dart';
import 'package:kc_admin_portal/core/widgets/app_page.dart';
import 'package:kc_admin_portal/core/widgets/app_pagination.dart';
import 'package:kc_admin_portal/core/widgets/app_search_field.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/features/users/data/models/user_account_models.dart';
import 'package:kc_admin_portal/features/users/presentation/providers/user_providers.dart';
import 'package:kc_admin_portal/features/users/presentation/widgets/users_table.dart';

/// Access control: the staff who can sign in, and what each one may do.
/// Each user has their own permissions; there are no roles. The server
/// checks every action.
class AccessControlScreen extends ConsumerStatefulWidget {
  const AccessControlScreen({super.key});

  @override
  ConsumerState<AccessControlScreen> createState() =>
      _AccessControlScreenState();
}

class _AccessControlScreenState extends ConsumerState<AccessControlScreen> {
  static const double _searchMaxWidth = 300;
  static const double _progressLineHeight = 2;

  late final _search = TextEditingController(
    text: ref.read(userQueryProvider).search,
  );

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _search.clear();
    ref.read(userQueryProvider.notifier).clearFilters();
  }

  void _add() => context.goNamed(AppRouteNames.userAdd);

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(userListProvider);
    final query = ref.watch(userQueryProvider);
    final notifier = ref.read(userQueryProvider.notifier);

    return AppPageBody(
      children: [
        AppPageHeader(
          title: 'Access control',
          subtitle:
              'Who can sign in, and what each person can do. Open a user to '
              'choose their permissions.',
          actions: [
            AppButton(
              label: 'Add user',
              icon: Icons.person_add_alt_rounded,
              onPressed: _add,
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
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: _searchMaxWidth,
                    ),
                    child: AppSearchField(
                      hintText: 'Name or email',
                      compact: true,
                      controller: _search,
                      onChanged: notifier.setSearch,
                      onSubmitted: notifier.applySearch,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: _progressLineHeight,
                child: users.isLoading && users.hasValue
                    ? const LinearProgressIndicator()
                    : const Divider(height: 1, color: AppColors.border),
              ),
              AsyncValueView<UserAccountListModel>(
                value: users,
                onRetry: () => ref.invalidate(userListProvider),
                isEmpty: (page) => page.items.isEmpty,
                empty: query.hasFilters
                    ? AppEmptyView(
                        icon: Icons.search_off_rounded,
                        title: 'No users match "${query.search}"',
                        action: AppButton(
                          label: 'Clear search',
                          variant: AppButtonVariant.secondary,
                          onPressed: _clearSearch,
                        ),
                      )
                    : AppEmptyView(
                        icon: Icons.person_outline_rounded,
                        title: 'No users yet',
                        action: AppButton(
                          label: 'Add user',
                          icon: Icons.person_add_alt_rounded,
                          onPressed: _add,
                        ),
                      ),
                data: (page) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    UsersTable(users: page.items),
                    AppPagination(
                      page: page.page,
                      pageSize: page.pageSize,
                      totalItems: page.total,
                      onPageChanged: notifier.setPage,
                      onPageSizeChanged: notifier.setPageSize,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
