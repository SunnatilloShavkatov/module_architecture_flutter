part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const new();
}

final class LoginSubmitEvent extends LoginEvent {
  const new({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
