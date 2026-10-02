import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/network/api_interceptor.dart';
import 'package:kc_admin_portal/core/network/session_events.dart';
import 'package:kc_admin_portal/core/storage/local_storage.dart';

/// Turns decoded JSON into a typed value, e.g. `UserModel.fromJson`.
typedef JsonParser<T> = T Function(Object? json);

/// The only class that talks HTTP. Remote data sources call these methods
/// (updates use PATCH; only company holidays are ever deleted)
/// and get typed results back, or an [AppException] — never a dio error.
class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Future<T> get<T>(
    String path, {
    required JsonParser<T> parse,
    Map<String, Object?>? query,
  }) => _send(() => _dio.get<Object?>(path, queryParameters: query), parse);

  Future<T> post<T>(
    String path, {
    required JsonParser<T> parse,
    Object? body,
    Map<String, Object?>? query,
  }) => _send(
    () => _dio.post<Object?>(path, data: body, queryParameters: query),
    parse,
  );

  Future<T> patch<T>(
    String path, {
    required JsonParser<T> parse,
    Object? body,
  }) => _send(() => _dio.patch<Object?>(path, data: body), parse);

  /// `PUT`: replaces a whole resource, e.g. a role's permissions.
  Future<T> put<T>(String path, {required JsonParser<T> parse, Object? body}) =>
      _send(() => _dio.put<Object?>(path, data: body), parse);

  /// `DELETE`. Used only where records are really removed (company
  /// holidays); employees, leave and attendance are never deleted.
  Future<T> delete<T>(String path, {required JsonParser<T> parse}) =>
      _send(() => _dio.delete<Object?>(path), parse);

  /// Parser for endpoints whose response body is not needed.
  static void ignoreBody(Object? _) {}

  Future<T> _send<T>(
    Future<Response<Object?>> Function() request,
    JsonParser<T> parse,
  ) async {
    final Response<Object?> response;
    try {
      response = await request();
    } on DioException catch (error) {
      throw ErrorHandler.fromDio(error);
    }

    try {
      return parse(response.data);
    } on AppException {
      rethrow;
    } on Object {
      // The body did not have the expected shape (wrong type, missing key).
      throw const UnknownException(
        'The server sent an unexpected response. Please try again.',
      );
    }
  }
}

/// The configured HTTP client: base URL and timeouts from [env], JSON in and
/// out, the bearer token on every request, and (outside production) a
/// request log that never includes bodies or headers.
Dio createDio({
  required Env env,
  required TokenStorage tokenStorage,
  required SessionEvents sessionEvents,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: env.apiBaseUrl,
      connectTimeout: env.apiTimeout,
      sendTimeout: env.apiTimeout,
      receiveTimeout: env.apiTimeout,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      headers: const {Headers.acceptHeader: Headers.jsonContentType},
    ),
  );
  dio.interceptors.addAll([
    AuthInterceptor(tokenStorage: tokenStorage, sessionEvents: sessionEvents),
    if (!env.isProduction) DevLogInterceptor(),
  ]);
  return dio;
}

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = createDio(
    env: ref.watch(envProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
    sessionEvents: ref.watch(sessionEventsProvider),
  );
  ref.onDispose(dio.close);
  return ApiClient(dio);
});
