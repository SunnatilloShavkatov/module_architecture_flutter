import 'package:auth/src/domain/entities/user_entity.dart';
import 'package:core/core.dart';

sealed class LoginState extends Equatable {
  const LoginState();
}

final class LoginInitialState extends LoginState {
  const LoginInitialState();

  @override
  List<Object?> get props => [];
}

final class LoginLoading extends LoginState {
  const LoginLoading();

  @override
  List<Object?> get props => [];
}

final class LoginSuccess extends LoginState {
  const LoginSuccess({required this.auth});

  final UserEntity auth;

  @override
  List<Object?> get props => [auth];
}

final class LoginFailure extends LoginState {
  const LoginFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
