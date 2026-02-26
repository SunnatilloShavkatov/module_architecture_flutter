import 'package:auth/src/domain/entities/user_entity.dart';
import 'package:core/core.dart';

abstract interface class AuthRepo {
  const AuthRepo();

  ResultFuture<UserEntity> login({required String email, required String password});
}
