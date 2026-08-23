import 'package:core/core.dart';

sealed class OtpLoginEvent extends Equatable {
  const new();
}

final class OtpLoginSubmitEvent extends OtpLoginEvent {
  const new({required this.code});

  final String code;

  @override
  List<Object?> get props => [code];
}
