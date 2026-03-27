import 'package:auth/src/domain/entities/user_entity.dart';
import 'package:auth/src/domain/usecases/login.dart';
import 'package:auth/src/presentation/login/bloc/login_bloc.dart';
import 'package:auth/src/presentation/login/bloc/login_event.dart';
import 'package:auth/src/presentation/login/bloc/login_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLogin extends Mock implements Login {}

void main() {
  late LoginBloc loginBloc;
  late _MockLogin mockLogin;

  const tUser = UserEntity(id: 1, email: 'test@test.com', firstName: 'Test', lastName: 'User', role: 'CLIENT');
  const tFailure = ServerFailure(message: 'Invalid credentials');

  setUp(() {
    mockLogin = _MockLogin();
    loginBloc = LoginBloc(mockLogin);
    registerFallbackValue(const LoginParams(email: '', password: ''));
  });

  tearDown(() => loginBloc.close());

  test('initial state is LoginInitialState', () {
    expect(loginBloc.state, const LoginInitialState());
  });

  blocTest<LoginBloc, LoginState>(
    'emits [LoginLoading, LoginSuccess] on successful login',
    build: () {
      when(() => mockLogin(any())).thenAnswer((_) async => const Right(tUser));
      return loginBloc;
    },
    act: (bloc) => bloc.add(const LoginSubmitEvent(email: 'test@test.com', password: 'password')),
    expect: () => [const LoginLoading(), const LoginSuccess(auth: tUser)],
    verify: (_) {
      verify(() => mockLogin(any())).called(1);
    },
  );

  blocTest<LoginBloc, LoginState>(
    'emits [LoginLoading, LoginFailure] on failed login',
    build: () {
      when(() => mockLogin(any())).thenAnswer((_) async => const Left(tFailure));
      return loginBloc;
    },
    act: (bloc) => bloc.add(const LoginSubmitEvent(email: 'test@test.com', password: 'wrong')),
    expect: () => [const LoginLoading(), const LoginFailure(message: 'Invalid credentials')],
  );

  blocTest<LoginBloc, LoginState>(
    'does not emit new state if already loading',
    build: () {
      when(() => mockLogin(any())).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        return const Right(tUser);
      });
      return loginBloc;
    },
    act: (bloc) {
      bloc
        ..add(const LoginSubmitEvent(email: 'a@b.com', password: 'p'))
        ..add(const LoginSubmitEvent(email: 'a@b.com', password: 'p'));
    },
    // Only one LoginLoading emitted, not two
    verify: (_) => verify(() => mockLogin(any())).called(1),
  );
}
