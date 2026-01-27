import 'package:auth/src/domain/usecases/login_usecase.dart';
import 'package:auth/src/presentation/login/bloc/login_event.dart';
import 'package:auth/src/presentation/login/bloc/login_state.dart';
import 'package:core/core.dart';

final class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required LoginUseCase loginUseCase}) : _loginUseCase = loginUseCase, super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  final LoginUseCase _loginUseCase;

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    final result = await _loginUseCase(
      LoginParams(
        deviceType: event.deviceType,
        fcmToken: event.fcmToken,
        identity: event.identity,
        password: event.password,
      ),
    );
    result.fold((failure) => emit(LoginFailure(message: failure.message)), (auth) => emit(LoginSuccess(auth: auth)));
  }
}
