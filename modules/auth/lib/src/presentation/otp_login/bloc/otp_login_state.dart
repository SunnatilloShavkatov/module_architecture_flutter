part of 'otp_login_bloc.dart';

sealed class OtpLoginState extends Equatable {
  const new();
}

final class OtpLoginInitialState extends OtpLoginState {
  const new();

  @override
  List<Object?> get props => [];
}

final class OtpLoginLoadingState extends OtpLoginState {
  const new();

  @override
  List<Object?> get props => [];
}

final class OtpLoginSuccessState extends OtpLoginState {
  const new({required this.user});

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

final class OtpLoginFailureState extends OtpLoginState {
  const new({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
