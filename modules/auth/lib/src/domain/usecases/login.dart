import 'package:auth/src/domain/entities/user_entity.dart';
import 'package:auth/src/domain/repos/auth_repo.dart';
import 'package:core/core.dart';

base class Login extends UsecaseWithParams<UserEntity, LoginParams> {
  const Login(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<UserEntity> call(LoginParams params) => _repo.login(email: params.email, password: params.password);
}

final class LoginParams {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;
}
