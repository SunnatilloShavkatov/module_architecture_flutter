import 'package:core/core.dart';
import 'package:home/src/data/datasource/home_local_data_source.dart';
import 'package:home/src/data/datasource/home_remote_data_source.dart';
import 'package:home/src/domain/entities/home_appointment_entity.dart';
import 'package:home/src/domain/entities/home_business_entity.dart';
import 'package:home/src/domain/entities/home_category_entity.dart';
import 'package:home/src/domain/repository/home_repo.dart';

final class HomeRepoImpl implements HomeRepo {
  const HomeRepoImpl(this._remoteSource, this._localSource);

  final HomeLocalDataSource _localSource;
  final HomeRemoteDataSource _remoteSource;

  @override
  ResultFuture<List<HomeCategoryEntity>> getCategories() async {
    try {
      final result = await _remoteSource.getCategories();
      return Right(result);
    } on ServerException catch (error) {
      return Left(error.failure);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<HomeBusinessEntity>> getBusinesses() async {
    try {
      final result = await _remoteSource.getBusinesses();
      return Right(result);
    } on ServerException catch (error) {
      return Left(error.failure);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<HomeAppointmentEntity>> getMyAppointments() async {
    try {
      final result = await _remoteSource.getMyAppointments();
      return Right(result);
    } on ServerException catch (error) {
      return Left(error.failure);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
