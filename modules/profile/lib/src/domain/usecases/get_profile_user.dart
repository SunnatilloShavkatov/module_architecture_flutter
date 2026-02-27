import 'package:core/core.dart';
import 'package:profile/src/domain/entities/profile_user_entity.dart';
import 'package:profile/src/domain/repository/profile_repository.dart';

final class GetProfileUser extends UsecaseWithoutParams<ProfileUserEntity> {
  const GetProfileUser(this._repo);

  final ProfileRepository _repo;

  @override
  ResultFuture<ProfileUserEntity> call() => _repo.getProfileUser();
}
