import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:payments/src/domain/entities/payment_method_entity.dart';
import 'package:payments/src/domain/usecases/add_payment_method.dart';
import 'package:payments/src/domain/usecases/delete_payment_method.dart';
import 'package:payments/src/domain/usecases/get_payment_methods.dart';
import 'package:payments/src/presentation/payment_methods/bloc/payment_methods_bloc.dart';

class _MockGetPaymentMethods extends Mock implements GetPaymentMethods {}

class _MockAddPaymentMethod extends Mock implements AddPaymentMethod {}

class _MockDeletePaymentMethod extends Mock implements DeletePaymentMethod {}

void main() {
  late PaymentMethodsBloc paymentMethodsBloc;
  late _MockGetPaymentMethods mockGetPaymentMethods;
  late _MockAddPaymentMethod mockAddPaymentMethod;
  late _MockDeletePaymentMethod mockDeletePaymentMethod;

  const tCard = PaymentMethodEntity(id: 1, cardLast4: '4242', cardBrand: 'Visa', expiryDate: '12/26', isDefault: true);
  final tCards = [tCard];
  const tFailure = ServerFailure(message: 'Server error');

  setUp(() {
    mockGetPaymentMethods = _MockGetPaymentMethods();
    mockAddPaymentMethod = _MockAddPaymentMethod();
    mockDeletePaymentMethod = _MockDeletePaymentMethod();
    paymentMethodsBloc = PaymentMethodsBloc(mockGetPaymentMethods, mockAddPaymentMethod, mockDeletePaymentMethod);
    registerFallbackValue(
      const AddPaymentMethodParams(cardNumber: '', cardLast4: '', cardBrand: '', expiryDate: '', isDefault: false),
    );
    registerFallbackValue(const DeletePaymentMethodParams(id: 0));
  });

  tearDown(() => paymentMethodsBloc.close());

  test('initial state is PaymentMethodsInitialState', () {
    expect(paymentMethodsBloc.state, const PaymentMethodsInitialState());
  });

  blocTest<PaymentMethodsBloc, PaymentMethodsState>(
    'emits [PaymentMethodsLoadingState, PaymentMethodsSuccessState] on load success',
    build: () {
      when(() => mockGetPaymentMethods()).thenAnswer((_) async => Right(tCards));
      return paymentMethodsBloc;
    },
    act: (bloc) => bloc.add(const PaymentMethodsLoadEvent()),
    expect: () => [const PaymentMethodsLoadingState(), PaymentMethodsSuccessState(paymentMethods: tCards)],
    verify: (_) {
      verify(() => mockGetPaymentMethods()).called(1);
    },
  );

  blocTest<PaymentMethodsBloc, PaymentMethodsState>(
    'emits [PaymentMethodsLoadingState, PaymentMethodsFailureState] on load failure',
    build: () {
      when(() => mockGetPaymentMethods()).thenAnswer((_) async => const Left(tFailure));
      return paymentMethodsBloc;
    },
    act: (bloc) => bloc.add(const PaymentMethodsLoadEvent()),
    expect: () => [const PaymentMethodsLoadingState(), const PaymentMethodsFailureState(message: 'Server error')],
  );

  blocTest<PaymentMethodsBloc, PaymentMethodsState>(
    'emits [PaymentMethodsLoadingState, PaymentMethodsActionSuccessState] on add card success',
    build: () {
      when(() => mockAddPaymentMethod(any())).thenAnswer((_) async => const Right(tCard));
      when(() => mockGetPaymentMethods()).thenAnswer((_) async => Right(tCards));
      return paymentMethodsBloc;
    },
    act: (bloc) => bloc.add(
      const PaymentMethodAddEvent(
        cardNumber: '4242424242424242',
        cardLast4: '4242',
        cardBrand: 'Visa',
        expiryDate: '12/26',
        isDefault: true,
      ),
    ),
    expect: () => [
      const PaymentMethodsLoadingState(),
      PaymentMethodsActionSuccessState(message: 'Card added successfully', paymentMethods: tCards),
    ],
  );

  blocTest<PaymentMethodsBloc, PaymentMethodsState>(
    'emits [PaymentMethodsLoadingState, PaymentMethodsActionSuccessState] on delete card success',
    build: () {
      when(() => mockDeletePaymentMethod(any())).thenAnswer((_) async => const Right(null));
      when(() => mockGetPaymentMethods()).thenAnswer((_) async => const Right([]));
      return paymentMethodsBloc;
    },
    act: (bloc) => bloc.add(const PaymentMethodDeleteEvent(id: 1)),
    expect: () => [
      const PaymentMethodsLoadingState(),
      const PaymentMethodsActionSuccessState(message: 'Card deleted successfully', paymentMethods: []),
    ],
  );

  blocTest<PaymentMethodsBloc, PaymentMethodsState>(
    'emits [PaymentMethodsLoadingState, PaymentMethodsFailureState] on add card failure',
    build: () {
      when(() => mockAddPaymentMethod(any())).thenAnswer((_) async => const Left(tFailure));
      return paymentMethodsBloc;
    },
    act: (bloc) => bloc.add(
      const PaymentMethodAddEvent(
        cardNumber: '4242424242424242',
        cardLast4: '4242',
        cardBrand: 'Visa',
        expiryDate: '12/26',
        isDefault: true,
      ),
    ),
    expect: () => [const PaymentMethodsLoadingState(), const PaymentMethodsFailureState(message: 'Server error')],
  );
}
