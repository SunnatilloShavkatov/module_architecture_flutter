import 'package:auth/src/domain/entities/login_entity.dart';
import 'package:core/core.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  const LoginSuccess({required this.auth});

  final LoginEntity auth;

  @override
  List<Object?> get props => [auth];
}

final class LoginFailure extends LoginState {
  const LoginFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
