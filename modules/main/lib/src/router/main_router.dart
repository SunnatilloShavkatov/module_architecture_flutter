import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:main/src/presentation/main/main_page.dart';
import 'package:navigation/navigation.dart';

final class MainRouter implements AppRouter<RouteBase> {
  const MainRouter();

  @override
  List<RouteBase> getRouters(Injector di) => [
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
            GoRoute(path: Routes.mainResources, name: Routes.mainResources, builder: (_, _) => Dimensions.kZeroBox),
          ],
        ),
        StatefulShellBranch(
          initialLocation: Routes.mainMore,
          routes: [
            GoRoute(
              path: Routes.mainMore,
              name: Routes.mainMore,
              builder: (_, _) => di.get<PageFactory>(instanceName: InstanceNameKeys.moreFactory).create(di),
            ),
          ],
        ),
      ],
    ),
  ];
}
