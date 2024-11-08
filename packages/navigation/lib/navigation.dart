import "package:core/core.dart";
import "package:flutter/material.dart";

export "package:flutter/material.dart" show Route, RouteSettings;

export "src/router.dart";

GlobalKey<NavigatorState> get coreNavigatorKey => AppInjector.instance.get(instanceName: "navigator_key");
