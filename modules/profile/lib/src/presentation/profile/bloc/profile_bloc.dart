import 'package:core/core.dart';
import 'package:profile/src/domain/entities/profile_user_entity.dart';
import 'package:profile/src/domain/usecases/get_profile_user.dart';
import 'package:profile/src/domain/usecases/update_profile_user.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._getProfileUser, this._updateProfileUser, this._di) : super(const ProfileInitialState()) {
    on<ProfileInitialEvent>(_initialHandler);
    on<UpdateProfilePressedEvent>(_updateProfileHandler);
  }

  final GetProfileUser _getProfileUser;
  final UpdateProfileUser _updateProfileUser;
  final Injector _di;

  Future<void> _initialHandler(ProfileInitialEvent event, Emitter<ProfileState> emit) async {
    if (state is LoadingState) {
      return;
    }
    emit(const ProfileLoadingState());
    final version = await _di.getAsync<PackageInfo>();
    final result = await _getProfileUser();
    result.fold(
      (failure) => emit(ProfileFailureState(message: failure.message)),
      (user) => emit(ProfileSuccessState(user: user, version: version)),
    );
  }

  Future<void> _updateProfileHandler(UpdateProfilePressedEvent event, Emitter<ProfileState> emit) async {
    if (state is LoadingState) {
      return;
    }
    emit(const ProfileUpdatingState());
    final version = await _di.getAsync<PackageInfo>();
    final result = await _updateProfileUser(
      UpdateProfileUserParams(
        username: event.username,
        firstName: event.firstName,
        lastName: event.lastName,
        phone: event.phone,
        specialization: event.specialization,
      ),
    );
    result.fold(
      (failure) => emit(ProfileFailureState(message: failure.message)),
      (user) => emit(ProfileUpdatedState(user: user, version: version)),
    );
  }
}
