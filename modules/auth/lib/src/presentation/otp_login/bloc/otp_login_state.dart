import 'package:auth/src/domain/entities/user_entity.dart';
import 'package:core/core.dart';

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
  const new({required this.auth});

  final UserEntity auth;

  @override
  List<Object?> get props => [auth];
}

final class OtpLoginFailureState extends OtpLoginState {
  const new({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
