part of "utils.dart";

void logMessage(String message, {StackTrace? stackTrace, Object? error}) {
  if (kDebugMode) {
    developer.log(message, stackTrace: stackTrace, error: error);
  }
}
