part of 'login_bloc.dart';

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
  const new({required this.user});

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

final class LoginFailureState extends LoginState {
  const new({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
