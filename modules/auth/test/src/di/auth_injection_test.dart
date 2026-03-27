import 'package:auth/src/data/datasource/auth_local_data_source.dart';
import 'package:auth/src/data/datasource/auth_remote_data_source.dart';
import 'package:auth/src/di/auth_injection.dart';
import 'package:auth/src/domain/repos/auth_repo.dart';
import 'package:auth/src/domain/usecases/login.dart';
import 'package:auth/src/domain/usecases/otp_login.dart';
import 'package:auth/src/presentation/login/bloc/login_bloc.dart';
import 'package:auth/src/presentation/otp_login/bloc/otp_login_bloc.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockInjector extends Mock implements Injector {}

void main() {
  late _MockInjector mockInjector;
  const injection = AuthInjection();

  setUp(() {
    mockInjector = _MockInjector();
  });

  group('AuthInjection', () {
    test('registers all required dependencies', () async {
      await injection.registerDependencies(di: mockInjector);

      verify(() => mockInjector.registerLazySingleton<AuthLocalDataSource>(any())).called(1);
      verify(() => mockInjector.registerLazySingleton<AuthRemoteDataSource>(any())).called(1);
      verify(() => mockInjector.registerLazySingleton<AuthRepo>(any())).called(1);
      verify(() => mockInjector.registerLazySingleton<Login>(any())).called(1);
      verify(() => mockInjector.registerLazySingleton<OtpLogin>(any())).called(1);
      verify(() => mockInjector.registerFactory<LoginBloc>(any())).called(1);
      verify(() => mockInjector.registerFactory<OtpLoginBloc>(any())).called(1);
    });
  });
}
