import 'package:core/core.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();
}

final class LoginSubmitEvent extends LoginEvent {
  const LoginSubmitEvent({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
