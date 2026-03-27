import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/src/data/datasource/home_local_data_source.dart';
import 'package:home/src/domain/entities/home_appointment_entity.dart';
import 'package:home/src/domain/entities/home_business_entity.dart';
import 'package:home/src/domain/entities/home_category_entity.dart';
import 'package:home/src/domain/usecases/get_home_appointments.dart';
import 'package:home/src/domain/usecases/get_home_businesses.dart';
import 'package:home/src/domain/usecases/get_home_categories.dart';
import 'package:home/src/presentation/main/bloc/home_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetHomeCategories extends Mock implements GetHomeCategories {}

class _MockGetHomeBusinesses extends Mock implements GetHomeBusinesses {}

class _MockGetHomeAppointments extends Mock implements GetHomeAppointments {}

class _MockHomeLocalDataSource extends Mock implements HomeLocalDataSource {}

// Returns a fresh mutable list each call.
// HomeBloc calls .sort() on appointments — const lists throw on sort.
List<HomeAppointmentEntity> _mutableEmptyAppts() => [];

void main() {
  late HomeBloc homeBloc;
  late _MockGetHomeCategories mockGetHomeCategories;
  late _MockGetHomeBusinesses mockGetHomeBusinesses;
  late _MockGetHomeAppointments mockGetHomeAppointments;
  late _MockHomeLocalDataSource mockLocalDataSource;

  const tCategory = HomeCategoryEntity(id: 1, name: 'Barbershop', slug: 'barbershop');
  const tCategory2 = HomeCategoryEntity(id: 2, name: 'Spa', slug: 'spa');
  const tBusiness = HomeBusinessEntity(
    id: '1',
    name: 'Test Barber',
    rating: 4.5,
    reviewCount: 10,
    imageUrl: 'https://example.com/img.jpg',
    distance: '1 km',
    waitTime: '10 min',
    isOpen: true,
    description: 'A test barber',
    workingHours: '9:00 - 18:00',
    phoneNumber: '+1234567890',
    address: '123 Main St',
  );

  final tNow = DateTime.now();
  final tFutureAppointment = HomeAppointmentEntity(
    id: 1,
    userId: 10,
    businessId: 1,
    staffId: 2,
    services: const [],
    startTime: tNow.add(const Duration(hours: 2)),
    endTime: tNow.add(const Duration(hours: 3)),
    status: 'CONFIRMED',
    totalPrice: 50,
  );
  final tPastAppointment = HomeAppointmentEntity(
    id: 2,
    userId: 10,
    businessId: 1,
    staffId: 2,
    services: const [],
    startTime: tNow.subtract(const Duration(days: 1)),
    endTime: tNow.subtract(const Duration(hours: 23)),
    status: 'COMPLETED',
    totalPrice: 40,
  );

  final tCategories = [tCategory, tCategory2];
  final tBusinesses = [tBusiness];
  const tServerFailure = ServerFailure(message: 'Load failed');
  const tNoInternetFailure = NoInternetFailure(message: 'No internet');

  setUp(() {
    mockGetHomeCategories = _MockGetHomeCategories();
    mockGetHomeBusinesses = _MockGetHomeBusinesses();
    mockGetHomeAppointments = _MockGetHomeAppointments();
    mockLocalDataSource = _MockHomeLocalDataSource();
    homeBloc = HomeBloc(mockGetHomeCategories, mockGetHomeBusinesses, mockGetHomeAppointments, mockLocalDataSource);
    when(() => mockLocalDataSource.firstName).thenReturn('Jasur');
  });

  tearDown(() => homeBloc.close());

  // ─── Initial state ────────────────────────────────────────────────────────────
  test('initial state is HomeInitialState', () {
    expect(homeBloc.state, const HomeInitialState());
  });

  // ─── Full success (with future appointment only) ──────────────────────────────
  blocTest<HomeBloc, HomeState>(
    'emits [HomeLoadingState, HomeSuccessState] and filters out past appointments',
    build: () {
      when(() => mockGetHomeCategories()).thenAnswer((_) async => Right(tCategories));
      when(() => mockGetHomeBusinesses()).thenAnswer((_) async => Right(tBusinesses));
      when(() => mockGetHomeAppointments()).thenAnswer((_) async => Right([tFutureAppointment, tPastAppointment]));
      return homeBloc;
    },
    act: (bloc) => bloc.add(const HomeLoadEvent()),
    expect: () => [
      const HomeLoadingState(),
      HomeSuccessState(
        firstName: 'Jasur',
        categories: tCategories,
        businesses: tBusinesses,
        appointments: [tFutureAppointment],
      ),
    ],
    verify: (_) {
      verify(() => mockGetHomeCategories()).called(1);
      verify(() => mockGetHomeBusinesses()).called(1);
      verify(() => mockGetHomeAppointments()).called(1);
    },
  );

  // ─── Success with empty lists ─────────────────────────────────────────────────
  blocTest<HomeBloc, HomeState>(
    'emits HomeSuccessState with empty lists when all return empty',
    build: () {
      when(() => mockGetHomeCategories()).thenAnswer((_) async => const Right(<HomeCategoryEntity>[]));
      when(() => mockGetHomeBusinesses()).thenAnswer((_) async => const Right(<HomeBusinessEntity>[]));
      when(() => mockGetHomeAppointments()).thenAnswer((_) async => Right(_mutableEmptyAppts()));
      return homeBloc;
    },
    act: (bloc) => bloc.add(const HomeLoadEvent()),
    expect: () => [
      const HomeLoadingState(),
      const HomeSuccessState(firstName: 'Jasur', categories: [], businesses: [], appointments: []),
    ],
  );

  // ─── firstName from local data source ────────────────────────────────────────
  blocTest<HomeBloc, HomeState>(
    'HomeSuccessState uses firstName from local data source',
    build: () {
      when(() => mockLocalDataSource.firstName).thenReturn('Dilnoza');
      when(() => mockGetHomeCategories()).thenAnswer((_) async => const Right(<HomeCategoryEntity>[]));
      when(() => mockGetHomeBusinesses()).thenAnswer((_) async => const Right(<HomeBusinessEntity>[]));
      when(() => mockGetHomeAppointments()).thenAnswer((_) async => Right(_mutableEmptyAppts()));
      return homeBloc;
    },
    act: (bloc) => bloc.add(const HomeLoadEvent()),
    expect: () => [
      const HomeLoadingState(),
      const HomeSuccessState(firstName: 'Dilnoza', categories: [], businesses: [], appointments: []),
    ],
  );

  // ─── Categories failure ───────────────────────────────────────────────────────
  blocTest<HomeBloc, HomeState>(
    'emits HomeFailureState when categories usecase fails',
    build: () {
      when(() => mockGetHomeCategories()).thenAnswer((_) async => const Left(tServerFailure));
      when(() => mockGetHomeBusinesses()).thenAnswer((_) async => Right(tBusinesses));
      when(() => mockGetHomeAppointments()).thenAnswer((_) async => Right([tFutureAppointment]));
      return homeBloc;
    },
    act: (bloc) => bloc.add(const HomeLoadEvent()),
    expect: () => [const HomeLoadingState(), const HomeFailureState(message: 'Load failed')],
  );

  // ─── Businesses failure ───────────────────────────────────────────────────────
  blocTest<HomeBloc, HomeState>(
    'emits HomeFailureState when businesses usecase fails',
    build: () {
      when(() => mockGetHomeCategories()).thenAnswer((_) async => Right(tCategories));
      when(() => mockGetHomeBusinesses()).thenAnswer((_) async => const Left(tServerFailure));
      when(() => mockGetHomeAppointments()).thenAnswer((_) async => Right([tFutureAppointment]));
      return homeBloc;
    },
    act: (bloc) => bloc.add(const HomeLoadEvent()),
    expect: () => [const HomeLoadingState(), const HomeFailureState(message: 'Load failed')],
  );

  // ─── Appointments failure ─────────────────────────────────────────────────────
  blocTest<HomeBloc, HomeState>(
    'emits HomeFailureState when appointments usecase fails',
    build: () {
      when(() => mockGetHomeCategories()).thenAnswer((_) async => Right(tCategories));
      when(() => mockGetHomeBusinesses()).thenAnswer((_) async => Right(tBusinesses));
      when(() => mockGetHomeAppointments()).thenAnswer((_) async => const Left(tServerFailure));
      return homeBloc;
    },
    act: (bloc) => bloc.add(const HomeLoadEvent()),
    expect: () => [const HomeLoadingState(), const HomeFailureState(message: 'Load failed')],
  );

  // ─── Network failure ──────────────────────────────────────────────────────────
  blocTest<HomeBloc, HomeState>(
    'emits HomeFailureState with network failure message',
    build: () {
      when(() => mockGetHomeCategories()).thenAnswer((_) async => const Left(tNoInternetFailure));
      when(() => mockGetHomeBusinesses()).thenAnswer((_) async => const Right([]));
      when(() => mockGetHomeAppointments()).thenAnswer((_) async => const Right([]));
      return homeBloc;
    },
    act: (bloc) => bloc.add(const HomeLoadEvent()),
    expect: () => [const HomeLoadingState(), const HomeFailureState(message: 'No internet')],
  );

  // ─── First failure wins (??= behavior) ───────────────────────────────────────
  blocTest<HomeBloc, HomeState>(
    'uses message from the first failure when multiple usecases fail',
    build: () {
      when(
        () => mockGetHomeCategories(),
      ).thenAnswer((_) async => const Left(ServerFailure(message: 'Categories error')));
      when(
        () => mockGetHomeBusinesses(),
      ).thenAnswer((_) async => const Left(ServerFailure(message: 'Businesses error')));
      when(() => mockGetHomeAppointments()).thenAnswer((_) async => const Right([]));
      return homeBloc;
    },
    act: (bloc) => bloc.add(const HomeLoadEvent()),
    expect: () => [const HomeLoadingState(), const HomeFailureState(message: 'Categories error')],
  );

  // ─── Appointments sorted by startTime ────────────────────────────────────────
  blocTest<HomeBloc, HomeState>(
    'sorts upcoming appointments by startTime ascending',
    build: () {
      final later = HomeAppointmentEntity(
        id: 10,
        userId: 1,
        businessId: 1,
        staffId: 1,
        services: const [],
        startTime: tNow.add(const Duration(hours: 5)),
        endTime: tNow.add(const Duration(hours: 6)),
        status: 'CONFIRMED',
        totalPrice: 30,
      );
      final sooner = HomeAppointmentEntity(
        id: 11,
        userId: 1,
        businessId: 1,
        staffId: 1,
        services: const [],
        startTime: tNow.add(const Duration(hours: 1)),
        endTime: tNow.add(const Duration(hours: 2)),
        status: 'CONFIRMED',
        totalPrice: 20,
      );
      when(() => mockGetHomeCategories()).thenAnswer((_) async => const Right([]));
      when(() => mockGetHomeBusinesses()).thenAnswer((_) async => const Right([]));
      when(() => mockGetHomeAppointments()).thenAnswer((_) async => Right([later, sooner]));
      return homeBloc;
    },
    act: (bloc) => bloc.add(const HomeLoadEvent()),
    verify: (bloc) {
      final state = bloc.state as HomeSuccessState;
      expect(state.appointments.first.id, 11);
      expect(state.appointments.last.id, 10);
    },
  );

  // ─── HomeRefreshEvent triggers reload ────────────────────────────────────────
  blocTest<HomeBloc, HomeState>(
    'HomeRefreshEvent reloads data',
    build: () {
      when(() => mockGetHomeCategories()).thenAnswer((_) async => Right(tCategories));
      when(() => mockGetHomeBusinesses()).thenAnswer((_) async => Right(tBusinesses));
      when(() => mockGetHomeAppointments()).thenAnswer((_) async => Right(_mutableEmptyAppts()));
      return homeBloc;
    },
    act: (bloc) => bloc.add(const HomeRefreshEvent()),
    expect: () => [
      const HomeLoadingState(),
      HomeSuccessState(firstName: 'Jasur', categories: tCategories, businesses: tBusinesses, appointments: const []),
    ],
    verify: (_) => verify(() => mockGetHomeCategories()).called(1),
  );

  // ─── Duplicate HomeLoadEvent while loading ────────────────────────────────────
  blocTest<HomeBloc, HomeState>(
    'ignores second HomeLoadEvent while already loading',
    build: () {
      when(() => mockGetHomeCategories()).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        return Right(tCategories);
      });
      when(() => mockGetHomeBusinesses()).thenAnswer((_) async => Right(tBusinesses));
      when(() => mockGetHomeAppointments()).thenAnswer((_) async => Right(_mutableEmptyAppts()));
      return homeBloc;
    },
    act: (bloc) {
      bloc
        ..add(const HomeLoadEvent())
        ..add(const HomeLoadEvent());
    },
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const HomeLoadingState(),
      HomeSuccessState(firstName: 'Jasur', categories: tCategories, businesses: tBusinesses, appointments: const []),
    ],
    verify: (_) => verify(() => mockGetHomeCategories()).called(1),
  );

  // ─── Can reload after success ─────────────────────────────────────────────────
  blocTest<HomeBloc, HomeState>(
    'can load again after HomeSuccessState',
    build: () {
      when(() => mockGetHomeCategories()).thenAnswer((_) async => Right(tCategories));
      when(() => mockGetHomeBusinesses()).thenAnswer((_) async => Right(tBusinesses));
      when(() => mockGetHomeAppointments()).thenAnswer((_) async => Right(_mutableEmptyAppts()));
      return homeBloc;
    },
    seed: () => const HomeSuccessState(firstName: 'Old', categories: [], businesses: [], appointments: []),
    act: (bloc) => bloc.add(const HomeLoadEvent()),
    expect: () => [
      const HomeLoadingState(),
      HomeSuccessState(firstName: 'Jasur', categories: tCategories, businesses: tBusinesses, appointments: const []),
    ],
    verify: (_) => verify(() => mockGetHomeCategories()).called(1),
  );
}
