import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/core/config/env.dart';

Env _parse({
  String appEnv = 'dev',
  String apiBaseUrl = 'http://localhost:3000/api',
  int timeoutSeconds = 30,
  bool useMockApi = false,
}) => Env.parse(
  appEnv: appEnv,
  apiBaseUrl: apiBaseUrl,
  timeoutSeconds: timeoutSeconds,
  useMockApi: useMockApi,
);

Matcher _startupError(String containing) => throwsA(
  isA<StateError>().having((e) => e.message, 'message', contains(containing)),
);

void main() {
  test('a valid dev config', () {
    final env = _parse(useMockApi: true);
    expect(env.environment, AppEnvironment.dev);
    expect(env.apiBaseUrl, 'http://localhost:3000/api');
    expect(env.apiTimeout, const Duration(seconds: 30));
    expect(env.useMockApi, isTrue);
    expect(env.isProduction, isFalse);
  });

  test('a valid production config', () {
    final env = _parse(appEnv: 'prod', apiBaseUrl: 'https://api.keshav.in');
    expect(env.isProduction, isTrue);
  });

  test('an unknown APP_ENV is rejected', () {
    expect(() => _parse(appEnv: 'staging'), _startupError('APP_ENV'));
  });

  test('a missing or relative API_BASE_URL is rejected', () {
    expect(() => _parse(apiBaseUrl: ''), _startupError('API_BASE_URL'));
    expect(() => _parse(apiBaseUrl: '/api'), _startupError('API_BASE_URL'));
  });

  test('a non-positive timeout is rejected', () {
    expect(
      () => _parse(timeoutSeconds: 0),
      _startupError('API_TIMEOUT_SECONDS'),
    );
  });

  test('production must use https', () {
    expect(
      () => _parse(appEnv: 'prod', apiBaseUrl: 'http://api.keshav.in'),
      _startupError('https'),
    );
  });

  test('production never uses the mock API', () {
    expect(
      () => _parse(
        appEnv: 'prod',
        apiBaseUrl: 'https://api.keshav.in',
        useMockApi: true,
      ),
      _startupError('USE_MOCK_API'),
    );
  });
}
