import 'dart:async';

import 'package:core/src/core_abstractions/injector.dart';

abstract interface class Injection {
  const Injection();

  FutureOr<void> registerDependencies({required Injector di});
}
