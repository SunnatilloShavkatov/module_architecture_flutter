import 'package:core/src/core_abstractions/app_router.dart';
import 'package:core/src/core_abstractions/injection.dart';

abstract interface class ModuleContainer {
  const ModuleContainer();

  AppRouter<Object>? get router => null;

  Injection? get injection => null;
}
