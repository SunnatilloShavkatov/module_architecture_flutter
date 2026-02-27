import 'package:core/core.dart';
import 'package:profile/src/data/models/profile_user_model.dart';

part 'profile_local_data_source.dart';

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  const ProfileLocalDataSourceImpl(this._localSource);

  final LocalSource _localSource;

  @override
  ProfileUserModel getProfileUser() => ProfileUserModel(firstName: _localSource.firstName, phone: _localSource.phone);
}
