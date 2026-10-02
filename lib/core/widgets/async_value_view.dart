import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/widgets/app_error_view.dart';
import 'package:kc_admin_portal/core/widgets/app_loader.dart';

/// Renders an [AsyncValue] with the standard loading, error and empty states,
/// so every API-backed screen handles all four the same way.
///
/// While refreshing, the previous data stays on screen instead of flashing a
/// spinner.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    required this.value,
    required this.data,
    this.onRetry,
    this.isEmpty,
    this.empty,
    this.loadingMessage,
    this.compact = false,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;

  /// Retry action for the error state (usually `ref.invalidate(provider)`).
  final VoidCallback? onRetry;

  /// When it returns true for the loaded data, [empty] is shown instead.
  final bool Function(T data)? isEmpty;
  final Widget? empty;
  final String? loadingMessage;

  /// Smaller loader and error view for use inside cards.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: (result) {
        if (empty != null && (isEmpty?.call(result) ?? false)) return empty!;
        return data(result);
      },
      loading: () => AppLoader(message: loadingMessage, small: compact),
      error: (error, _) => AppErrorView(
        message: ErrorHandler.messageFor(error),
        onRetry: onRetry,
        compact: compact,
      ),
    );
  }
}
