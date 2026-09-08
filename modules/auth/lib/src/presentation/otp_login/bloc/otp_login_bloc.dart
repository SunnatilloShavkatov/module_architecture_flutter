import 'package:auth/src/domain/entities/user_entity.dart';
import 'package:auth/src/domain/usecases/otp_login.dart';
import 'package:core/core.dart';

part 'otp_login_event.dart';
part 'otp_login_state.dart';

final class OtpLoginBloc extends Bloc<OtpLoginEvent, OtpLoginState> {
  new(this._otpLogin) : super(const OtpLoginInitialState()) {
    on<OtpLoginSubmitEvent>(_otpLoginHandler, transformer: throttle());
  }

  final OtpLogin _otpLogin;

  Future<void> _otpLoginHandler(OtpLoginSubmitEvent event, Emitter<OtpLoginState> emit) async {
    if (state is OtpLoginLoadingState) {
      return;
    }
    emit(const OtpLoginLoadingState());
    final result = await _otpLogin(OtpLoginParams(code: event.code));
    result.fold(
      (failure) => emit(OtpLoginFailureState(message: failure.message)),
      (user) => emit(OtpLoginSuccessState(user: user)),
    );
  }
}
