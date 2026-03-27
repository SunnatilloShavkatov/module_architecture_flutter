import 'package:core/core.dart';
import 'package:payments/src/domain/entities/payment_method_entity.dart';
import 'package:payments/src/domain/repository/payments_repository.dart';

class GetPaymentMethods extends UsecaseWithoutParams<List<PaymentMethodEntity>> {
  const GetPaymentMethods(this._repo);

  final PaymentsRepository _repo;

  @override
  ResultFuture<List<PaymentMethodEntity>> call() => _repo.getPaymentMethods();
}
