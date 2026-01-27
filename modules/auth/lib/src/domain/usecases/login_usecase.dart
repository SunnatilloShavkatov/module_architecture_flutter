import 'package:auth/src/domain/entities/login_entity.dart';
import 'package:auth/src/domain/repos/auth_repo.dart';
import 'package:core/core.dart';

base class LoginUseCase extends UsecaseWithParams<LoginEntity, LoginParams> {
  const LoginUseCase(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<LoginEntity> call(LoginParams params) => _repo.login(
    deviceType: params.deviceType,
    identity: params.identity,
    password: params.password,
    fcmToken: params.fcmToken,
  );
}

final class LoginParams extends Equatable {
  const LoginParams({required this.deviceType, required this.identity, required this.password, required this.fcmToken});

  final int deviceType;
  final String identity;
  final String password;
  final String? fcmToken;

  @override
  List<Object?> get props => [deviceType, identity, password, fcmToken];
}
