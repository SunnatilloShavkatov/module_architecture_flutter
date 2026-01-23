import 'package:core/src/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Logging observer for Bloc lifecycle events.
///
/// Logs all Bloc creation, events, state changes, and errors.
/// Uses structured logging format for better filtering.
///
/// **Environment**: Debug mode only.
final class LoggingBlocObserver extends BlocObserver {
  const LoggingBlocObserver();

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    logMessage('[BLOC] ${bloc.runtimeType} | onCreate');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    logMessage('[BLOC] ${bloc.runtimeType} | Event: ${event.runtimeType}');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    logMessage(
      '[BLOC] ${bloc.runtimeType} | '
      '${change.currentState.runtimeType} → ${change.nextState.runtimeType}',
    );
  }

  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);
    logMessage(
      '[BLOC] ${bloc.runtimeType} | '
      'Event: ${transition.event.runtimeType} | '
      '${transition.currentState.runtimeType} → ${transition.nextState.runtimeType}',
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    logMessage('[BLOC] ${bloc.runtimeType} | ERROR: $error', error: error, stackTrace: stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    logMessage('[BLOC] ${bloc.runtimeType} | onClose');
  }
}
