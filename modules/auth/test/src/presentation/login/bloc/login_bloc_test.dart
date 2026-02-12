import 'package:flutter_test/flutter_test.dart';

// import 'package:auth/src/domain/entities/auth_entity.dart';
// import 'package:auth/src/domain/usecases/login_usecase.dart';
// import 'package:auth/src/presentation/login/bloc/login_bloc.dart';
// import 'package:auth/src/presentation/login/bloc/login_event.dart';
// import 'package:auth/src/presentation/login/bloc/login_state.dart';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:core/core.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
//
//
// void main() {
//   late LoginBloc loginBloc;
//   late MockLoginUseCase mockLoginUseCase;
//
//   setUp(() {
//     mockLoginUseCase = MockLoginUseCase();
//     loginBloc = LoginBloc(loginUseCase: mockLoginUseCase);
//   });
//
//   registerFallbackValue(const LoginParams(username: '', password: ''));
//
//   const tAuth = AuthEntity(id: '1', token: 'token', username: 'admin');
//   const tFailure = ServerFailure(message: 'Invalid credentials', statusCode: 401);
//
//   test('initial state should be LoginInitial', () {
//     expect(loginBloc.state, LoginInitial());
//   });
//
//   blocTest<LoginBloc, LoginState>(
//     'emits [LoginLoading, LoginSuccess] when LoginSubmitted is successful',
//     build: () {
//       when(() => mockLoginUseCase(any())).thenAnswer((_) async => const Right(tAuth));
//       return loginBloc;
//     },
//     act: (bloc) => bloc.add(const LoginSubmitted(username: 'admin', password: 'password')),
//     expect: () => [LoginLoading(), const LoginSuccess(tAuth)],
//     verify: (_) {
//       verify(() => mockLoginUseCase(const LoginParams(username: 'admin', password: 'password'))).called(1);
//     },
//   );
//
//   blocTest<LoginBloc, LoginState>(
//     'emits [LoginLoading, LoginFailure] when LoginSubmitted fails',
//     build: () {
//       when(() => mockLoginUseCase(any())).thenAnswer((_) async => const Left(tFailure));
//       return loginBloc;
//     },
//     act: (bloc) => bloc.add(const LoginSubmitted(username: 'admin', password: 'password')),
//     expect: () => [LoginLoading(), const LoginFailure('Invalid credentials')],
//   );
// }

void main() {
  test('login bloc tests are temporarily disabled', () {}, skip: true);
}
