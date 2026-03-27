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

  final tPackageInfo = PackageInfo(appName: 'TestApp', packageName: 'com.test.app', version: '1.0.0', buildNumber: '1');
  const tUser = ProfileUserEntity(id: 1, email: 'user@test.com', firstName: 'John', lastName: 'Doe', role: 'CLIENT');
  const tFailure = ServerFailure(message: 'Profile load failed');

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

  test('initial state is ProfileInitialState', () {
    expect(profileBloc.state, const ProfileInitialState());
  });

  blocTest<ProfileBloc, ProfileState>(
    'emits [ProfileLoadingState, ProfileSuccessState] on successful load',
    build: () {
      when(() => mockGetProfileUser()).thenAnswer((_) async => const Right(tUser));
      return profileBloc;
    },
    act: (bloc) => bloc.add(const ProfileInitialEvent()),
    expect: () => [const ProfileLoadingState(), ProfileSuccessState(user: tUser, version: tPackageInfo)],
    verify: (_) {
      verify(() => mockGetProfileUser()).called(1);
    },
  );

  blocTest<ProfileBloc, ProfileState>(
    'emits [ProfileLoadingState, ProfileFailureState] on load failure',
    build: () {
      when(() => mockGetProfileUser()).thenAnswer((_) async => const Left(tFailure));
      return profileBloc;
    },
    act: (bloc) => bloc.add(const ProfileInitialEvent()),
    expect: () => [const ProfileLoadingState(), const ProfileFailureState(message: 'Profile load failed')],
  );

  blocTest<ProfileBloc, ProfileState>(
    'emits [ProfileUpdatingState, ProfileUpdatedState] on successful update',
    build: () {
      when(() => mockUpdateProfileUser(any())).thenAnswer((_) async => const Right(tUser));
      return profileBloc;
    },
    act: (bloc) => bloc.add(
      const UpdateProfilePressedEvent(
        username: 'johndoe',
        firstName: 'John',
        lastName: 'Doe',
        phone: '+1234567890',
        specialization: 'Barber',
      ),
    ),
    expect: () => [const ProfileUpdatingState(), ProfileUpdatedState(user: tUser, version: tPackageInfo)],
    verify: (_) {
      verify(() => mockUpdateProfileUser(any())).called(1);
    },
  );

  blocTest<ProfileBloc, ProfileState>(
    'emits [ProfileUpdatingState, ProfileFailureState] on update failure',
    build: () {
      when(() => mockUpdateProfileUser(any())).thenAnswer((_) async => const Left(tFailure));
      return profileBloc;
    },
    act: (bloc) => bloc.add(
      const UpdateProfilePressedEvent(
        username: 'johndoe',
        firstName: 'John',
        lastName: 'Doe',
        phone: '+1234567890',
        specialization: 'Barber',
      ),
    ),
    expect: () => [const ProfileUpdatingState(), const ProfileFailureState(message: 'Profile load failed')],
  );
}
