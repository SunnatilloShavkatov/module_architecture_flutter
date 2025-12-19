import 'package:auth/src/domain/entities/login_entity.dart';
import 'package:core/core.dart';

abstract interface class AuthRepo {
  const AuthRepo();

  ResultFuture<LoginEntity> isLoggedIn();
}
