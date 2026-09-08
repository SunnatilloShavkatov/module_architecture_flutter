import 'package:main/src/data/datasource/main_local_data_source.dart';
import 'package:main/src/data/datasource/main_remote_data_source.dart';
import 'package:main/src/domain/repository/main_repository.dart';

final class MainRepositoryImpl implements MainRepository {
  const new(this._remoteSource, this._localSource);

  final MainLocalDataSource _localSource;
  final MainRemoteDataSource _remoteSource;
}
