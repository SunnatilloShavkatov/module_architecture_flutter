part of 'more_remote_data_source.dart';

final class MoreRemoteDataSourceImpl implements MoreRemoteDataSource {
  const MoreRemoteDataSourceImpl(this._networkProvider);

  final NetworkProvider _networkProvider;

  @override
  Future<void> getMoreData() async {
    try {
      await _networkProvider.fetchMethod<DataMap>(
        ApiPaths.loginWithOption,
        methodType: RMethodTypes.get,
        headers: _networkProvider.tokenHeaders,
      );
      return;
    } on FormatException {
      throw ServerException.formatException(locale: _networkProvider.locale);
    } on ServerException {
      rethrow;
    } on Exception {
      rethrow;
    } on Error catch (error, stackTrace) {
      logMessage('ERROR: ', error: error, stackTrace: stackTrace);
      if (error is TypeError) {
        throw ServerException.typeError(locale: _networkProvider.locale);
      } else {
        throw ServerException.unknownError(locale: _networkProvider.locale);
      }
    }
  }
}
