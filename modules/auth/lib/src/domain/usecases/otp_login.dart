import 'package:auth/src/domain/entities/user_entity.dart';
import 'package:auth/src/domain/repos/auth_repo.dart';
import 'package:core/core.dart';

final class OtpLogin extends UsecaseWithParams<UserEntity, OtpLoginParams> {
  const OtpLogin(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<UserEntity> call(OtpLoginParams params) => _repo.otpLogin(code: params.code);
}

final class OtpLoginParams {
  const OtpLoginParams({required this.code});

  final String code;
}
