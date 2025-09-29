import 'package:auth/src/data/datasource/auth_local_data_source.dart';
import 'package:auth/src/data/datasource/auth_remote_data_source.dart';
import 'package:auth/src/domain/entities/login_entity.dart';
import 'package:core/core.dart';

part 'package:auth/src/data/repo/auth_repo_impl.dart';

abstract interface class AuthRepo {
  const AuthRepo();

  ResultFuture<LoginEntity> isLoggedIn();
}
