import 'package:base_dependencies/base_dependencies.dart';

class LoginEntity extends Equatable {
  const LoginEntity({
    required this.uuid,
    required this.token,
    required this.level,
    required this.profile,
    required this.expireAt,
  });

  final String? uuid;
  final String? token;
  final String? level;
  final String? expireAt;
  final ProfileEntity? profile;

  @override
  List<Object?> get props => [uuid, token, expireAt, profile];
}

class ProfileEntity extends Equatable {
  const ProfileEntity({this.userId, this.username, this.firstname, this.lastname});

  final int? userId;
  final String? username;
  final String? firstname;
  final String? lastname;

  @override
  List<Object?> get props => [userId, username, firstname, lastname];
}
