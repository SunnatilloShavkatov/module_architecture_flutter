import "dart:async";

import "package:core/src/di/injector.dart";

abstract class Injection {
  FutureOr<void> registerDependencies({required Injector di});
}
