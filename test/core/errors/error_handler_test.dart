import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/errors/error_handler.dart';

DioException _dio(DioExceptionType type, {int? status, Object? body}) {
  final options = RequestOptions(path: '/x');
  return DioException(
    requestOptions: options,
    type: type,
    response: status == null
        ? null
        : Response<Object?>(
            requestOptions: options,
            statusCode: status,
            data: body,
          ),
  );
}

void main() {
  test('timeouts and connection problems', () {
    expect(
      ErrorHandler.fromDio(_dio(DioExceptionType.receiveTimeout)),
      isA<RequestTimeoutException>(),
    );
    expect(
      ErrorHandler.fromDio(_dio(DioExceptionType.connectionError)),
      isA<NetworkException>(),
    );
  });

  test('validation errors keep the server message and field errors', () {
    final error = ErrorHandler.fromDio(
      _dio(
        DioExceptionType.badResponse,
        status: 422,
        body: {
          'message': 'EC number already exists',
          'errors': {
            'ecNumber': ['Must be unique'],
            'email': 'Invalid email',
          },
        },
      ),
    );

    expect(error, isA<ValidationException>());
    expect(error.message, 'EC number already exists');
    expect((error as ValidationException).fieldErrors, {
      'ecNumber': 'Must be unique',
      'email': 'Invalid email',
    });
  });

  test('status codes map to their exception types', () {
    expect(ErrorHandler.fromResponse(401, null), isA<UnauthorizedException>());
    expect(ErrorHandler.fromResponse(403, null), isA<ForbiddenException>());
    expect(ErrorHandler.fromResponse(404, null), isA<NotFoundException>());
    expect(ErrorHandler.fromResponse(503, null), isA<ServerException>());
  });

  test('server errors never show the raw server message', () {
    final error = ErrorHandler.fromResponse(500, {
      'message': 'TypeError: cannot read property x of undefined',
    });
    expect(error.message, isNot(contains('TypeError')));
  });

  test('messageFor never exposes raw exceptions', () {
    expect(
      ErrorHandler.messageFor(StateError('internal detail')),
      isNot(contains('internal detail')),
    );
    expect(
      ErrorHandler.messageFor(const NotFoundException('Employee not found')),
      'Employee not found',
    );
  });
}
