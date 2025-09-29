import 'package:auth/src/data/models/login_model.dart';
import 'package:core/core.dart';

part 'auth_local_data_source_impl.dart';

abstract interface class AuthLocalDataSource {
  const AuthLocalDataSource();

  Future<void> saveUser(LoginModel login);
}
