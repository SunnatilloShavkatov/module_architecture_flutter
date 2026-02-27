import 'package:core/core.dart';

part 'profile_local_data_source.dart';

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  const ProfileLocalDataSourceImpl(this._localSource);

  final LocalSource _localSource;
}
