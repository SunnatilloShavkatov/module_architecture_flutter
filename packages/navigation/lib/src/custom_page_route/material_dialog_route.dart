import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:navigation/src/custom_page_route/material_dialog_page.dart';

/// Dialog route: the builder returns the dialog content, the route wraps it in a [MaterialDialogPage].
final class MaterialDialogRoute extends GoRoute {
  new({
    super.name,
    super.redirect,
    super.routes,
    required super.path,
    super.parentNavigatorKey,
    required Widget Function(BuildContext context, GoRouterState state) builder,
    bool useSafeArea = true,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) : super(
         builder: builder,
         pageBuilder: (BuildContext context, GoRouterState state) => MaterialDialogPage(
           key: state.pageKey,
           useSafeArea: useSafeArea,
           barrierColor: barrierColor,
           name: state.name ?? state.path,
           restorationId: state.pageKey.value,
           barrierDismissible: barrierDismissible,
           arguments: <String, String>{...state.pathParameters, ...state.uri.queryParameters},
           builder: (BuildContext dialogContext) => builder(dialogContext, state),
         ),
       );
}
