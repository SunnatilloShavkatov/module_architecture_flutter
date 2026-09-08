import 'package:core/core.dart' show NotificationItemArgs, WidgetFactory;
import 'package:material_ui/material_ui.dart';
import 'package:notifications/src/presentation/notifications/widgets/notification_item.dart';

final class NotificationItemFactory implements WidgetFactory<NotificationItemArgs> {
  const new();

  @override
  Widget create(NotificationItemArgs args) => NotificationItem(args: args);
}
