import 'package:core/core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:navigation/navigation.dart';
import 'package:notifications/src/presentation/clear_notifications_dialog/clear_notifications_dialog.dart';
import 'package:notifications/src/presentation/notifications/bloc/notifications_bloc.dart';
import 'package:notifications/src/presentation/notifications/notifications_page.dart';
import 'package:notifications/src/presentation/notifications_filter_sheet/notifications_filter_sheet.dart';

final class NotificationsRouter implements AppRouter<RouteBase> {
  const new();

  @override
  List<RouteBase> getRouters(Injector di) => [
    GoRoute(
      path: Routes.notifications,
      name: Routes.notifications,
      builder: (_, _) =>
          BlocProvider<NotificationsBloc>(create: (_) => di.get<NotificationsBloc>(), child: const NotificationsPage()),
    ),
    MaterialSheetRoute(
      path: Routes.notificationsFilterSheet,
      name: Routes.notificationsFilterSheet,
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final selectedFilter = extra?['selectedFilter'] as String? ?? 'All';
        final onFilterSelected = extra?['onFilterSelected'] as ValueChanged<String>? ?? (_) {};
        return NotificationsFilterSheet(selectedFilter: selectedFilter, onFilterSelected: onFilterSelected);
      },
    ),
    MaterialDialogRoute(
      path: Routes.clearNotificationsDialog,
      name: Routes.clearNotificationsDialog,
      builder: (_, _) => const ClearNotificationsDialog(),
    ),
  ];
}
