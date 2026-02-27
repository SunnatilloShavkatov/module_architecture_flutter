import 'package:core/core.dart';
import 'package:profile/src/domain/entities/profile_user_entity.dart';
import 'package:profile/src/domain/usecases/get_profile_user.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._getProfileUser, this._di) : super(const ProfileInitialState()) {
    on<ProfileInitialEvent>(_initialHandler);
  }

  final GetProfileUser _getProfileUser;
  final Injector _di;

  Future<void> _initialHandler(ProfileInitialEvent event, Emitter<ProfileState> emit) async {
    if (state is ProfileLoadingState) {
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
}
