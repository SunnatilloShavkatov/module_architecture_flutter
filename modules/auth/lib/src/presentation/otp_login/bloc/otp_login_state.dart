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

final class OtpLoginLoading extends OtpLoginState {
  const OtpLoginLoading();

  @override
  List<Object?> get props => [];
}

final class OtpLoginSuccess extends OtpLoginState {
  const OtpLoginSuccess({required this.auth});

  final UserEntity auth;

  @override
  List<Object?> get props => [auth];
}

final class OtpLoginFailure extends OtpLoginState {
  const OtpLoginFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
