part of 'home_remote_data_source.dart';

final class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl(this._networkProvider);

  final NetworkProvider _networkProvider;

  @override
  Future<List<HomeCategoryModel>> getCategories() async {
    try {
      final result = await _networkProvider.fetchMethod<List<dynamic>>(
        HomeApiPaths.categories,
        methodType: RMethodTypes.get,
      );
      final List<HomeCategoryModel> categories = [];
      if (result.data != null && result.data is List) {
        for (final category in result.data!) {
          categories.add(HomeCategoryModel.fromMap(Map<String, dynamic>.from(category as Map)));
        }
      }
      return categories;
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

  @override
  Future<List<HomeBusinessModel>> getBusinesses() async {
    try {
      final result = await _networkProvider.fetchMethod<List<dynamic>>(
        HomeApiPaths.activeBusinesses,
        methodType: RMethodTypes.get,
      );
      final List<HomeBusinessModel> businesses = [];
      if (result.data != null && result.data is List) {
        for (final business in result.data!) {
          businesses.add(HomeBusinessModel.fromMap(Map<String, dynamic>.from(business as Map)));
        }
      }
      return businesses;
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

  @override
  Future<List<HomeAppointmentModel>> getMyAppointments() async {
    try {
      final result = await _networkProvider.fetchMethod<List<dynamic>>(
        HomeApiPaths.clientAppointments,
        methodType: RMethodTypes.get,
      );
      final List<HomeAppointmentModel> appointments = [];
      if (result.data != null && result.data is List) {
        for (final appointment in result.data!) {
          appointments.add(HomeAppointmentModel.fromMap(Map<String, dynamic>.from(appointment as Map)));
        }
      }
      return appointments;
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
