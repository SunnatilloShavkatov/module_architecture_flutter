import 'package:auth/src/domain/entities/user_entity.dart';
import 'package:auth/src/domain/repos/auth_repo.dart';
import 'package:auth/src/domain/usecases/otp_login.dart';
import 'package:auth/src/presentation/otp_login/bloc/otp_login_bloc.dart';
import 'package:auth/src/presentation/otp_login/bloc/otp_login_event.dart';
import 'package:auth/src/presentation/otp_login/bloc/otp_login_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// OtpLogin is final class — mock the AuthRepo and use a real OtpLogin
class _MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late OtpLoginBloc otpLoginBloc;
  late OtpLogin otpLogin;
  late _MockAuthRepo mockAuthRepo;

  const tUser = UserEntity(id: 2, email: 'otp@test.com', firstName: 'Otp', lastName: 'User', role: 'CLIENT');
  const tServerFailure = ServerFailure(message: 'Invalid OTP code');
  const tNoInternetFailure = NoInternetFailure(message: 'No internet connection');

  setUp(() {
    mockAuthRepo = _MockAuthRepo();
    otpLogin = OtpLogin(mockAuthRepo);
    otpLoginBloc = OtpLoginBloc(otpLogin);
  });

  tearDown(() => otpLoginBloc.close());

  // ─── Initial state ────────────────────────────────────────────────────────────
  test('initial state is OtpLoginInitialState', () {
    expect(otpLoginBloc.state, const OtpLoginInitialState());
  });

  // ─── Success ─────────────────────────────────────────────────────────────────
  blocTest<OtpLoginBloc, OtpLoginState>(
    'emits [OtpLoginLoading, OtpLoginSuccess] on successful OTP login',
    build: () {
      when(() => mockAuthRepo.otpLogin(code: any(named: 'code')))
          .thenAnswer((_) async => const Right(tUser));
      return otpLoginBloc;
    },
    act: (bloc) => bloc.add(const OtpLoginSubmitEvent(code: '123456')),
    expect: () => [const OtpLoginLoading(), const OtpLoginSuccess(auth: tUser)],
    verify: (_) => verify(() => mockAuthRepo.otpLogin(code: '123456')).called(1),
  );

  // ─── Server failure ───────────────────────────────────────────────────────────
  blocTest<OtpLoginBloc, OtpLoginState>(
    'emits [OtpLoginLoading, OtpLoginFailure] on server failure',
    build: () {
      when(() => mockAuthRepo.otpLogin(code: any(named: 'code')))
          .thenAnswer((_) async => const Left(tServerFailure));
      return otpLoginBloc;
    },
    act: (bloc) => bloc.add(const OtpLoginSubmitEvent(code: '000000')),
    expect: () => [const OtpLoginLoading(), const OtpLoginFailure(message: 'Invalid OTP code')],
    verify: (_) => verify(() => mockAuthRepo.otpLogin(code: any(named: 'code'))).called(1),
  );

  // ─── No internet failure ──────────────────────────────────────────────────────
  blocTest<OtpLoginBloc, OtpLoginState>(
    'emits [OtpLoginLoading, OtpLoginFailure] on no internet failure',
    build: () {
      when(() => mockAuthRepo.otpLogin(code: any(named: 'code')))
          .thenAnswer((_) async => const Left(tNoInternetFailure));
      return otpLoginBloc;
    },
    act: (bloc) => bloc.add(const OtpLoginSubmitEvent(code: '123456')),
    expect: () => [const OtpLoginLoading(), const OtpLoginFailure(message: 'No internet connection')],
  );

  // ─── Duplicate event while loading ───────────────────────────────────────────
  blocTest<OtpLoginBloc, OtpLoginState>(
    'does not process second submit while already loading',
    build: () {
      when(() => mockAuthRepo.otpLogin(code: any(named: 'code'))).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        return const Right(tUser);
      });
      return otpLoginBloc;
    },
    act: (bloc) {
      bloc
        ..add(const OtpLoginSubmitEvent(code: '123456'))
        ..add(const OtpLoginSubmitEvent(code: '123456'));
    },
    wait: const Duration(milliseconds: 300),
    expect: () => [const OtpLoginLoading(), const OtpLoginSuccess(auth: tUser)],
    verify: (_) => verify(() => mockAuthRepo.otpLogin(code: any(named: 'code'))).called(1),
  );

  // ─── Can submit again after failure ──────────────────────────────────────────
  blocTest<OtpLoginBloc, OtpLoginState>(
    'can submit again after a previous failure',
    build: () {
      when(() => mockAuthRepo.otpLogin(code: any(named: 'code')))
          .thenAnswer((_) async => const Right(tUser));
      return otpLoginBloc;
    },
    seed: () => const OtpLoginFailure(message: 'Previous error'),
    act: (bloc) => bloc.add(const OtpLoginSubmitEvent(code: '654321')),
    expect: () => [const OtpLoginLoading(), const OtpLoginSuccess(auth: tUser)],
  );

  // ─── OtpLoginSuccess carries correct user ─────────────────────────────────────
  blocTest<OtpLoginBloc, OtpLoginState>(
    'OtpLoginSuccess contains the user returned from usecase',
    build: () {
      const specificUser = UserEntity(
        id: 42,
        email: 'specific@test.com',
        firstName: 'Specific',
        lastName: 'User',
        role: 'STAFF',
      );
      when(() => mockAuthRepo.otpLogin(code: any(named: 'code')))
          .thenAnswer((_) async => const Right(specificUser));
      return otpLoginBloc;
    },
    act: (bloc) => bloc.add(const OtpLoginSubmitEvent(code: '999999')),
    expect: () => [
      const OtpLoginLoading(),
      const OtpLoginSuccess(
        auth: UserEntity(id: 42, email: 'specific@test.com', firstName: 'Specific', lastName: 'User', role: 'STAFF'),
      ),
    ],
  );

  // ─── Correct code forwarded to repo ──────────────────────────────────────────
  blocTest<OtpLoginBloc, OtpLoginState>(
    'passes exact OTP code to AuthRepo',
    build: () {
      when(() => mockAuthRepo.otpLogin(code: any(named: 'code')))
          .thenAnswer((_) async => const Right(tUser));
      return otpLoginBloc;
    },
    act: (bloc) => bloc.add(const OtpLoginSubmitEvent(code: '789012')),
    verify: (_) => verify(() => mockAuthRepo.otpLogin(code: '789012')).called(1),
  );
}
