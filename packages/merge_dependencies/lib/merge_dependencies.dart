import 'package:auth/auth.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:home/home.dart';
import 'package:initial/initial.dart';
import 'package:main/main.dart';
import 'package:merge_dependencies/src/services/app_navigation_service_impl.dart';
import 'package:more/more.dart';
import 'package:navigation/navigation.dart';
import 'package:system/system.dart';

export 'package:components/components.dart';
export 'package:core/core.dart';
export 'package:navigation/navigation.dart';

final class MergeDependencies {
  const MergeDependencies._();

  static MergeDependencies get instance => _instance;

  static const MergeDependencies _instance = MergeDependencies._();

  static const List<ModuleContainer> _allContainer = [
    CoreContainer(),
    AuthContainer(),
    HomeContainer(),
    InitialContainer(),
    MainContainer(),
    MoreContainer(),
    SystemContainer(),
  ];

  static final List<Injection> _injections = _allContainer
      .where((c) => c.injection != null)
      .map((c) => c.injection!)
      .toList();

  static final List<AppRouter<RouteBase>> _allRouters = _allContainer
      .where((c) => c.router != null && c.router is AppRouter<RouteBase>)
      .map((c) => c.router! as AppRouter<RouteBase>)
      .toList();

  Future<void> registerModules() async {
    AppInjector.instance.registerSingleton<GlobalKey<NavigatorState>>(rootNavigatorKey);
    AppInjector.instance.registerLazySingleton<AppNavigationService>(AppNavigationServiceImpl.new);
    await Future.wait(_injections.map((i) async => i.registerDependencies(di: AppInjector.instance)));

    // Add UI-level interceptors
    AppInjector.instance.get<Dio>().interceptors.add(chuck.dioInterceptor);
  }

  static void initEnvironment({required Environment env}) {
    AppEnvironment.instance.initEnvironment(env: env);
  }

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    observers: [navigatorObserver],
    initialLocation: Routes.initial,
    errorBuilder: (context, state) => NotFoundPage(settings: state),
    routes: _allRouters.map((e) => e.getRouters(AppInjector.instance)).expand((e) => e).toList(),
  );
}
