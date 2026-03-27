import 'package:core/core.dart';
import 'package:profile/src/domain/entities/profile_user_entity.dart';
import 'package:profile/src/domain/repository/profile_repository.dart';

class UpdateProfileUser extends UsecaseWithParams<ProfileUserEntity, UpdateProfileUserParams> {
  const UpdateProfileUser(this._repo);

  final ProfileRepository _repo;

  @override
  ResultFuture<ProfileUserEntity> call(UpdateProfileUserParams params) => _repo.updateProfile(
    username: params.username,
    firstName: params.firstName,
    lastName: params.lastName,
    phone: params.phone,
    specialization: params.specialization,
  );
}

final class UpdateProfileUserParams {
  const UpdateProfileUserParams({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.specialization,
  });

  final String username;
  final String firstName;
  final String lastName;
  final String phone;
  final String specialization;
}
