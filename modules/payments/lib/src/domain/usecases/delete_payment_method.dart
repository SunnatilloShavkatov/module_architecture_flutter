import 'package:core/core.dart';
import 'package:payments/src/domain/repository/payments_repository.dart';

class DeletePaymentMethod extends UsecaseWithParams<void, DeletePaymentMethodParams> {
  const new(this._repo);

  final PaymentsRepository _repo;

  @override
  ResultFeatureVoid call(DeletePaymentMethodParams params) => _repo.deletePaymentMethod(id: params.id);
}

final class DeletePaymentMethodParams {
  const new({required this.id});

  final int id;
}
