part of "utils.dart";

class LogBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log("bloc: $bloc $change");
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    log("bloc: $bloc closed");
  }

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    log("bloc: $bloc created");
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    log("bloc: $bloc $event");
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    log("bloc: $bloc $error");
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    log("bloc: $bloc $transition");
  }
}
