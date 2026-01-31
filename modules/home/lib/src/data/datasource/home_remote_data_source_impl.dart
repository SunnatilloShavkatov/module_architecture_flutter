part of 'home_remote_data_source.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl(this._networkProvider);

  final NetworkProvider _networkProvider;
}
