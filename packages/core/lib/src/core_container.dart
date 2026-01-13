import 'package:core/src/core_abstractions/app_router.dart';
import 'package:core/src/core_abstractions/injection.dart';
import 'package:core/src/core_abstractions/module_container.dart';
import 'package:core/src/di/core_injection.dart';

final class CoreContainer implements ModuleContainer {
  const CoreContainer();

  @override
  AppRouter<Object>? get router => null;

  @override
  Injection get injection => const CoreInjection();
}
