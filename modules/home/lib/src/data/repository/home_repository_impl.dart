import 'package:home/src/data/datasource/home_local_data_source.dart';
import 'package:home/src/data/datasource/home_remote_data_source.dart';
import 'package:home/src/domain/repository/home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  const HomeRepoImpl(this._remoteSource, this._localSource);

  final HomeLocalDataSource _localSource;
  final HomeRemoteDataSource _remoteSource;
}
