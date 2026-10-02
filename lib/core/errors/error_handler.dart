import 'package:dio/dio.dart';

import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';

/// Converts low-level errors into [AppException]s and user-facing text.
abstract final class ErrorHandler {
  /// Maps a dio failure to the matching [AppException].
  static AppException fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const RequestTimeoutException();
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
        return const NetworkException();
      case DioExceptionType.badResponse:
        return fromResponse(error.response?.statusCode, error.response?.data);
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return const UnknownException();
    }
  }

  /// Maps an HTTP error status and body to an [AppException]. Server
  /// messages are used for 4xx responses (they describe the user's request);
  /// 5xx responses always get a generic message.
  static AppException fromResponse(int? statusCode, Object? body) {
    final serverMessage = _messageFrom(body);

    return switch (statusCode) {
      400 || 409 || 422 => ValidationException(
        serverMessage ?? 'Please check the entered details and try again.',
        fieldErrors: _fieldErrorsFrom(body),
        code: _codeFrom(body),
      ),
      401 =>
        serverMessage == null
            ? const UnauthorizedException()
            : UnauthorizedException(serverMessage),
      403 => ForbiddenException(
        serverMessage ?? const ForbiddenException().message,
        _codeFrom(body),
      ),
      404 =>
        serverMessage == null
            ? const NotFoundException()
            : NotFoundException(serverMessage),
      final int code when code >= 500 => ServerException(statusCode: code),
      _ => const UnknownException(),
    };
  }

  /// User-facing text for any error caught in the UI or providers.
  static String messageFor(Object error) =>
      error is AppException ? error.message : const UnknownException().message;

  static String? _codeFrom(Object? body) {
    if (body is! Map) return null;
    final code = body[ApiConstants.errorCodeKey];
    return code is String && code.isNotEmpty ? code : null;
  }

  static String? _messageFrom(Object? body) {
    if (body is! Map) return null;
    for (final key in ApiConstants.errorMessageKeys) {
      final value = body[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return null;
  }

  static Map<String, String> _fieldErrorsFrom(Object? body) {
    if (body is! Map) return const {};
    final errors = body[ApiConstants.fieldErrorsKey];
    if (errors is! Map) return const {};

    final result = <String, String>{};
    for (final MapEntry(:key, :value) in errors.entries) {
      final message = switch (value) {
        final String text => text,
        final List<Object?> list when list.isNotEmpty => list.first.toString(),
        _ => null,
      };
      if (message != null) result[key.toString()] = message;
    }
    return result;
  }
}
