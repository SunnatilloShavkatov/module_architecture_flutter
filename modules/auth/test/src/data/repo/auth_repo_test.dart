import 'package:auth/src/data/datasource/auth_local_data_source.dart';
import 'package:auth/src/data/datasource/auth_remote_data_source.dart';
import 'package:auth/src/data/models/user_model.dart';
import 'package:auth/src/data/repo/auth_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements AuthRemoteDataSource {}
class _MockLocal extends Mock implements AuthLocalDataSource {}

void main() {
  late AuthRepoImpl repo;
  late _MockRemote mockRemote;
  late _MockLocal mockLocal;

  const tUserModel = UserModel(id: 1, email: 't@t.com', firstName: 'T', lastName: 'U', role: 'CLIENT');

  setUp(() {
    mockRemote = _MockRemote();
    mockLocal = _MockLocal();
    repo = AuthRepoImpl(mockRemote, mockLocal);
    registerFallbackValue(tUserModel);
  });

  group('AuthRepoImpl', () {
    test('login returns Right(UserEntity) on success and saves user', () async {
      when(() => mockRemote.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => tUserModel);
      when(() => mockLocal.saveUser(any())).thenAnswer((_) async => {});

      final result = await repo.login(email: 't@t.com', password: 'p');
      expect(result.isRight, true);
      verify(() => mockLocal.saveUser(tUserModel)).called(1);
    });

    test('otpLogin returns Right(UserEntity) on success and saves user', () async {
      when(() => mockRemote.otpLogin(code: any(named: 'code'))).thenAnswer((_) async => tUserModel);
      when(() => mockLocal.saveUser(any())).thenAnswer((_) async => {});

      final result = await repo.otpLogin(code: '123456');
      expect(result.isRight, true);
      verify(() => mockLocal.saveUser(tUserModel)).called(1);
    });
  });
}
