import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;
  
  @JsonKey(name: 'remember_me')
  final bool rememberMe;
  
  const LoginRequest({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });
  
  factory LoginRequest.fromJson(Map<String, dynamic> json) => 
      _$LoginRequestFromJson(json);
      
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}