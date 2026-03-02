import 'package:core/core.dart';
import 'package:profile/src/data/datasource/profile_api_paths.dart';
import 'package:profile/src/data/models/profile_user_model.dart';

part 'profile_remote_data_source_impl.dart';

abstract interface class ProfileRemoteDataSource {
  const ProfileRemoteDataSource();

  Future<ProfileUserModel> getProfileUser();

  Future<ProfileUserModel> updateProfile({
    required String username,
    required String firstName,
    required String lastName,
    required String phone,
    required String specialization,
  });
}
