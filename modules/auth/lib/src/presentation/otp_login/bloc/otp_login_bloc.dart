import 'package:auth/src/domain/usecases/otp_login.dart';
import 'package:auth/src/presentation/otp_login/bloc/otp_login_event.dart';
import 'package:auth/src/presentation/otp_login/bloc/otp_login_state.dart';
import 'package:core/core.dart';

final class OtpLoginBloc extends Bloc<OtpLoginEvent, OtpLoginState> {
  OtpLoginBloc(this._otpLogin) : super(const OtpLoginInitialState()) {
    on<OtpLoginSubmitEvent>(_otpLoginHandler);
  }

  final OtpLogin _otpLogin;

  Future<void> _otpLoginHandler(OtpLoginSubmitEvent event, Emitter<OtpLoginState> emit) async {
    if (state is OtpLoginLoading) {
      return;
    }
    emit(const OtpLoginLoading());
    final result = await _otpLogin(OtpLoginParams(code: event.code));
    result.fold(
      (failure) => emit(OtpLoginFailure(message: failure.message)),
      (auth) => emit(OtpLoginSuccess(auth: auth)),
    );
  }
}
