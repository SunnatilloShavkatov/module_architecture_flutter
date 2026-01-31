part of 'main_remote_data_source.dart';

class MainRemoteDataSourceImpl implements MainRemoteDataSource {
  const MainRemoteDataSourceImpl(this._networkProvider);

  final NetworkProvider _networkProvider;
}
