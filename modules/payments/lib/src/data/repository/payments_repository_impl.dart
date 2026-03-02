import 'package:core/core.dart';
import 'package:payments/src/data/datasource/payments_remote_data_source.dart';
import 'package:payments/src/domain/entities/payment_method_entity.dart';
import 'package:payments/src/domain/repository/payments_repository.dart';

final class PaymentsRepositoryImpl implements PaymentsRepository {
  const PaymentsRepositoryImpl(this._remoteDataSource);

  final PaymentsRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<List<PaymentMethodEntity>> getPaymentMethods() async {
    try {
      final result = await _remoteDataSource.getPaymentMethods();
      return Right(result);
    } on ServerException catch (error) {
      return Left(error.failure);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<PaymentMethodEntity> addPaymentMethod({
    required String cardNumber,
    required String cardLast4,
    required String cardBrand,
    required String expiryDate,
    required bool isDefault,
  }) async {
    try {
      final result = await _remoteDataSource.addPaymentMethod(
        cardNumber: cardNumber,
        cardLast4: cardLast4,
        cardBrand: cardBrand,
        expiryDate: expiryDate,
        isDefault: isDefault,
      );
      return Right(result);
    } on ServerException catch (error) {
      return Left(error.failure);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFeatureVoid deletePaymentMethod({required int id}) async {
    try {
      final result = await _remoteDataSource.deletePaymentMethod(id: id);
      return Right(result);
    } on ServerException catch (error) {
      return Left(error.failure);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
