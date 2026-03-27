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
  const tServerFailure = ServerFailure(message: 'Invalid credentials');
  const tNoInternetFailure = NoInternetFailure(message: 'No internet connection');

  setUp(() {
    mockLogin = _MockLogin();
    loginBloc = LoginBloc(mockLogin);
    registerFallbackValue(const LoginParams(email: '', password: ''));
  });

  tearDown(() => loginBloc.close());

  // ─── Initial state ────────────────────────────────────────────────────────────
  test('initial state is LoginInitialState', () {
    expect(loginBloc.state, const LoginInitialState());
  });

  // ─── Success ─────────────────────────────────────────────────────────────────
  blocTest<LoginBloc, LoginState>(
    'emits [LoginLoading, LoginSuccess] on successful login',
    build: () {
      when(() => mockLogin(any())).thenAnswer((_) async => const Right(tUser));
      return loginBloc;
    },
    act: (bloc) => bloc.add(const LoginSubmitEvent(email: 'test@test.com', password: 'password')),
    expect: () => [const LoginLoading(), const LoginSuccess(auth: tUser)],
    verify: (_) => verify(() => mockLogin(any())).called(1),
  );

  // ─── Server failure ───────────────────────────────────────────────────────────
  blocTest<LoginBloc, LoginState>(
    'emits [LoginLoading, LoginFailure] on server failure',
    build: () {
      when(() => mockLogin(any())).thenAnswer((_) async => const Left(tServerFailure));
      return loginBloc;
    },
    act: (bloc) => bloc.add(const LoginSubmitEvent(email: 'test@test.com', password: 'wrong')),
    expect: () => [const LoginLoading(), const LoginFailure(message: 'Invalid credentials')],
    verify: (_) => verify(() => mockLogin(any())).called(1),
  );

  // ─── No internet failure ──────────────────────────────────────────────────────
  blocTest<LoginBloc, LoginState>(
    'emits [LoginLoading, LoginFailure] on no internet failure',
    build: () {
      when(() => mockLogin(any())).thenAnswer((_) async => const Left(tNoInternetFailure));
      return loginBloc;
    },
    act: (bloc) => bloc.add(const LoginSubmitEvent(email: 'test@test.com', password: 'password')),
    expect: () => [const LoginLoading(), const LoginFailure(message: 'No internet connection')],
  );

  // ─── Duplicate event while loading ───────────────────────────────────────────
  blocTest<LoginBloc, LoginState>(
    'does not process second submit while already loading',
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
    wait: const Duration(milliseconds: 300),
    expect: () => [const LoginLoading(), const LoginSuccess(auth: tUser)],
    verify: (_) => verify(() => mockLogin(any())).called(1),
  );

  // ─── Can submit again after failure ──────────────────────────────────────────
  blocTest<LoginBloc, LoginState>(
    'can submit again after a previous failure',
    build: () {
      when(() => mockLogin(any())).thenAnswer((_) async => const Right(tUser));
      return loginBloc;
    },
    seed: () => const LoginFailure(message: 'Previous error'),
    act: (bloc) => bloc.add(const LoginSubmitEvent(email: 'test@test.com', password: 'password')),
    expect: () => [const LoginLoading(), const LoginSuccess(auth: tUser)],
  );

  // ─── LoginSuccess contains correct user data ──────────────────────────────────
  blocTest<LoginBloc, LoginState>(
    'LoginSuccess contains the user returned from usecase',
    build: () {
      const richUser = UserEntity(
        id: 99,
        email: 'admin@company.com',
        firstName: 'Admin',
        lastName: 'Boss',
        role: 'ADMIN',
        phone: '+998901234567',
      );
      when(() => mockLogin(any())).thenAnswer((_) async => const Right(richUser));
      return loginBloc;
    },
    act: (bloc) => bloc.add(const LoginSubmitEvent(email: 'admin@company.com', password: 'secret')),
    expect: () => [
      const LoginLoading(),
      const LoginSuccess(
        auth: UserEntity(
          id: 99,
          email: 'admin@company.com',
          firstName: 'Admin',
          lastName: 'Boss',
          role: 'ADMIN',
          phone: '+998901234567',
        ),
      ),
    ],
  );
}
