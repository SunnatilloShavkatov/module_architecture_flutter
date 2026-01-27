import 'package:auth/src/domain/entities/auth_entity.dart';

final class AuthModel extends AuthEntity {
  const AuthModel({required super.id, required super.token, required super.username});

  factory AuthModel.fromMap(Map<String, dynamic> map) =>
      AuthModel(id: map['id'] as String, token: map['token'] as String, username: map['username'] as String);

  Map<String, dynamic> toMap() => {'id': id, 'token': token, 'username': username};
}
