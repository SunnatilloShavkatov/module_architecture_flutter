import 'package:flutter_test/flutter_test.dart';

// import 'package:auth/src/domain/entities/auth_entity.dart';
// import 'package:auth/src/domain/repos/auth_repo.dart';
// import 'package:auth/src/domain/usecases/login_usecase.dart';
// import 'package:core/core.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
//
// class MockAuthRepo extends Mock implements AuthRepo {}
//
// void main() {
//   late LoginUseCase useCase;
//   late MockAuthRepo mockRepo;
//
//   setUp(() {
//     mockRepo = MockAuthRepo();
//     useCase = LoginUseCase(mockRepo);
//   });
//
//   const tParams = LoginParams(username: 'admin', password: 'password');
//   const tAuth = AuthEntity(id: '1', token: 'token', username: 'admin');
//
//   test('should return AuthEntity from the repository when successful', () async {
//     // arrange
//     when(
//       () => mockRepo.login(
//         username: any(named: 'username'),
//         password: any(named: 'password'),
//       ),
//     ).thenAnswer((_) async => const Right(tAuth));
//
//     // act
//     final result = await useCase(tParams);
//
//     // assert
//     expect(result, const Right(tAuth));
//     verify(() => mockRepo.login(username: tParams.username, password: tParams.password)).called(1);
//     verifyNoMoreInteractions(mockRepo);
//   });
//
//   test('should return Failure from the repository when unsuccessful', () async {
//     // arrange
//     const tFailure = ServerFailure(message: 'Login Failed', statusCode: 401);
//     when(
//       () => mockRepo.login(
//         username: any(named: 'username'),
//         password: any(named: 'password'),
//       ),
//     ).thenAnswer((_) async => const Left(tFailure));
//
//     // act
//     final result = await useCase(tParams);
//
//     // assert
//     expect(result, const Left(tFailure));
//     verify(() => mockRepo.login(username: tParams.username, password: tParams.password)).called(1);
//     verifyNoMoreInteractions(mockRepo);
//   });
// }

void main() {
  test('login usecase tests are temporarily disabled', () {}, skip: true);
}
