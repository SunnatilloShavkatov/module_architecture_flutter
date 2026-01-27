import 'package:auth/src/domain/entities/auth_entity.dart';
import 'package:core/core.dart';

abstract interface class AuthRepo {
  ResultFuture<AuthEntity> login({required String username, required String password});
}
