import 'dart:async';

import 'package:core/src/core_abstractions/injector.dart';

abstract class Injection {
  const Injection();

  FutureOr<void> registerDependencies({required Injector di});
}
