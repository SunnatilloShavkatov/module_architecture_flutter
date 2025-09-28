import 'package:flutter/material.dart';
import 'package:main/main.dart';
import 'package:merge_dependencies/merge_dependencies.dart';
import 'package:more/more.dart';
import 'package:others/others.dart';

export 'package:base_dependencies/base_dependencies.dart';
export 'package:core/core.dart';
export 'package:navigation/navigation.dart';

final class MergeDependencies {
  const MergeDependencies._();

  static MergeDependencies get instance => _instance;

  static const MergeDependencies _instance = MergeDependencies._();

  static const List<ModuleContainer> _allContainer = [
    CoreContainer(),
    MainContainer(),
    MoreContainer(),
    OthersContainer(),
  ];

  static final List<Injection> _injections = _allContainer
      .where((c) => c.injection != null)
      .map((c) => c.injection!)
      .toList();

  static final List<AppRouter> _allRouters = _allContainer
      .where((c) => c.router != null)
      .map((c) => c.router!)
      .toList();

  Route<dynamic>? generateRoutes(RouteSettings settings) {
    final Map<String, ModalRoute<dynamic>> routes = {};
    for (int i = 0; i < _allRouters.length; i++) {
      routes.addAll(_allRouters[i].getRoutes(settings, AppInjector.instance));
    }
    return routes[settings.name];
  }

  Route<dynamic>? unknownRoute(RouteSettings settings) =>
      MaterialPageRoute(builder: (_) => NotFoundPage(settings: settings));

  Future<void> registerModules() async =>
      Future.wait(_injections.map((i) async => i.registerDependencies(di: AppInjector.instance)));

  static void initEnvironment({required Environment env}) {
    AppEnvironment.instance.initEnvironment(env: env);
  }
}
