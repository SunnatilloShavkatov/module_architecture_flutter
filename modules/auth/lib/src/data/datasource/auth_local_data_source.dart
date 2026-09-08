import 'package:auth/src/data/models/user_model.dart';
import 'package:core/core.dart';

part 'auth_local_data_source_impl.dart';

abstract interface class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
}
