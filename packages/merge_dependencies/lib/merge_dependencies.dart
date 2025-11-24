import 'package:auth/auth.dart';
import 'package:initial/initial.dart';
import 'package:main/main.dart';
import 'package:merge_dependencies/merge_dependencies.dart';
import 'package:more/more.dart';
import 'package:system/system.dart';

export 'package:base_dependencies/base_dependencies.dart';
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
    InitialContainer(),
    MainContainer(),
    MoreContainer(),
    SystemContainer(),
  ];

  static final List<Injection> _injections = _allContainer
      .where((c) => c.injection != null)
      .map((c) => c.injection!)
      .toList();

  static final List<AppRouter> _allRouters = _allContainer
      .where((c) => c.router != null)
      .map((c) => c.router!)
      .toList();

  Future<void> registerModules() async =>
      Future.wait(_injections.map((i) async => i.registerDependencies(di: AppInjector.instance)));

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
