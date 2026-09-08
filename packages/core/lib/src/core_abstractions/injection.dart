import 'dart:async';

import 'package:core/src/core_abstractions/injector.dart';

abstract interface class Injection {
  FutureOr<void> registerDependencies({required Injector di});
}
