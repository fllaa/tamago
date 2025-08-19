import 'package:json_annotation/json_annotation.dart';
import 'package:tamago/data/models/auth/user_model.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final String token;

  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  @JsonKey(name: 'expires_in')
  final int expiresIn;

  final UserModel user;

  LoginResponse({
    required this.token,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
