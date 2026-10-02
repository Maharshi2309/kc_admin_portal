import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kc_admin_portal/features/auth/data/models/user_model.dart';

part 'login_response_model.freezed.dart';
part 'login_response_model.g.dart';

/// Response of `POST /auth/login`.
///
/// TODO — REQUIREMENT CONFIRMATION REQUIRED: shape assumed as
/// `{ "accessToken": "...", "user": { ... } }`. Refresh tokens are not
/// handled until the backend confirms whether it issues them.
@freezed
abstract class LoginResponseModel with _$LoginResponseModel {
  const factory LoginResponseModel({
    required String accessToken,
    required UserModel user,
  }) = _LoginResponseModel;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);
}
