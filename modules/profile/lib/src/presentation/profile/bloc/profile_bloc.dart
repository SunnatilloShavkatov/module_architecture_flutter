import 'package:core/core.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._di) : super(const ProfileInitialState()) {
    on<GetPackageVersionEvent>(_getPackageVersionHandler);
  }

  final Injector _di;

  Future<void> _getPackageVersionHandler(GetPackageVersionEvent event, Emitter<ProfileState> emit) async {
    final version = await _di.getAsync<PackageInfo>();
    emit(PackageVersionState(version: version));
  }
}
