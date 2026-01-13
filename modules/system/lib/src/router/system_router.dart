import 'package:core/core.dart';
import 'package:navigation/navigation.dart';
import 'package:system/src/presentation/internet_connection/internet_connection_page.dart';

final class SystemRouter implements AppRouter<RouteBase> {
  const SystemRouter();

  @override
  List<GoRoute> getRouters(Injector di) => [
    GoRoute(
      path: Routes.noInternet,
      name: Routes.noInternet,
      builder: (context, state) => const InternetConnectionPage(),
    ),
  ];
}
