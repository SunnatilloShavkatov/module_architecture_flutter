import 'package:auth/src/domain/entities/login_entity.dart';

class LoginModel extends LoginEntity {
  const LoginModel({super.token, super.expireAt, super.profile, super.uuid, super.level});

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    final Map<String, dynamic> result = map['result'] ?? {};
    return LoginModel(
      level: result['level'],
      token: result['token'],
      uuid: result['user_uuid'],
      expireAt: result['expire_at'],
      profile: result['profile'] is Map ? ProfileModel.fromMap(result['profile']) : null,
    );
  }
}

class ProfileModel extends ProfileEntity {
  const ProfileModel({super.userId, super.username, super.firstname, super.lastname});

  factory ProfileModel.fromMap(Map<String, dynamic> map) => ProfileModel(
    userId: map['user_id'],
    username: map['username'],
    lastname: map['lastname'],
    firstname: map['firstname'],
  );
}
