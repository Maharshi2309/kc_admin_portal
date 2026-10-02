import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_response.freezed.dart';
part 'paginated_response.g.dart';

/// One page of a list endpoint.
///
/// TODO — REQUIREMENT CONFIRMATION REQUIRED: page shape assumed as
/// `{ "items": [...], "total": 124, "page": 1, "pageSize": 10 }`
/// with 1-based pages.
@Freezed(genericArgumentFactories: true)
abstract class PaginatedResponse<T> with _$PaginatedResponse<T> {
  const factory PaginatedResponse({
    required List<T> items,
    required int total,
    required int page,
    required int pageSize,
  }) = _PaginatedResponse<T>;

  const PaginatedResponse._();

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$PaginatedResponseFromJson(json, fromJsonT);

  int get totalPages => math.max(1, (total / pageSize).ceil());
}
