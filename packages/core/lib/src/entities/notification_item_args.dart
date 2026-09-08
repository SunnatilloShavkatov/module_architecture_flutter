import 'package:material_ui/material_ui.dart';

/// Cross-module argument bundle for rendering a notification item via `WidgetFactory`.
final class NotificationItemArgs {
  const new({required this.id, required this.title, required this.message, required this.isRead, this.onTap});

  final String id;
  final String title;
  final String message;
  final bool isRead;
  final VoidCallback? onTap;
}
