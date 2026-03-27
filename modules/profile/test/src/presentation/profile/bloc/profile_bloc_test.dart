import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:profile/src/domain/entities/profile_user_entity.dart';
import 'package:profile/src/domain/usecases/get_profile_user.dart';
import 'package:profile/src/domain/usecases/update_profile_user.dart';
import 'package:profile/src/presentation/profile/bloc/profile_bloc.dart';

class _MockGetProfileUser extends Mock implements GetProfileUser {}

class _MockUpdateProfileUser extends Mock implements UpdateProfileUser {}

class _MockInjector extends Mock implements Injector {}

void main() {
  late ProfileBloc profileBloc;
  late _MockGetProfileUser mockGetProfileUser;
  late _MockUpdateProfileUser mockUpdateProfileUser;
  late _MockInjector mockInjector;

  final tPackageInfo = PackageInfo(
    appName: 'TestApp',
    packageName: 'com.test.app',
    version: '1.0.0',
    buildNumber: '1',
  );
  const tUser = ProfileUserEntity(
    id: 1,
    email: 'user@test.com',
    firstName: 'John',
    lastName: 'Doe',
    role: 'CLIENT',
    phone: '+998901234567',
    username: 'johndoe',
    specialization: 'Barber',
  );
  const tUpdatedUser = ProfileUserEntity(
    id: 1,
    email: 'user@test.com',
    firstName: 'Johnny',
    lastName: 'Doe',
    role: 'CLIENT',
    phone: '+998901234568',
    username: 'johnny',
    specialization: 'Senior Barber',
  );
  const tUpdateEvent = UpdateProfilePressedEvent(
    username: 'johnny',
    firstName: 'Johnny',
    lastName: 'Doe',
    phone: '+998901234568',
    specialization: 'Senior Barber',
  );
  const tServerFailure = ServerFailure(message: 'Profile load failed');
  const tNoInternetFailure = NoInternetFailure(message: 'No internet');

  setUp(() {
    mockGetProfileUser = _MockGetProfileUser();
    mockUpdateProfileUser = _MockUpdateProfileUser();
    mockInjector = _MockInjector();
    profileBloc = ProfileBloc(mockGetProfileUser, mockUpdateProfileUser, mockInjector);
    when(() => mockInjector.getAsync<PackageInfo>()).thenAnswer((_) async => tPackageInfo);
    registerFallbackValue(
      const UpdateProfileUserParams(username: '', firstName: '', lastName: '', phone: '', specialization: ''),
    );
  });

  tearDown(() => profileBloc.close());

  // ─── Initial state ────────────────────────────────────────────────────────────
  test('initial state is ProfileInitialState', () {
    expect(profileBloc.state, const ProfileInitialState());
  });

  // ─── Load success ─────────────────────────────────────────────────────────────
  blocTest<ProfileBloc, ProfileState>(
    'emits [ProfileLoadingState, ProfileSuccessState] on successful load',
    build: () {
      when(() => mockGetProfileUser()).thenAnswer((_) async => const Right(tUser));
      return profileBloc;
    },
    act: (bloc) => bloc.add(const ProfileInitialEvent()),
    expect: () => [
      const ProfileLoadingState(),
      ProfileSuccessState(user: tUser, version: tPackageInfo),
    ],
    verify: (_) => verify(() => mockGetProfileUser()).called(1),
  );

  // ─── Load server failure ──────────────────────────────────────────────────────
  blocTest<ProfileBloc, ProfileState>(
    'emits [ProfileLoadingState, ProfileFailureState] on server failure',
    build: () {
      when(() => mockGetProfileUser()).thenAnswer((_) async => const Left(tServerFailure));
      return profileBloc;
    },
    act: (bloc) => bloc.add(const ProfileInitialEvent()),
    expect: () => [
      const ProfileLoadingState(),
      const ProfileFailureState(message: 'Profile load failed'),
    ],
    verify: (_) => verify(() => mockGetProfileUser()).called(1),
  );

  // ─── Load network failure ─────────────────────────────────────────────────────
  blocTest<ProfileBloc, ProfileState>(
    'emits [ProfileLoadingState, ProfileFailureState] on network failure',
    build: () {
      when(() => mockGetProfileUser()).thenAnswer((_) async => const Left(tNoInternetFailure));
      return profileBloc;
    },
    act: (bloc) => bloc.add(const ProfileInitialEvent()),
    expect: () => [
      const ProfileLoadingState(),
      const ProfileFailureState(message: 'No internet'),
    ],
  );

  // ─── Update success ───────────────────────────────────────────────────────────
  blocTest<ProfileBloc, ProfileState>(
    'emits [ProfileUpdatingState, ProfileUpdatedState] on successful update',
    build: () {
      when(() => mockUpdateProfileUser(any())).thenAnswer((_) async => const Right(tUpdatedUser));
      return profileBloc;
    },
    act: (bloc) => bloc.add(tUpdateEvent),
    expect: () => [
      const ProfileUpdatingState(),
      ProfileUpdatedState(user: tUpdatedUser, version: tPackageInfo),
    ],
    verify: (_) => verify(() => mockUpdateProfileUser(any())).called(1),
  );

  // ─── Update server failure ────────────────────────────────────────────────────
  blocTest<ProfileBloc, ProfileState>(
    'emits [ProfileUpdatingState, ProfileFailureState] on update server failure',
    build: () {
      when(() => mockUpdateProfileUser(any())).thenAnswer((_) async => const Left(tServerFailure));
      return profileBloc;
    },
    act: (bloc) => bloc.add(tUpdateEvent),
    expect: () => [
      const ProfileUpdatingState(),
      const ProfileFailureState(message: 'Profile load failed'),
    ],
    verify: (_) => verify(() => mockUpdateProfileUser(any())).called(1),
  );

  // ─── Update network failure ───────────────────────────────────────────────────
  blocTest<ProfileBloc, ProfileState>(
    'emits [ProfileUpdatingState, ProfileFailureState] on update network failure',
    build: () {
      when(() => mockUpdateProfileUser(any())).thenAnswer((_) async => const Left(tNoInternetFailure));
      return profileBloc;
    },
    act: (bloc) => bloc.add(tUpdateEvent),
    expect: () => [
      const ProfileUpdatingState(),
      const ProfileFailureState(message: 'No internet'),
    ],
  );

  // ─── Load ignored while loading ───────────────────────────────────────────────
  blocTest<ProfileBloc, ProfileState>(
    'ignores ProfileInitialEvent while already loading',
    build: () {
      when(() => mockGetProfileUser()).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        return const Right(tUser);
      });
      return profileBloc;
    },
    act: (bloc) {
      bloc
        ..add(const ProfileInitialEvent())
        ..add(const ProfileInitialEvent());
    },
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const ProfileLoadingState(),
      ProfileSuccessState(user: tUser, version: tPackageInfo),
    ],
    verify: (_) => verify(() => mockGetProfileUser()).called(1),
  );

  // ─── Update ignored while updating ───────────────────────────────────────────
  blocTest<ProfileBloc, ProfileState>(
    'ignores UpdateProfilePressedEvent while already updating',
    build: () {
      when(() => mockUpdateProfileUser(any())).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        return const Right(tUpdatedUser);
      });
      return profileBloc;
    },
    act: (bloc) {
      bloc
        ..add(tUpdateEvent)
        ..add(tUpdateEvent);
    },
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const ProfileUpdatingState(),
      ProfileUpdatedState(user: tUpdatedUser, version: tPackageInfo),
    ],
    verify: (_) => verify(() => mockUpdateProfileUser(any())).called(1),
  );

  // ─── Load ignored while updating ─────────────────────────────────────────────
  blocTest<ProfileBloc, ProfileState>(
    'ignores ProfileInitialEvent while already updating',
    build: () => profileBloc,
    seed: () => const ProfileUpdatingState(),
    act: (bloc) => bloc.add(const ProfileInitialEvent()),
    expect: () => <ProfileState>[],
    verify: (_) => verifyNever(() => mockGetProfileUser()),
  );

  // ─── ProfileSuccessState carries correct data ─────────────────────────────────
  blocTest<ProfileBloc, ProfileState>(
    'ProfileSuccessState contains correct user and version info',
    build: () {
      when(() => mockGetProfileUser()).thenAnswer((_) async => const Right(tUser));
      return profileBloc;
    },
    act: (bloc) => bloc.add(const ProfileInitialEvent()),
    verify: (bloc) {
      final state = bloc.state as ProfileSuccessState;
      expect(state.user.id, 1);
      expect(state.user.email, 'user@test.com');
      expect(state.version.version, '1.0.0');
    },
  );

  // ─── ProfileUpdatedState carries updated user ─────────────────────────────────
  blocTest<ProfileBloc, ProfileState>(
    'ProfileUpdatedState contains the updated user from usecase',
    build: () {
      when(() => mockUpdateProfileUser(any())).thenAnswer((_) async => const Right(tUpdatedUser));
      return profileBloc;
    },
    act: (bloc) => bloc.add(tUpdateEvent),
    verify: (bloc) {
      final state = bloc.state as ProfileUpdatedState;
      expect(state.user.firstName, 'Johnny');
      expect(state.user.username, 'johnny');
      expect(state.user.specialization, 'Senior Barber');
    },
  );

  // ─── PackageInfo fetched for both load and update ────────────────────────────
  blocTest<ProfileBloc, ProfileState>(
    'getAsync<PackageInfo> is called during load',
    build: () {
      when(() => mockGetProfileUser()).thenAnswer((_) async => const Right(tUser));
      return profileBloc;
    },
    act: (bloc) => bloc.add(const ProfileInitialEvent()),
    verify: (_) => verify(() => mockInjector.getAsync<PackageInfo>()).called(1),
  );

  blocTest<ProfileBloc, ProfileState>(
    'getAsync<PackageInfo> is called during update',
    build: () {
      when(() => mockUpdateProfileUser(any())).thenAnswer((_) async => const Right(tUpdatedUser));
      return profileBloc;
    },
    act: (bloc) => bloc.add(tUpdateEvent),
    verify: (_) => verify(() => mockInjector.getAsync<PackageInfo>()).called(1),
  );
}
