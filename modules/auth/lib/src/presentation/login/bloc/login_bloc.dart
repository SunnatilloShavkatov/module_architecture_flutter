import 'package:auth/src/domain/entities/user_entity.dart';
import 'package:auth/src/domain/usecases/login.dart';
import 'package:core/core.dart';

part 'login_event.dart';
part 'login_state.dart';

final class LoginBloc extends Bloc<LoginEvent, LoginState> {
  new(this._login) : super(const LoginInitialState()) {
    on<LoginSubmitEvent>(_loginHandler, transformer: throttle());
  }

  final Login _login;

  Future<void> _loginHandler(LoginSubmitEvent event, Emitter<LoginState> emit) async {
    if (state is LoginLoadingState) {
      return;
    }
    emit(const LoginLoadingState());
    final result = await _login(LoginParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(LoginFailureState(message: failure.message)),
      (user) => emit(LoginSuccessState(user: user)),
    );
  }
}
