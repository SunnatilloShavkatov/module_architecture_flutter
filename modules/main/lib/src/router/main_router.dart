import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:main/src/presentation/main/main_page.dart';
import 'package:material_ui/material_ui.dart';
import 'package:navigation/navigation.dart';

final class MainRouter implements AppRouter<RouteBase> {
  const new();

  @override
  List<RouteBase> getRouters(Injector di) => [
    // Shell branch roots stay plain GoRoute: they are never pushed, the shell swaps them in an IndexedStack,
    // so there is no push transition to lose. Every other page route uses CupertinoRoute (CLAUDE.md section 5b).
    StatefulShellRoute.indexedStack(
      builder: (_, state, navigationShell) => MainPage(key: ObjectKey(state.extra), navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          initialLocation: Routes.mainHome,
          routes: [
            GoRoute(
              path: Routes.mainHome,
              name: Routes.mainHome,
              builder: (_, _) => di.get<PageFactory>(instanceName: InstanceNameKeys.homeFactory).create(di),
            ),
          ],
        ),
        StatefulShellBranch(
          initialLocation: Routes.mainUnits,
          routes: [GoRoute(path: Routes.mainUnits, name: Routes.mainUnits, builder: (_, _) => Dimensions.kZeroBox)],
        ),
        StatefulShellBranch(
          initialLocation: Routes.mainResources,
          routes: [
            GoRoute(
              path: Routes.mainResources,
              name: Routes.mainResources,
              builder: (_, _) => const ModalProgressHUD(inAsyncCall: true, child: Dimensions.kZeroBox),
            ),
          ],
        ),
        StatefulShellBranch(
          initialLocation: Routes.mainMore,
          routes: [
            GoRoute(
              path: Routes.mainMore,
              name: Routes.mainMore,
              builder: (_, _) => di.get<PageFactory>(instanceName: InstanceNameKeys.profileFactory).create(di),
            ),
          ],
        ),
      ],
    ),
  ];
}
