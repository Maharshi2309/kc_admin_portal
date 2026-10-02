/// Every failure the data layer reports to the rest of the app.
///
/// [message] is always safe to show to users; raw exceptions and stack traces
/// never reach the UI.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// No connection, DNS failure, server unreachable.
final class NetworkException extends AppException {
  const NetworkException([
    super.message =
        'Cannot reach the server. Check your internet connection and try again.',
  ]);
}

final class RequestTimeoutException extends AppException {
  const RequestTimeoutException([
    super.message = 'The server took too long to respond. Please try again.',
  ]);
}

/// 401: missing, invalid or expired credentials.
final class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'Your session has expired. Please sign in again.',
  ]);
}

/// 403: signed in but not allowed.
final class ForbiddenException extends AppException {
  const ForbiddenException([
    super.message = 'You do not have permission to do this.',
    this.code,
  ]);

  /// Machine-readable reason from the API, e.g. `PERMISSION_DENIED`.
  final String? code;
}

/// 404.
final class NotFoundException extends AppException {
  const NotFoundException([
    super.message = 'The requested record was not found.',
  ]);
}

/// 400 / 409 / 422: the request was rejected. [fieldErrors] maps form field
/// names to messages so forms can show them next to the right input.
final class ValidationException extends AppException {
  const ValidationException(
    super.message, {
    this.fieldErrors = const {},
    this.code,
  });

  final Map<String, String> fieldErrors;

  /// Machine-readable reason from the API, e.g. `LEAVE_NOT_EDITABLE`, for
  /// the few cases the app reacts to differently. [message] is still what
  /// the user sees.
  final String? code;
}

/// 5xx.
final class ServerException extends AppException {
  const ServerException({
    this.statusCode,
    String message =
        'Something went wrong on the server. Please try again later.',
  }) : super(message);

  final int? statusCode;
}

/// Anything else, including responses the app cannot read.
final class UnknownException extends AppException {
  const UnknownException([
    super.message = 'Something went wrong. Please try again.',
  ]);
}
