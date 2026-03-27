import 'package:flutter_test/flutter_test.dart';
import 'src/data/datasource/auth_remote_data_source_test.dart' as auth_remote_data_source_test;
import 'src/data/models/user_model_test.dart' as user_model_test;
import 'src/data/repo/auth_repo_test.dart' as auth_repo_test;
import 'src/di/auth_injection_test.dart' as auth_injection_test;
import 'src/domain/usecases/login_usecase_test.dart' as login_usecase_test;
import 'src/domain/usecases/otp_login_usecase_test.dart' as otp_login_usecase_test;
import 'src/presentation/login/bloc/login_bloc_test.dart' as login_bloc_test;
import 'src/presentation/otp_login/bloc/otp_login_bloc_test.dart' as otp_login_bloc_test;
import 'src/router/auth_router_test.dart' as auth_router_test;

void main() {
  group('Auth Module Tests', () {
    // Data Layer
    group('Data Layer', () {
      user_model_test.main();
      auth_remote_data_source_test.main();
      auth_repo_test.main();
    });

    // DI Layer
    group('DI Layer', auth_injection_test.main);

    // Domain Layer
    group('Domain Layer', () {
      login_usecase_test.main();
      otp_login_usecase_test.main();
    });

    // Presentation Layer
    group('Presentation Layer', () {
      login_bloc_test.main();
      otp_login_bloc_test.main();
    });

    // Router Layer
    group('Router Layer', auth_router_test.main);
  });
}
