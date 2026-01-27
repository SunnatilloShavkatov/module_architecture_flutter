import 'package:core/core.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();
}

final class LoginSubmitted extends LoginEvent {
  const LoginSubmitted({required this.deviceType, required this.identity, required this.password, this.fcmToken});

  final int deviceType;
  final String identity;
  final String password;
  final String? fcmToken;

  @override
  List<Object?> get props => [deviceType, identity, password, fcmToken];
}
