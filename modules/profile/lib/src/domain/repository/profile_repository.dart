import 'package:core/core.dart';
import 'package:profile/src/domain/entities/profile_user_entity.dart';

abstract interface class ProfileRepository {
  const ProfileRepository();

  ResultFuture<ProfileUserEntity> getProfileUser();
}
