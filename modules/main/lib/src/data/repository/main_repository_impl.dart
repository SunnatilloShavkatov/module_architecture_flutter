import 'package:main/src/data/datasource/main_local_data_source.dart';
import 'package:main/src/data/datasource/main_remote_data_source.dart';
import 'package:main/src/domain/repository/main_repo.dart';

class MainRepoImpl implements MainRepo {
  const MainRepoImpl(this._remoteSource, this._localSource);

  final MainLocalDataSource _localSource;
  final MainRemoteDataSource _remoteSource;
}
