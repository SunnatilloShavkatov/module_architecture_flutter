import 'package:profile/src/domain/entities/profile_user_entity.dart';

class ProfileUserModel extends ProfileUserEntity {
  const ProfileUserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.role,
    super.phone,
    super.username,
    super.specialization,
  });

  factory ProfileUserModel.fromMap(Map<String, dynamic> map) => ProfileUserModel(
    id: map['userId'] ?? map['id'] ?? 0,
    email: map['email'] ?? '',
    firstName: map['firstName'] ?? '',
    lastName: map['lastName'] ?? '',
    role: map['role'] ?? 'CLIENT',
    phone: map['phone'],
    username: map['username'],
    specialization: map['specialization'],
  );

  Map<String, dynamic> toMap() => {
    'userId': id,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'role': role,
    'phone': phone,
    'username': username,
    'specialization': specialization,
  };
}
