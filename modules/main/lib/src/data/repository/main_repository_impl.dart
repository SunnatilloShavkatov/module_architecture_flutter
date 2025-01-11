// ignore_for_file: unused_field

part of "package:main/src/domain/repository/main_repository.dart";

class MainRepositoryImpl implements MainRepository {
  MainRepositoryImpl(this._remoteSource, this._localSource);

  final MainRemoteDataSource _remoteSource;
  final MainLocalDataSource _localSource;
}
