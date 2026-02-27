part of 'profile_local_data_source_impl.dart';

abstract interface class ProfileLocalDataSource {
  const ProfileLocalDataSource();

  ProfileUserModel getProfileUser();
}
