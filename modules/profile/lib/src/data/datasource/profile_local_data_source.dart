part of 'profile_local_data_source_impl.dart';

abstract interface class ProfileLocalDataSource {
  const new();

  ProfileUserModel? getProfileUser();

  Future<void> saveProfileUser(ProfileUserModel user);
}
