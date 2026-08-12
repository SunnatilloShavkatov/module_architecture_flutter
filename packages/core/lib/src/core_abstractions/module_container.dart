import 'package:core/src/core_abstractions/app_router.dart';
import 'package:core/src/core_abstractions/injection.dart';

abstract interface class ModuleContainer {
  const ModuleContainer();

  Injection? get injection => null;

  AppRouter<Object>? get router => null;
}
