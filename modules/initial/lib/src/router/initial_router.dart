import 'package:core/core.dart';
import 'package:initial/src/presentation/splash/splash_page.dart';
import 'package:initial/src/presentation/welcome/welcome_page.dart';
import 'package:navigation/navigation.dart';

final class InitialRouter implements AppRouter<RouteBase> {
  const InitialRouter();

  @override
  List<GoRoute> getRouters(Injector di) => [
    GoRoute(path: Routes.initial, name: Routes.initial, builder: (context, state) => const SplashPage()),
    GoRoute(path: Routes.welcome, name: Routes.welcome, builder: (context, state) => const WelcomePage()),
  ];
}
