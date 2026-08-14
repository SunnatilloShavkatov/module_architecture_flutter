import 'package:auth/src/domain/entities/user_entity.dart';
import 'package:auth/src/domain/repos/auth_repo.dart';
import 'package:auth/src/domain/usecases/login.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late Login useCase;
  late _MockAuthRepo mockRepo;

  const tParams = LoginParams(email: 'admin@test.com', password: 'password');
  const tUser = UserEntity(id: 1, email: 'admin@test.com', firstName: 'Admin', lastName: 'User', role: 'CLIENT');
  const tServerFailure = ServerFailure(message: 'Login failed');
  const tNoInternetFailure = NoInternetFailure(message: 'No internet');
  const tCacheFailure = CacheFailure(message: 'Cache error');

  setUp(() {
    mockRepo = _MockAuthRepo();
    useCase = Login(mockRepo);
  });

  // ─── Success ─────────────────────────────────────────────────────────────────
  test('returns UserEntity from repo on success', () async {
    when(
      () => mockRepo.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Right(tUser));

    final result = await useCase(tParams);

    expect(result, const Right<Failure, UserEntity>(tUser));
    verify(() => mockRepo.login(email: tParams.email, password: tParams.password)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  // ─── Server failure ───────────────────────────────────────────────────────────
  test('returns ServerFailure from repo on server error', () async {
    when(
      () => mockRepo.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Left(tServerFailure));

    final result = await useCase(tParams);

    expect(result, const Left<Failure, UserEntity>(tServerFailure));
    verify(() => mockRepo.login(email: tParams.email, password: tParams.password)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  // ─── No internet failure ──────────────────────────────────────────────────────
  test('returns NoInternetFailure from repo on network error', () async {
    when(
      () => mockRepo.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Left(tNoInternetFailure));

    final result = await useCase(tParams);

    expect(result, isA<Left<Failure, UserEntity>>());
    final failure = (result as Left<Failure, UserEntity>).value;
    expect(failure, isA<NoInternetFailure>());
  });

  // ─── Cache failure ────────────────────────────────────────────────────────────
  test('returns CacheFailure from repo on cache error', () async {
    when(
      () => mockRepo.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Left(tCacheFailure));

    final result = await useCase(tParams);

    expect(result, const Left<Failure, UserEntity>(tCacheFailure));
  });

  // ─── Correct params forwarded ─────────────────────────────────────────────────
  test('calls repo with exact email and password from params', () async {
    const specificParams = LoginParams(email: 'specific@email.com', password: 'supersecret');
    when(
      () => mockRepo.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Right(tUser));

    await useCase(specificParams);

    verify(() => mockRepo.login(email: 'specific@email.com', password: 'supersecret')).called(1);
  });

  // ─── Calls repo only once ─────────────────────────────────────────────────────
  test('calls repo exactly once', () async {
    when(
      () => mockRepo.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Right(tUser));

    await useCase(tParams);

    verify(
      () => mockRepo.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).called(1);
  });
}
