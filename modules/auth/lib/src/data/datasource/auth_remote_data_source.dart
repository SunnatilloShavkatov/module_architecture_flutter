import 'package:auth/src/data/models/user_model.dart';
import 'package:core/core.dart';

part 'auth_remote_data_source_impl.dart';

abstract interface class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<UserModel> login({required String email, required String password});
}
