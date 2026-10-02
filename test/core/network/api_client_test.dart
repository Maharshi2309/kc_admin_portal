import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/network/api_client.dart';
import 'package:kc_admin_portal/core/network/api_interceptor.dart';
import 'package:kc_admin_portal/core/network/session_events.dart';
import 'package:kc_admin_portal/core/storage/local_storage.dart';
import 'package:mocktail/mocktail.dart';

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

/// Answers every request with [status] and [body], recording the request.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.status, this.body);

  final int status;
  final Object? body;
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late _MockSecureStorage secureStorage;
  late SessionEvents sessionEvents;

  setUp(() {
    secureStorage = _MockSecureStorage();
    sessionEvents = SessionEvents();
    when(
      () => secureStorage.read(key: any(named: 'key')),
    ).thenAnswer((_) async => 'token-123');
  });

  tearDown(() => sessionEvents.dispose());

  (ApiClient, _FakeAdapter) buildClient(int status, Object? body) {
    final adapter = _FakeAdapter(status, body);
    final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
      ..httpClientAdapter = adapter
      ..interceptors.add(
        AuthInterceptor(
          tokenStorage: TokenStorage(secureStorage),
          sessionEvents: sessionEvents,
        ),
      );
    return (ApiClient(dio), adapter);
  }

  test('sends the bearer token and parses the response', () async {
    final (client, adapter) = buildClient(200, {'name': 'Aarav'});

    final name = await client.get(
      '/employees/1',
      parse: (json) => (json! as Map<String, dynamic>)['name'] as String,
    );

    expect(name, 'Aarav');
    expect(adapter.lastRequest!.headers['Authorization'], 'Bearer token-123');
  });

  test('maps HTTP errors to AppExceptions', () async {
    final (client, _) = buildClient(404, {'message': 'Employee not found'});

    await expectLater(
      client.get('/employees/9', parse: ApiClient.ignoreBody),
      throwsA(
        isA<NotFoundException>().having(
          (e) => e.message,
          'message',
          'Employee not found',
        ),
      ),
    );
  });

  test('an unexpected body shape becomes a friendly error', () async {
    final (client, _) = buildClient(200, ['not', 'a', 'map']);

    await expectLater(
      client.get(
        '/auth/me',
        parse: (json) => (json! as Map<String, dynamic>)['id'],
      ),
      throwsA(isA<UnknownException>()),
    );
  });

  test('401 on an authenticated request reports session expiry', () async {
    final (client, _) = buildClient(401, {'message': 'Token expired'});
    // With the server's reason, for the sign-in screen.
    final expired = expectLater(
      sessionEvents.onExpired,
      emits('Token expired'),
    );

    await expectLater(
      client.get('/employees', parse: ApiClient.ignoreBody),
      throwsA(isA<UnauthorizedException>()),
    );
    await expired;
  });

  test('401 from login is a wrong password, not session expiry', () async {
    final (client, _) = buildClient(401, {'message': 'Wrong password'});
    var expiredCount = 0;
    final subscription = sessionEvents.onExpired.listen((_) => expiredCount++);

    await expectLater(
      client.post('/auth/login', parse: ApiClient.ignoreBody),
      throwsA(isA<UnauthorizedException>()),
    );
    await Future<void>.delayed(Duration.zero);
    await subscription.cancel();
    expect(expiredCount, 0);
  });

  group('createDio', () {
    Dio build(Env env) => createDio(
      env: env,
      tokenStorage: TokenStorage(secureStorage),
      sessionEvents: sessionEvents,
    );

    test('uses the configured base URL and timeout, JSON both ways', () {
      final dio = build(
        const Env(
          environment: AppEnvironment.dev,
          apiBaseUrl: 'http://localhost:3000/api',
          apiTimeout: Duration(seconds: 12),
        ),
      );
      expect(dio.options.baseUrl, 'http://localhost:3000/api');
      expect(dio.options.connectTimeout, const Duration(seconds: 12));
      expect(dio.options.receiveTimeout, const Duration(seconds: 12));
      expect(dio.options.contentType, Headers.jsonContentType);
      expect(
        dio.options.headers[Headers.acceptHeader],
        Headers.jsonContentType,
      );
    });

    test('always adds the token; logs requests outside production only', () {
      List<Type> interceptors(AppEnvironment environment) => build(
        Env(
          environment: environment,
          apiBaseUrl: 'https://api.test',
          apiTimeout: const Duration(seconds: 30),
        ),
      ).interceptors.map((i) => i.runtimeType).toList();

      expect(interceptors(AppEnvironment.dev), contains(AuthInterceptor));
      expect(interceptors(AppEnvironment.dev), contains(DevLogInterceptor));
      expect(interceptors(AppEnvironment.prod), contains(AuthInterceptor));
      expect(
        interceptors(AppEnvironment.prod),
        isNot(contains(DevLogInterceptor)),
      );
    });

    test('the dev request log never prints tokens or bodies', () async {
      final logged = <String>[];
      final original = debugPrint;
      debugPrint = (message, {wrapWidth}) => logged.add(message ?? '');
      addTearDown(() => debugPrint = original);

      final adapter = _FakeAdapter(200, {'ok': true});
      final dio = build(
        const Env(
          environment: AppEnvironment.dev,
          apiBaseUrl: 'http://api.test',
          apiTimeout: Duration(seconds: 30),
        ),
      )..httpClientAdapter = adapter;
      await ApiClient(dio).post(
        '/auth/login',
        body: {'email': 'a@b.c', 'password': 'secret-password'},
        parse: ApiClient.ignoreBody,
      );

      expect(logged.single, contains('POST /auth/login'));
      expect(logged.single, contains('200'));
      expect(logged.join(), isNot(contains('secret-password')));
      expect(logged.join(), isNot(contains('token-123')));
    });
  });
}
