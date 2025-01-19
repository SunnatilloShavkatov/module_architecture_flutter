part of 'more_remote_data_source.dart';

final class MoreRemoteDataSourceImpl implements MoreRemoteDataSource {
  const MoreRemoteDataSourceImpl(this._networkProvider);

  final NetworkProvider _networkProvider;

  @override
  Future<void> getMoreData() async {
    try {
      await _networkProvider.fetchMethod(
        methodType: RMethodTypes.get,
        Constants.baseUrl + Urls.loginWithOption,
        headers: {'Authorization': localSource.accessToken},
      );
      return;
    } on ServerError {
      rethrow;
    } on Exception catch (error, _) {
      throw ServerError.withException(error: error);
    }
  }
}
