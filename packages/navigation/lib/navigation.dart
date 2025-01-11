import "package:flutter/material.dart";
import "package:navigation/src/custom_navigation_observer.dart";

export "src/custom_navigation_observer.dart";
export "src/name_routes.dart";

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final CustomNavigatorObserver navigatorObserver = CustomNavigatorObserver();
