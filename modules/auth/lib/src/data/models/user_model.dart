import 'package:auth/src/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.role,
    super.phone,
    super.token,
    super.username,
    super.specialization,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map['userId'] ?? map['id'] ?? 0,
    email: map['email'] ?? '',
    firstName: map['firstName'] ?? '',
    lastName: map['lastName'] ?? '',
    role: map['role'] ?? 'CLIENT',
    phone: map['phone'],
    token: map['token'],
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
    'token': token,
    'username': username,
    'specialization': specialization,
  };
}
