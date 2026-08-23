import 'dart:async';

import 'package:core/src/core_abstractions/injector.dart';

abstract interface class Injection {
  const new();

  FutureOr<void> registerDependencies({required Injector di});
}
