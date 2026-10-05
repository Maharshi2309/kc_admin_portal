import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/router/app_router.dart';
import 'package:kc_admin_portal/app/router/route_title.dart';
import 'package:kc_admin_portal/app/theme/app_theme.dart';
import 'package:kc_admin_portal/core/constants/app_constants.dart';
import 'package:kc_admin_portal/core/widgets/keyboard_focus_reveal.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/auth_controller.dart';

class KeshavAdminApp extends ConsumerStatefulWidget {
  const KeshavAdminApp({super.key});

  @override
  ConsumerState<KeshavAdminApp> createState() => _KeshavAdminAppState();
}

class _KeshavAdminAppState extends ConsumerState<KeshavAdminApp> {
  /// Back in the foreground: reload the signed-in user, since an admin may
  /// have changed their role's permissions meanwhile.
  late final AppLifecycleListener _lifecycle;

  final _messenger = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onResume: () =>
          unawaited(ref.read(authControllerProvider.notifier).refresh()),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    // Signed out (or the session ended): the previous user's messages, e.g.
    // "Permissions saved", must not stay on the sign-in screen, where they
    // would also cover the Sign in button on small screens.
    ref.listen(authControllerProvider, (previous, next) {
      if (previous?.value != null && next.hasValue && next.value == null) {
        _messenger.currentState?.clearSnackBars();
      }
    });
    return MaterialApp.router(
      scaffoldMessengerKey: _messenger,
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
      builder: (context, child) => RouteTitle(
        router: router,
        child: KeyboardFocusReveal(child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}
