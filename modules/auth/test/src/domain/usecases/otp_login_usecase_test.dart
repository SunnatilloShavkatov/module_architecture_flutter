import 'package:auth/src/domain/entities/user_entity.dart';
import 'package:auth/src/domain/repos/auth_repo.dart';
import 'package:auth/src/domain/usecases/otp_login.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late OtpLogin useCase;
  late _MockAuthRepo mockRepo;

  const tParams = OtpLoginParams(code: '123456');
  const tUser = UserEntity(id: 2, email: 'otp@test.com', firstName: 'Otp', lastName: 'User', role: 'CLIENT');
  const tServerFailure = ServerFailure(message: 'Invalid OTP code');
  const tNoInternetFailure = NoInternetFailure(message: 'No internet');

  setUp(() {
    mockRepo = _MockAuthRepo();
    useCase = OtpLogin(mockRepo);
  });

  // ─── Success ─────────────────────────────────────────────────────────────────
  test('returns UserEntity from repo on success', () async {
    when(() => mockRepo.otpLogin(code: any(named: 'code')))
        .thenAnswer((_) async => const Right(tUser));

    final result = await useCase(tParams);

    expect(result, const Right<Failure, UserEntity>(tUser));
    verify(() => mockRepo.otpLogin(code: tParams.code)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  // ─── Server failure ───────────────────────────────────────────────────────────
  test('returns ServerFailure from repo on server error', () async {
    when(() => mockRepo.otpLogin(code: any(named: 'code')))
        .thenAnswer((_) async => const Left(tServerFailure));

    final result = await useCase(tParams);

    expect(result, const Left<Failure, UserEntity>(tServerFailure));
    verify(() => mockRepo.otpLogin(code: tParams.code)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  // ─── No internet failure ──────────────────────────────────────────────────────
  test('returns NoInternetFailure from repo on network error', () async {
    when(() => mockRepo.otpLogin(code: any(named: 'code')))
        .thenAnswer((_) async => const Left(tNoInternetFailure));

    final result = await useCase(tParams);

    expect(result, isA<Left<Failure, UserEntity>>());
    final failure = (result as Left<Failure, UserEntity>).value;
    expect(failure, isA<NoInternetFailure>());
  });

  // ─── Correct code forwarded ───────────────────────────────────────────────────
  test('calls repo with exact code from params', () async {
    const specificParams = OtpLoginParams(code: '654321');
    when(() => mockRepo.otpLogin(code: any(named: 'code')))
        .thenAnswer((_) async => const Right(tUser));

    await useCase(specificParams);

    verify(() => mockRepo.otpLogin(code: '654321')).called(1);
  });

  // ─── Calls repo only once ─────────────────────────────────────────────────────
  test('calls repo exactly once', () async {
    when(() => mockRepo.otpLogin(code: any(named: 'code')))
        .thenAnswer((_) async => const Right(tUser));

    await useCase(tParams);

    verify(() => mockRepo.otpLogin(code: any(named: 'code'))).called(1);
  });
}
