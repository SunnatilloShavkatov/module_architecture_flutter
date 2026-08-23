import 'package:core/core.dart';
import 'package:payments/src/domain/entities/payment_method_entity.dart';
import 'package:payments/src/domain/usecases/add_payment_method.dart';
import 'package:payments/src/domain/usecases/delete_payment_method.dart';
import 'package:payments/src/domain/usecases/get_payment_methods.dart';

part 'payment_methods_event.dart';
part 'payment_methods_state.dart';

final class PaymentMethodsBloc extends Bloc<PaymentMethodsEvent, PaymentMethodsState> {
  new(this._getPaymentMethods, this._addPaymentMethod, this._deletePaymentMethod)
    : super(const PaymentMethodsInitialState()) {
    on<PaymentMethodsLoadEvent>(_getPaymentMethodsHandler, transformer: droppable());
    on<PaymentMethodAddEvent>(_addPaymentMethodHandler, transformer: throttle());
    on<PaymentMethodDeleteEvent>(_deletePaymentMethodHandler, transformer: throttle());
  }

  final GetPaymentMethods _getPaymentMethods;
  final AddPaymentMethod _addPaymentMethod;
  final DeletePaymentMethod _deletePaymentMethod;

  Future<void> _getPaymentMethodsHandler(PaymentMethodsLoadEvent event, Emitter<PaymentMethodsState> emit) async {
    if (state is PaymentMethodsLoadingState) {
      return;
    }
    emit(const PaymentMethodsLoadingState());
    final result = await _getPaymentMethods();
    result.fold(
      (failure) => emit(PaymentMethodsFailureState(message: failure.message)),
      (paymentMethods) => emit(PaymentMethodsSuccessState(paymentMethods: paymentMethods)),
    );
  }

  Future<void> _addPaymentMethodHandler(PaymentMethodAddEvent event, Emitter<PaymentMethodsState> emit) async {
    if (state is PaymentMethodsLoadingState) {
      return;
    }
    emit(const PaymentMethodsLoadingState());
    final addResult = await _addPaymentMethod(
      AddPaymentMethodParams(
        cardNumber: event.cardNumber,
        cardLast4: event.cardLast4,
        cardBrand: event.cardBrand,
        expiryDate: event.expiryDate,
        isDefault: event.isDefault,
      ),
    );
    final addFailure = addResult.fold((failure) => failure, (_) => null);
    if (addFailure != null) {
      emit(PaymentMethodsFailureState(message: addFailure.message));
      return;
    }
    final listResult = await _getPaymentMethods();
    listResult.fold(
      (failure) => emit(PaymentMethodsFailureState(message: failure.message)),
      (paymentMethods) =>
          emit(PaymentMethodsActionSuccessState(message: 'Card added successfully', paymentMethods: paymentMethods)),
    );
  }

  Future<void> _deletePaymentMethodHandler(PaymentMethodDeleteEvent event, Emitter<PaymentMethodsState> emit) async {
    if (state is PaymentMethodsLoadingState) {
      return;
    }
    emit(const PaymentMethodsLoadingState());
    final deleteResult = await _deletePaymentMethod(DeletePaymentMethodParams(id: event.id));
    final deleteFailure = deleteResult.fold((failure) => failure, (_) => null);
    if (deleteFailure != null) {
      emit(PaymentMethodsFailureState(message: deleteFailure.message));
      return;
    }
    final listResult = await _getPaymentMethods();
    listResult.fold(
      (failure) => emit(PaymentMethodsFailureState(message: failure.message)),
      (paymentMethods) =>
          emit(PaymentMethodsActionSuccessState(message: 'Card deleted successfully', paymentMethods: paymentMethods)),
    );
  }
}
