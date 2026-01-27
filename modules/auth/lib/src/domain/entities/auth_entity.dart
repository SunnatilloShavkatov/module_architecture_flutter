import 'package:core/core.dart';

base class AuthEntity extends Equatable {
  const AuthEntity({required this.id, required this.token, required this.username});

  final String id;
  final String token;
  final String username;

  @override
  List<Object?> get props => [id, token, username];
}
