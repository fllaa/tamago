import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? profileImage;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const User({
    required this.id,
    required this.email,
    required this.name,
    this.profileImage,
    this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });
  
  @override
  List<Object?> get props => [
    id,
    email,
    name,
    profileImage,
    phoneNumber,
    createdAt,
    updatedAt,
  ];
}