import 'package:core/core.dart';
import 'package:main/src/presentation/main/main_page.dart';
import 'package:navigation/navigation.dart';

final class MainRouter implements AppRouter {
  const MainRouter();

  @override
  List<GoRoute> getRouters(Injector di) => [
    GoRoute(path: Routes.main, name: Routes.main, builder: (context, state) => const MainPage()),
  ];
}
