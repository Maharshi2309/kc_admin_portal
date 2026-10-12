import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/network/session_events.dart';
import 'package:kc_admin_portal/core/storage/local_storage.dart';

/// Adds the bearer token to every request and reports expired sessions.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.tokenStorage, required this.sessionEvents});

  final TokenStorage tokenStorage;
  final SessionEvents sessionEvents;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenStorage.readToken();
    if (token != null && token.isNotEmpty) {
      options.headers[ApiConstants.authorizationHeader] =
          '${ApiConstants.bearerPrefix}$token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final isUnauthorized = err.response?.statusCode == 401;
    final isAuthenticatedCall = !ApiConstants.unauthenticatedPaths.contains(
      err.requestOptions.path,
    );
    if (isUnauthorized && isAuthenticatedCall) {
      sessionEvents.notifyExpired(_messageOf(err.response?.data));
    }
    if (err.response?.statusCode == 403) sessionEvents.notifyForbidden();
    handler.next(err);
  }

  static String? _messageOf(Object? body) {
    if (body is! Map) return null;
    for (final key in ApiConstants.errorMessageKeys) {
      final message = body[key];
      if (message is String && message.trim().isNotEmpty) return message;
    }
    return null;
  }
}

/// Development-only request log: method, path, status and duration.
/// Bodies and headers are never logged, so tokens and passwords cannot leak.
class DevLogInterceptor extends Interceptor {
  static const String _startKey = 'dev_log_started_at';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startKey] = DateTime.now();
    debugPrint('[API] → ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _log(response.requestOptions, response.statusCode);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log(err.requestOptions, err.response?.statusCode, error: err.type.name);
    // Failure details, to tell a blocked call (CORS, DNS, offline: no
    // response at all) from one the server answered. Error bodies hold only
    // server messages, never tokens or passwords; request bodies are not logged.
    debugPrint('[API]   type: ${err.type.name}');
    if (err.message != null) debugPrint('[API]   message: ${err.message}');
    if (err.error != null) debugPrint('[API]   cause: ${err.error}');
    if (err.response == null) {
      debugPrint(
        '[API]   no response from ${err.requestOptions.uri}. In Chrome this '
        'is usually CORS or an unreachable host: open DevTools > Console and '
        'Network for the browser\'s own reason.',
      );
    } else {
      final body = '${err.response?.data}';
      debugPrint(
        '[API]   response: ${body.length > 300 ? body.substring(0, 300) : body}',
      );
    }
    handler.next(err);
  }

  void _log(RequestOptions options, int? status, {String? error}) {
    final started = options.extra[_startKey];
    final elapsed = started is DateTime
        ? '${DateTime.now().difference(started).inMilliseconds}ms'
        : '';
    debugPrint(
      '[API] ← ${options.method} ${options.uri} '
      '${status ?? error ?? '?'} $elapsed',
    );
  }
}
