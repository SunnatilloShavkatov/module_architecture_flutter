// ignore_for_file: unused_field

part of 'package:more/src/domain/repository/more_repository.dart';

class MoreRepositoryImpl implements MoreRepository {
  MoreRepositoryImpl(this._remoteSource, this._localSource);

  final MoreRemoteDataSource _remoteSource;
  final MoreLocalDataSource _localSource;
}
