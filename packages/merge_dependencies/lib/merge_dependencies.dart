import "package:flutter/material.dart";
import "package:main/main.dart";
import "package:merge_dependencies/merge_dependencies.dart";
import "package:more/more.dart";
import "package:others/others.dart";

export "package:base_dependencies/base_dependencies.dart";
export "package:core/core.dart";
export "package:navigation/navigation.dart";

sealed class Merge {
  const Merge._();

  static const List<ModuleContainer> _allContainer = [
    CoreContainer(),
    MainContainer(),
    MoreContainer(),
    OthersContainer(),
  ];

  static List<Injection> get _injections {
    final List<Injection> injections = <Injection>[];
    for (final resolver in _allContainer) {
      if (resolver.injection != null) {
        injections.add(resolver.injection!);
      }
    }
    return injections;
  }

  static List<AppRouter> get _allRouters {
    final List<AppRouter> routers = <AppRouter>[];
    for (final resolver in _allContainer) {
      if (resolver.router != null) {
        routers.add(resolver.router!);
      }
    }
    return routers;
  }

  static Route<dynamic>? generateRoutes(RouteSettings settings) {
    final Map<String, PageRoute> routes = {};
    for (int i = 0; i < _allRouters.length; i++) {
      routes.addAll(_allRouters[i].getRoutes(settings, AppInjector.instance));
    }
    return routes[settings.name];
  }

  static Future<void> registerModules() async {
    for (final injection in _injections) {
      await injection.registerDependencies(di: AppInjector.instance);
    }
  }

  static void initEnvironment({required Environment env}) {
    AppEnvironment.instance.initEnvironment(env: env);
  }

  static Route<dynamic>? unknownRoute(RouteSettings settings) => MaterialPageRoute<void>(
        builder: (_) => NotFoundPage(settings: settings),
      );
}
