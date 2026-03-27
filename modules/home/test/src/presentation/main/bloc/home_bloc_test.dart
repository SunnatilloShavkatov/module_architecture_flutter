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

void main() {
  late HomeBloc homeBloc;
  late _MockGetHomeCategories mockGetHomeCategories;
  late _MockGetHomeBusinesses mockGetHomeBusinesses;
  late _MockGetHomeAppointments mockGetHomeAppointments;
  late _MockHomeLocalDataSource mockLocalDataSource;

  const tCategory = HomeCategoryEntity(id: 1, name: 'Barbershop', slug: 'barbershop');
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
  final tCategories = [tCategory];
  final tBusinesses = [tBusiness];
  final tAppointments = <HomeAppointmentEntity>[];
  const tFailure = ServerFailure(message: 'Load failed');

  setUp(() {
    mockGetHomeCategories = _MockGetHomeCategories();
    mockGetHomeBusinesses = _MockGetHomeBusinesses();
    mockGetHomeAppointments = _MockGetHomeAppointments();
    mockLocalDataSource = _MockHomeLocalDataSource();
    homeBloc = HomeBloc(mockGetHomeCategories, mockGetHomeBusinesses, mockGetHomeAppointments, mockLocalDataSource);
    when(() => mockLocalDataSource.firstName).thenReturn('Test');
  });

  tearDown(() => homeBloc.close());

  test('initial state is HomeInitialState', () {
    expect(homeBloc.state, const HomeInitialState());
  });

  blocTest<HomeBloc, HomeState>(
    'emits [HomeLoadingState, HomeSuccessState] on successful load',
    build: () {
      when(() => mockGetHomeCategories()).thenAnswer((_) async => Right(tCategories));
      when(() => mockGetHomeBusinesses()).thenAnswer((_) async => Right(tBusinesses));
      when(() => mockGetHomeAppointments()).thenAnswer((_) async => Right(tAppointments));
      return homeBloc;
    },
    act: (bloc) => bloc.add(const HomeLoadEvent()),
    expect: () => [
      const HomeLoadingState(),
      HomeSuccessState(
        firstName: 'Test',
        categories: tCategories,
        businesses: tBusinesses,
        appointments: tAppointments,
      ),
    ],
    verify: (_) {
      verify(() => mockGetHomeCategories()).called(1);
      verify(() => mockGetHomeBusinesses()).called(1);
      verify(() => mockGetHomeAppointments()).called(1);
    },
  );

  blocTest<HomeBloc, HomeState>(
    'emits [HomeLoadingState, HomeFailureState] when categories load fails',
    build: () {
      when(() => mockGetHomeCategories()).thenAnswer((_) async => const Left(tFailure));
      when(() => mockGetHomeBusinesses()).thenAnswer((_) async => Right(tBusinesses));
      when(() => mockGetHomeAppointments()).thenAnswer((_) async => Right(tAppointments));
      return homeBloc;
    },
    act: (bloc) => bloc.add(const HomeLoadEvent()),
    expect: () => [const HomeLoadingState(), const HomeFailureState(message: 'Load failed')],
  );

  blocTest<HomeBloc, HomeState>(
    'HomeRefreshEvent triggers reload',
    build: () {
      when(() => mockGetHomeCategories()).thenAnswer((_) async => Right(tCategories));
      when(() => mockGetHomeBusinesses()).thenAnswer((_) async => Right(tBusinesses));
      when(() => mockGetHomeAppointments()).thenAnswer((_) async => Right(tAppointments));
      return homeBloc;
    },
    act: (bloc) => bloc.add(const HomeRefreshEvent()),
    expect: () => [
      const HomeLoadingState(),
      HomeSuccessState(
        firstName: 'Test',
        categories: tCategories,
        businesses: tBusinesses,
        appointments: tAppointments,
      ),
    ],
    verify: (_) {
      verify(() => mockGetHomeCategories()).called(1);
    },
  );

  blocTest<HomeBloc, HomeState>(
    'does not emit new state if already loading',
    build: () {
      when(() => mockGetHomeCategories()).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        return Right(tCategories);
      });
      when(() => mockGetHomeBusinesses()).thenAnswer((_) async => Right(tBusinesses));
      when(() => mockGetHomeAppointments()).thenAnswer((_) async => Right(tAppointments));
      return homeBloc;
    },
    act: (bloc) {
      bloc
        ..add(const HomeLoadEvent())
        ..add(const HomeLoadEvent());
    },
    verify: (_) => verify(() => mockGetHomeCategories()).called(1),
  );
}
