import 'package:auth/src/domain/entities/auth_entity.dart';
import 'package:auth/src/domain/repos/auth_repo.dart';
import 'package:core/core.dart';

base class LoginUseCase extends UsecaseWithParams<AuthEntity, LoginParams> {
  const LoginUseCase(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<AuthEntity> call(LoginParams params) => _repo.login(username: params.username, password: params.password);
}

final class LoginParams extends Equatable {
  const LoginParams({required this.username, required this.password});

  final String username;
  final String password;

  @override
  List<Object?> get props => [username, password];
}
