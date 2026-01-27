import 'package:auth/src/data/models/login_model.dart';
import 'package:core/core.dart';

part 'auth_remote_data_source_impl.dart';

abstract interface class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<LoginModel> login({
    required String? fcmToken,
    required int deviceType,
    required String identity,
    required String password,
  });
}
