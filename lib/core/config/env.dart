import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppEnvironment { dev, prod }

/// Build-time configuration, injected with
/// `--dart-define-from-file=env/<name>.json` (templates: `env/*.example.json`).
///
/// This is the only place that reads `--dart-define` values; everything else
/// gets configuration through [envProvider].
class Env {
  const Env({
    required this.environment,
    required this.apiBaseUrl,
    required this.apiTimeout,
    this.useMockApi = false,
  });

  factory Env.fromEnvironment() {
    const appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
    const apiBaseUrl = String.fromEnvironment('API_BASE_URL');
    const timeoutSeconds = int.fromEnvironment(
      'API_TIMEOUT_SECONDS',
      defaultValue: 30,
    );
    const useMockApi = bool.fromEnvironment('USE_MOCK_API');
    return Env.parse(
      appEnv: appEnv,
      apiBaseUrl: apiBaseUrl,
      timeoutSeconds: timeoutSeconds,
      useMockApi: useMockApi,
    );
  }

  /// Validates raw configuration values. Throws a [StateError] explaining
  /// what to fix, which `main` shows on screen.
  factory Env.parse({
    required String appEnv,
    required String apiBaseUrl,
    required int timeoutSeconds,
    required bool useMockApi,
  }) {
    final environment = AppEnvironment.values.asNameMap()[appEnv];
    if (environment == null) {
      throw StateError(
        'APP_ENV "$appEnv" is invalid. '
        'Expected one of: ${AppEnvironment.values.map((e) => e.name).join(', ')}.',
      );
    }

    final uri = Uri.tryParse(apiBaseUrl);
    if (apiBaseUrl.isEmpty || uri == null || !uri.hasScheme) {
      throw StateError(
        'API_BASE_URL is missing or invalid. Run with '
        '--dart-define-from-file=env/dev.json (copy env/dev.example.json first).',
      );
    }

    if (timeoutSeconds <= 0) {
      throw StateError(
        'API_TIMEOUT_SECONDS must be a positive number of seconds.',
      );
    }

    if (environment == AppEnvironment.prod && uri.scheme != 'https') {
      throw StateError('API_BASE_URL must use https in a production build.');
    }

    if (useMockApi && environment == AppEnvironment.prod) {
      throw StateError(
        'USE_MOCK_API must not be enabled in a production build.',
      );
    }

    return Env(
      environment: environment,
      apiBaseUrl: apiBaseUrl,
      apiTimeout: Duration(seconds: timeoutSeconds),
      useMockApi: useMockApi,
    );
  }

  final AppEnvironment environment;
  final String apiBaseUrl;
  final Duration apiTimeout;

  /// DEV ONLY: use in-app fake data sources instead of the REST API, until
  /// the backend is available. Rejected for production builds.
  final bool useMockApi;

  bool get isProduction => environment == AppEnvironment.prod;
}

/// Overridden in `main()` with [Env.fromEnvironment]; tests override it with a fixed value.
final envProvider = Provider<Env>(
  (ref) => throw UnimplementedError(
    'envProvider must be overridden in ProviderScope.',
  ),
);
