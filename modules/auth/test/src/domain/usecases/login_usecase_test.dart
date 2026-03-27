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
  const tFailure = ServerFailure(message: 'Login failed');

  setUp(() {
    mockRepo = _MockAuthRepo();
    useCase = Login(mockRepo);
  });

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

  test('returns Failure from repo on error', () async {
    when(
      () => mockRepo.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Left(tFailure));

    final result = await useCase(tParams);

    expect(result, const Left<Failure, UserEntity>(tFailure));
    verify(() => mockRepo.login(email: tParams.email, password: tParams.password)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
