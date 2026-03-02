import 'package:core/core.dart';
import 'package:profile/src/data/models/profile_user_model.dart';

part 'profile_local_data_source.dart';

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  const ProfileLocalDataSourceImpl(this._localSource);

  final LocalSource _localSource;

  @override
  ProfileUserModel? getProfileUser() {
    final dynamic rawUser = _localSource.getValue<dynamic>(key: StorageKeys.userData);
    if (rawUser is Map) {
      return ProfileUserModel.fromMap(Map<String, dynamic>.from(rawUser));
    }
    if (_localSource.firstName.trim().isNotEmpty || _localSource.phone.trim().isNotEmpty || _localSource.userId > 0) {
      return ProfileUserModel(
        id: _localSource.userId,
        email: '',
        firstName: _localSource.firstName,
        lastName: '',
        role: 'CLIENT',
        phone: _localSource.phone,
      );
    }
    return null;
  }

  @override
  Future<void> saveProfileUser(ProfileUserModel user) async {
    await Future.wait([
      _localSource.setUserId(user.id),
      _localSource.setFirstName(user.firstName),
      _localSource.setPhone(user.phone ?? ''),
      _localSource.setValue<Map<String, dynamic>>(key: StorageKeys.userData, value: user.toMap()),
      _localSource.setValue<String>(key: StorageKeys.lastname, value: user.lastName),
      _localSource.setValue<String>(key: StorageKeys.email, value: user.email),
      _localSource.setValue<String>(key: StorageKeys.role, value: user.role),
    ]);
  }
}
