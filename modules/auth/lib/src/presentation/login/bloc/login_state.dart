import 'package:auth/src/domain/entities/user_entity.dart';
import 'package:core/core.dart';

sealed class LoginState extends Equatable {
  const new();
}

final class LoginInitialState extends LoginState {
  const new();

  @override
  List<Object?> get props => [];
}

final class LoginLoadingState extends LoginState {
  const new();

  @override
  List<Object?> get props => [];
}

final class LoginSuccessState extends LoginState {
  const new({required this.auth});

  final UserEntity auth;

  @override
  List<Object?> get props => [auth];
}

final class LoginFailureState extends LoginState {
  const new({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
