import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:navigation/src/custom_navigation_observer.dart";
import "package:navigation/src/router.dart";

export "package:flutter/material.dart" show Route, RouteSettings;
export "src/custom_navigation_observer.dart";
export "src/router.dart";

GlobalKey<NavigatorState> get coreNavigatorKey => AppInjector.instance.get(instanceName: RouteKeys.navigatorKey);

CustomNavigatorObserver get navigatorObserver => AppInjector.instance.get(instanceName: RouteKeys.navigatorObserver);
