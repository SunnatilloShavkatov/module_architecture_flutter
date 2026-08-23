part of 'payment_methods_bloc.dart';

sealed class PaymentMethodsState extends Equatable {
  const new();
}

final class PaymentMethodsInitialState extends PaymentMethodsState {
  const new();

  @override
  List<Object?> get props => [];
}

final class PaymentMethodsLoadingState extends PaymentMethodsState {
  const new();

  @override
  List<Object?> get props => [];
}

final class PaymentMethodsSuccessState extends PaymentMethodsState {
  const new({required this.paymentMethods});

  final List<PaymentMethodEntity> paymentMethods;

  @override
  List<Object?> get props => [paymentMethods];
}

final class PaymentMethodsActionSuccessState extends PaymentMethodsState {
  const new({required this.message, required this.paymentMethods});

  final String message;
  final List<PaymentMethodEntity> paymentMethods;

  @override
  List<Object?> get props => [message, paymentMethods];
}

final class PaymentMethodsFailureState extends PaymentMethodsState {
  const new({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
