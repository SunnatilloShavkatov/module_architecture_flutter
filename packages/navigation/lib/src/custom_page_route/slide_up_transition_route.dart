import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:navigation/src/custom_page_route/slide_up_transition_page.dart';

/// Full page route that slides in from the bottom, wrapping the builder in a [SlideUpTransitionPage].
final class SlideUpTransitionRoute extends GoRoute {
  new({
    super.name,
    super.redirect,
    super.routes,
    required super.path,
    super.parentNavigatorKey,
    required Widget Function(BuildContext context, GoRouterState state) builder,
  }) : super(
         builder: builder,
         pageBuilder: (BuildContext context, GoRouterState state) => SlideUpTransitionPage<void>(
           key: state.pageKey,
           name: state.name ?? state.path,
           restorationId: state.pageKey.value,
           arguments: <String, String>{...state.pathParameters, ...state.uri.queryParameters},
           child: builder(context, state),
         ),
       );
}
