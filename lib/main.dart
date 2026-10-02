import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'package:kc_admin_portal/app/app.dart';
import 'package:kc_admin_portal/app/startup_error_app.dart';
import 'package:kc_admin_portal/core/config/env.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Web: clean URLs (/employees) instead of hash URLs (/#/employees).
  // No effect on Android/iOS.
  usePathUrlStrategy();

  final Env env;
  try {
    env = Env.fromEnvironment();
  } on StateError catch (error) {
    // Show the problem on screen instead of failing before the first frame
    // (which leaves a blank black window).
    debugPrint('Startup failed: ${error.message}');
    runApp(StartupErrorApp(message: error.message));
    return;
  }

  runApp(
    ProviderScope(
      overrides: [envProvider.overrideWithValue(env)],
      child: const KeshavAdminApp(),
    ),
  );
}
