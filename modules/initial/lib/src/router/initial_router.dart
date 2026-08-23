import 'package:core/core.dart';
import 'package:initial/src/presentation/splash/splash_page.dart';
import 'package:initial/src/presentation/welcome/welcome_page.dart';
import 'package:navigation/navigation.dart';

final class InitialRouter implements AppRouter<RouteBase> {
  const new();

  @override
  List<GoRoute> getRouters(Injector di) => [
    CupertinoRoute(path: Routes.initial, name: Routes.initial, builder: (context, state) => const SplashPage()),
    CupertinoRoute(path: Routes.welcome, name: Routes.welcome, builder: (context, state) => const WelcomePage()),
  ];
}
