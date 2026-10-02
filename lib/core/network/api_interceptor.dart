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
    handler.next(err);
  }

  void _log(RequestOptions options, int? status, {String? error}) {
    final started = options.extra[_startKey];
    final elapsed = started is DateTime
        ? '${DateTime.now().difference(started).inMilliseconds}ms'
        : '';
    debugPrint(
      '[API] ${options.method} ${options.path} → '
      '${status ?? error ?? '?'} $elapsed',
    );
  }
}
