import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/auth_controller.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/organization_providers.dart';
import 'package:kc_admin_portal/features/users/data/models/user_account_models.dart';
import 'package:kc_admin_portal/features/users/data/repositories/user_repository_impl.dart';

/// Search and page of the users list. Kept while the app runs, so
/// returning to Access control restores it.
class UserQueryNotifier extends Notifier<UserQuery> {
  static const Duration searchDebounce = Duration(milliseconds: 350);

  Timer? _searchTimer;

  @override
  UserQuery build() {
    ref.onDispose(() => _searchTimer?.cancel());
    // Another organization starts with fresh filters.
    ref.watch(activeOrganizationIdProvider);
    return const UserQuery();
  }

  /// Applies typed search text after a short pause.
  void setSearch(String text) {
    _searchTimer?.cancel();
    _searchTimer = Timer(searchDebounce, () => applySearch(text));
  }

  void applySearch(String text) {
    _searchTimer?.cancel();
    final search = text.trim();
    if (search == state.search) return;
    state = state.copyWith(search: search, page: 1);
  }

  void setPage(int page) => state = state.copyWith(page: page);

  void setPageSize(int pageSize) =>
      state = state.copyWith(pageSize: pageSize, page: 1);

  void clearFilters() {
    _searchTimer?.cancel();
    state = UserQuery(pageSize: state.pageSize);
  }
}

final userQueryProvider = NotifierProvider<UserQueryNotifier, UserQuery>(
  UserQueryNotifier.new,
);

/// The current page of users for [userQueryProvider].
final userListProvider = FutureProvider<UserAccountListModel>(
  (ref) => ref.watch(userRepositoryProvider).list(ref.watch(userQueryProvider)),
  retry: (_, _) => null,
);

final userDetailProvider = FutureProvider.autoDispose
    .family<UserAccountModel, String>(
      (ref, id) => ref.watch(userRepositoryProvider).getById(id),
      retry: (_, _) => null,
    );

/// Adds or edits a user. State: idle, saving or failed (field errors on the
/// form).
class UserFormController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Returns the saved user, or null when saving failed.
  Future<UserAccountModel?> create(UserAccountInput input) =>
      _run(() => ref.read(userRepositoryProvider).create(input));

  Future<UserAccountModel?> edit(String id, UserAccountUpdate input) =>
      _run(() => ref.read(userRepositoryProvider).update(id, input));

  Future<UserAccountModel?> _run(
    Future<UserAccountModel> Function() action,
  ) async {
    state = const AsyncLoading();
    try {
      final saved = await action();
      refreshAfterUserChange(ref);
      if (ref.mounted) state = const AsyncData(null);
      return saved;
    } on Object catch (error, stack) {
      if (ref.mounted) state = AsyncError(error, stack);
      return null;
    }
  }
}

final userFormControllerProvider =
    AsyncNotifierProvider.autoDispose<UserFormController, void>(
      UserFormController.new,
      retry: (_, _) => null,
    );

/// Deactivates and reactivates users from the list. State: the user ids
/// with an action running.
class UserActions extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {};

  /// Returns null on success, otherwise a user-facing message.
  Future<String?> setActive(
    UserAccountModel user, {
    required bool active,
  }) async {
    if (state.contains(user.id)) return null;
    state = {...state, user.id};
    try {
      await ref
          .read(userRepositoryProvider)
          .update(
            user.id,
            UserAccountUpdate(
              name: user.name,
              email: user.email,
              employeeId: user.employee?.id,
              isActive: active,
            ),
          );
      refreshAfterUserChange(ref);
      return null;
    } on Object catch (error) {
      return ErrorHandler.messageFor(error);
    } finally {
      state = {...state}..remove(user.id);
    }
  }
}

final userActionsProvider = NotifierProvider<UserActions, Set<String>>(
  UserActions.new,
);

/// Saves a user's permissions. State: idle, saving or failed.
class UserPermissionsController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Returns null on success, otherwise a user-facing message (e.g. the
  /// change would leave nobody able to manage users and permissions).
  Future<String?> save(String userId, Set<String> keys) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(userRepositoryProvider)
          .setPermissions(userId, keys.toList());
      refreshAfterUserChange(ref);
      if (ref.mounted) state = const AsyncData(null);
      return null;
    } on Object catch (error, stack) {
      if (ref.mounted) state = AsyncError(error, stack);
      return ErrorHandler.messageFor(error);
    }
  }
}

final userPermissionsControllerProvider =
    AsyncNotifierProvider.autoDispose<UserPermissionsController, void>(
      UserPermissionsController.new,
      retry: (_, _) => null,
    );

void refreshAfterUserChange(Ref ref) {
  ref
    ..invalidate(userListProvider)
    ..invalidate(userDetailProvider);
  unawaited(ref.read(authControllerProvider.notifier).refresh());
}
