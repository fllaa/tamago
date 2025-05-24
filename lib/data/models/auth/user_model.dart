import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_boilerplate/domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String name;
  
  @JsonKey(name: 'profile_image')
  final String? profileImage;
  
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  
  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.profileImage,
    this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) => 
      _$UserModelFromJson(json);
      
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  
  // Convert to domain entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      profileImage: profileImage,
      phoneNumber: phoneNumber,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
  
  // Create from domain entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      profileImage: user.profileImage,
      phoneNumber: user.phoneNumber,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }
}