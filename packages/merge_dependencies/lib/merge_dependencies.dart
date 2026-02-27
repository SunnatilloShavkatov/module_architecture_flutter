import 'package:auth/auth.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:home/home.dart';
import 'package:initial/initial.dart';
import 'package:main/main.dart';
import 'package:merge_dependencies/src/services/app_navigation_service_impl.dart';
import 'package:navigation/navigation.dart';
import 'package:profile/profile.dart';
import 'package:system/system.dart';

export 'package:components/components.dart';
export 'package:core/core.dart';
export 'package:navigation/navigation.dart';

final class MergeDependencies {
  const MergeDependencies._();

  static MergeDependencies get instance => _instance;

  static const MergeDependencies _instance = MergeDependencies._();

  static bool _isInitialized = false;

  static const List<ModuleContainer> _allContainer = [
    CoreContainer(),
    AuthContainer(),
    HomeContainer(),
    InitialContainer(),
    MainContainer(),
    ProfileContainer(),
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
    if (_isInitialized) {
      return;
    }
    AppInjector.instance.registerLazySingleton<RouteNavigationObserver>(RouteNavigationObserver.new);
    AppInjector.instance.registerLazySingleton<GlobalKey<NavigatorState>>(GlobalKey<NavigatorState>.new);
    AppInjector.instance.registerLazySingleton<AppNavigationService>(
      () => AppNavigationServiceImpl(AppInjector.instance.get(), AppInjector.instance.get()),
    );
    await Future.wait(_injections.map((i) async => i.registerDependencies(di: AppInjector.instance)));
    // final chuck = Chuck(navigatorKey: AppInjector.instance.get<GlobalKey<NavigatorState>>());

    /// Add UI-level interceptors ONLY ONCE
    // AppInjector.instance.get<Dio>().interceptors.add(chuck.dioInterceptor);
    _isInitialized = true;
  }

  static void initEnvironment({required Environment env}) {
    AppEnvironment.instance.initEnvironment(env: env);
  }

  static final GoRouter router = GoRouter(
    initialLocation: Routes.initial,
    errorBuilder: (context, state) => NotFoundPage(settings: state),
    observers: [AppInjector.instance.get<RouteNavigationObserver>()],
    navigatorKey: AppInjector.instance.get<GlobalKey<NavigatorState>>(),
    routes: _allRouters.map((e) => e.getRouters(AppInjector.instance)).expand((e) => e).toList(),
  );
}
