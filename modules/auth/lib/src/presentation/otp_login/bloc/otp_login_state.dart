import 'package:auth/src/domain/entities/user_entity.dart';
import 'package:core/core.dart';

sealed class OtpLoginState extends Equatable {
  const OtpLoginState();
}

final class OtpLoginInitialState extends OtpLoginState {
  const OtpLoginInitialState();

  @override
  List<Object?> get props => [];
}

final class OtpLoginLoadingState extends OtpLoginState {
  const OtpLoginLoadingState();

  @override
  List<Object?> get props => [];
}

final class OtpLoginSuccessState extends OtpLoginState {
  const OtpLoginSuccessState({required this.auth});

  final UserEntity auth;

  @override
  List<Object?> get props => [auth];
}

final class OtpLoginFailureState extends OtpLoginState {
  const OtpLoginFailureState({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
