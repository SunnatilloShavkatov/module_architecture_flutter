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

  const tCard1 = PaymentMethodEntity(
    id: 1,
    cardLast4: '4242',
    cardBrand: 'Visa',
    expiryDate: '12/26',
    isDefault: true,
  );
  const tCard2 = PaymentMethodEntity(
    id: 2,
    cardLast4: '5353',
    cardBrand: 'Mastercard',
    expiryDate: '06/27',
    isDefault: false,
  );
  final tCards = [tCard1, tCard2];
  const tAddEvent = PaymentMethodAddEvent(
    cardNumber: '4242424242424242',
    cardLast4: '4242',
    cardBrand: 'Visa',
    expiryDate: '12/26',
    isDefault: true,
  );
  const tServerFailure = ServerFailure(message: 'Server error');
  const tNoInternetFailure = NoInternetFailure(message: 'No internet');

  setUp(() {
    mockGetPaymentMethods = _MockGetPaymentMethods();
    mockAddPaymentMethod = _MockAddPaymentMethod();
    mockDeletePaymentMethod = _MockDeletePaymentMethod();
    paymentMethodsBloc = PaymentMethodsBloc(
      mockGetPaymentMethods,
      mockAddPaymentMethod,
      mockDeletePaymentMethod,
    );
    registerFallbackValue(
      const AddPaymentMethodParams(cardNumber: '', cardLast4: '', cardBrand: '', expiryDate: '', isDefault: false),
    );
    registerFallbackValue(const DeletePaymentMethodParams(id: 0));
  });

  tearDown(() => paymentMethodsBloc.close());

  // ─── Initial state ────────────────────────────────────────────────────────────
  test('initial state is PaymentMethodsInitialState', () {
    expect(paymentMethodsBloc.state, const PaymentMethodsInitialState());
  });

  // ─── Load success ─────────────────────────────────────────────────────────────
  blocTest<PaymentMethodsBloc, PaymentMethodsState>(
    'emits [PaymentMethodsLoadingState, PaymentMethodsSuccessState] on load success',
    build: () {
      when(() => mockGetPaymentMethods()).thenAnswer((_) async => Right(tCards));
      return paymentMethodsBloc;
    },
    act: (bloc) => bloc.add(const PaymentMethodsLoadEvent()),
    expect: () => [
      const PaymentMethodsLoadingState(),
      PaymentMethodsSuccessState(paymentMethods: tCards),
    ],
    verify: (_) => verify(() => mockGetPaymentMethods()).called(1),
  );

  // ─── Load success empty list ──────────────────────────────────────────────────
  blocTest<PaymentMethodsBloc, PaymentMethodsState>(
    'emits PaymentMethodsSuccessState with empty list when no cards',
    build: () {
      when(() => mockGetPaymentMethods()).thenAnswer((_) async => const Right([]));
      return paymentMethodsBloc;
    },
    act: (bloc) => bloc.add(const PaymentMethodsLoadEvent()),
    expect: () => [
      const PaymentMethodsLoadingState(),
      const PaymentMethodsSuccessState(paymentMethods: []),
    ],
  );

  // ─── Load server failure ──────────────────────────────────────────────────────
  blocTest<PaymentMethodsBloc, PaymentMethodsState>(
    'emits [PaymentMethodsLoadingState, PaymentMethodsFailureState] on load server failure',
    build: () {
      when(() => mockGetPaymentMethods()).thenAnswer((_) async => const Left(tServerFailure));
      return paymentMethodsBloc;
    },
    act: (bloc) => bloc.add(const PaymentMethodsLoadEvent()),
    expect: () => [
      const PaymentMethodsLoadingState(),
      const PaymentMethodsFailureState(message: 'Server error'),
    ],
    verify: (_) => verify(() => mockGetPaymentMethods()).called(1),
  );

  // ─── Load network failure ─────────────────────────────────────────────────────
  blocTest<PaymentMethodsBloc, PaymentMethodsState>(
    'emits PaymentMethodsFailureState on load network failure',
    build: () {
      when(() => mockGetPaymentMethods()).thenAnswer((_) async => const Left(tNoInternetFailure));
      return paymentMethodsBloc;
    },
    act: (bloc) => bloc.add(const PaymentMethodsLoadEvent()),
    expect: () => [
      const PaymentMethodsLoadingState(),
      const PaymentMethodsFailureState(message: 'No internet'),
    ],
  );

  // ─── Add card success ─────────────────────────────────────────────────────────
  blocTest<PaymentMethodsBloc, PaymentMethodsState>(
    'emits [PaymentMethodsLoadingState, PaymentMethodsActionSuccessState] on add card success',
    build: () {
      when(() => mockAddPaymentMethod(any())).thenAnswer((_) async => const Right(tCard1));
      when(() => mockGetPaymentMethods()).thenAnswer((_) async => Right(tCards));
      return paymentMethodsBloc;
    },
    act: (bloc) => bloc.add(tAddEvent),
    expect: () => [
      const PaymentMethodsLoadingState(),
      PaymentMethodsActionSuccessState(message: 'Card added successfully', paymentMethods: tCards),
    ],
    verify: (_) {
      verify(() => mockAddPaymentMethod(any())).called(1);
      verify(() => mockGetPaymentMethods()).called(1);
    },
  );

  // ─── Add card then refetch fails ──────────────────────────────────────────────
  blocTest<PaymentMethodsBloc, PaymentMethodsState>(
    'emits PaymentMethodsFailureState when add succeeds but refetch fails',
    build: () {
      when(() => mockAddPaymentMethod(any())).thenAnswer((_) async => const Right(tCard1));
      when(() => mockGetPaymentMethods()).thenAnswer((_) async => const Left(tServerFailure));
      return paymentMethodsBloc;
    },
    act: (bloc) => bloc.add(tAddEvent),
    expect: () => [
      const PaymentMethodsLoadingState(),
      const PaymentMethodsFailureState(message: 'Server error'),
    ],
  );

  // ─── Add card failure ─────────────────────────────────────────────────────────
  blocTest<PaymentMethodsBloc, PaymentMethodsState>(
    'emits [PaymentMethodsLoadingState, PaymentMethodsFailureState] on add card failure',
    build: () {
      when(() => mockAddPaymentMethod(any())).thenAnswer((_) async => const Left(tServerFailure));
      return paymentMethodsBloc;
    },
    act: (bloc) => bloc.add(tAddEvent),
    expect: () => [
      const PaymentMethodsLoadingState(),
      const PaymentMethodsFailureState(message: 'Server error'),
    ],
    verify: (_) {
      verify(() => mockAddPaymentMethod(any())).called(1);
      verifyNever(() => mockGetPaymentMethods());
    },
  );

  // ─── Delete card success ──────────────────────────────────────────────────────
  blocTest<PaymentMethodsBloc, PaymentMethodsState>(
    'emits [PaymentMethodsLoadingState, PaymentMethodsActionSuccessState] on delete card success',
    build: () {
      when(() => mockDeletePaymentMethod(any())).thenAnswer((_) async => const Right(null));
      when(() => mockGetPaymentMethods()).thenAnswer((_) async => const Right(<PaymentMethodEntity>[tCard2]));
      return paymentMethodsBloc;
    },
    act: (bloc) => bloc.add(const PaymentMethodDeleteEvent(id: 1)),
    expect: () => [
      const PaymentMethodsLoadingState(),
      const PaymentMethodsActionSuccessState(message: 'Card deleted successfully', paymentMethods: <PaymentMethodEntity>[tCard2]),
    ],
    verify: (_) {
      verify(() => mockDeletePaymentMethod(any())).called(1);
      verify(() => mockGetPaymentMethods()).called(1);
    },
  );

  // ─── Delete card failure ──────────────────────────────────────────────────────
  blocTest<PaymentMethodsBloc, PaymentMethodsState>(
    'emits [PaymentMethodsLoadingState, PaymentMethodsFailureState] on delete card failure',
    build: () {
      when(() => mockDeletePaymentMethod(any())).thenAnswer((_) async => const Left(tServerFailure));
      return paymentMethodsBloc;
    },
    act: (bloc) => bloc.add(const PaymentMethodDeleteEvent(id: 1)),
    expect: () => [
      const PaymentMethodsLoadingState(),
      const PaymentMethodsFailureState(message: 'Server error'),
    ],
    verify: (_) {
      verify(() => mockDeletePaymentMethod(any())).called(1);
      verifyNever(() => mockGetPaymentMethods());
    },
  );

  // ─── Delete then refetch fails ────────────────────────────────────────────────
  blocTest<PaymentMethodsBloc, PaymentMethodsState>(
    'emits PaymentMethodsFailureState when delete succeeds but refetch fails',
    build: () {
      when(() => mockDeletePaymentMethod(any())).thenAnswer((_) async => const Right(null));
      when(() => mockGetPaymentMethods()).thenAnswer((_) async => const Left(tServerFailure));
      return paymentMethodsBloc;
    },
    act: (bloc) => bloc.add(const PaymentMethodDeleteEvent(id: 1)),
    expect: () => [
      const PaymentMethodsLoadingState(),
      const PaymentMethodsFailureState(message: 'Server error'),
    ],
  );

  // ─── Add while loading ignored ────────────────────────────────────────────────
  blocTest<PaymentMethodsBloc, PaymentMethodsState>(
    'ignores PaymentMethodAddEvent while already loading',
    build: () {
      when(() => mockGetPaymentMethods()).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        return Right(tCards);
      });
      return paymentMethodsBloc;
    },
    seed: () => const PaymentMethodsLoadingState(),
    act: (bloc) => bloc.add(tAddEvent),
    expect: () => <PaymentMethodsState>[],
    verify: (_) => verifyNever(() => mockAddPaymentMethod(any())),
  );

  // ─── Delete while loading ignored ─────────────────────────────────────────────
  blocTest<PaymentMethodsBloc, PaymentMethodsState>(
    'ignores PaymentMethodDeleteEvent while already loading',
    build: () => paymentMethodsBloc,
    seed: () => const PaymentMethodsLoadingState(),
    act: (bloc) => bloc.add(const PaymentMethodDeleteEvent(id: 1)),
    expect: () => <PaymentMethodsState>[],
    verify: (_) => verifyNever(() => mockDeletePaymentMethod(any())),
  );

  // ─── PaymentMethodsActionSuccessState message ─────────────────────────────────
  blocTest<PaymentMethodsBloc, PaymentMethodsState>(
    'action success message is "Card added successfully" for add operation',
    build: () {
      when(() => mockAddPaymentMethod(any())).thenAnswer((_) async => const Right(tCard1));
      when(() => mockGetPaymentMethods()).thenAnswer((_) async => Right(tCards));
      return paymentMethodsBloc;
    },
    act: (bloc) => bloc.add(tAddEvent),
    verify: (bloc) {
      final state = bloc.state as PaymentMethodsActionSuccessState;
      expect(state.message, 'Card added successfully');
    },
  );

  blocTest<PaymentMethodsBloc, PaymentMethodsState>(
    'action success message is "Card deleted successfully" for delete operation',
    build: () {
      when(() => mockDeletePaymentMethod(any())).thenAnswer((_) async => const Right(null));
      when(() => mockGetPaymentMethods()).thenAnswer((_) async => const Right(<PaymentMethodEntity>[]));
      return paymentMethodsBloc;
    },
    act: (bloc) => bloc.add(const PaymentMethodDeleteEvent(id: 1)),
    verify: (bloc) {
      final state = bloc.state as PaymentMethodsActionSuccessState;
      expect(state.message, 'Card deleted successfully');
    },
  );
}
