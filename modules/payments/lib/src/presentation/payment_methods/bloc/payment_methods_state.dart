part of 'payment_methods_bloc.dart';

sealed class PaymentMethodsState extends Equatable {
  const PaymentMethodsState();
}

final class PaymentMethodsInitialState extends PaymentMethodsState {
  const PaymentMethodsInitialState();

  @override
  List<Object?> get props => [];
}

final class PaymentMethodsLoadingState extends PaymentMethodsState {
  const PaymentMethodsLoadingState();

  @override
  List<Object?> get props => [];
}

final class PaymentMethodsSuccessState extends PaymentMethodsState {
  const PaymentMethodsSuccessState({required this.paymentMethods});

  final List<PaymentMethodEntity> paymentMethods;

  @override
  List<Object?> get props => [paymentMethods];
}

final class PaymentMethodsActionSuccessState extends PaymentMethodsState {
  const PaymentMethodsActionSuccessState({required this.message, required this.paymentMethods});

  final String message;
  final List<PaymentMethodEntity> paymentMethods;

  @override
  List<Object?> get props => [message, paymentMethods];
}

final class PaymentMethodsFailureState extends PaymentMethodsState {
  const PaymentMethodsFailureState({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
