import 'package:core/core.dart';

sealed class OtpLoginEvent extends Equatable {
  const OtpLoginEvent();
}

final class OtpLoginSubmitEvent extends OtpLoginEvent {
  const OtpLoginSubmitEvent({required this.code});

  final String code;

  @override
  List<Object?> get props => [code];
}
