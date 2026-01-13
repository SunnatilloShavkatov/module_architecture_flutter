import 'package:core/core.dart';

part 'more_event.dart';

part 'more_state.dart';

class MoreBloc extends Bloc<MoreEvent, MoreState> {
  MoreBloc(this._di) : super(const MoreInitialState()) {
    on<GetPackageVersionEvent>(_getPackageVersionHandler);
  }

  final Injector _di;

  Future<void> _getPackageVersionHandler(GetPackageVersionEvent event, Emitter<MoreState> emit) async {
    final version = await _di.getAsync<PackageInfo>();
    emit(PackageVersionState(version: version));
  }
}
