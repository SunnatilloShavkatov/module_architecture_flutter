import 'package:core/src/core_abstractions/app_router.dart';
import 'package:core/src/core_abstractions/injection.dart';

abstract class ModuleContainer {
  const ModuleContainer();

  AppRouter? get router => null;

  Injection? get injection => null;
}
