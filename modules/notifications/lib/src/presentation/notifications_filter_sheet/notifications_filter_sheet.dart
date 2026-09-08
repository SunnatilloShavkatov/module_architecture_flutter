import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:navigation/navigation.dart';
import 'package:notifications/src/presentation/notifications_filter_sheet/args/notifications_filter_args.dart';

class NotificationsFilterSheet extends StatelessWidget {
  const new({required this.args, super.key});

  final NotificationsFilterArgs args;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: Dimensions.kPaddingAll16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Text(context.l10n.notificationsTitle, style: context.textStyle.defaultW600x20),
          Dimensions.kGap8,
          for (final filter in NotificationsFilterArgs.availableFilters)
            ListTile(
              title: Text(_label(context, filter), style: context.textStyle.defaultW400x16),
              trailing: args.selectedFilter == filter ? Icon(Icons.check, color: context.color.primary) : null,
              // The sheet returns its result through pop — no callback is passed through `extra`.
              onTap: () => context.pop(filter),
            ),
        ],
      ),
    ),
  );

  String _label(BuildContext context, String filter) => switch (filter) {
    NotificationsFilterArgs.unread => context.l10n.filterUnread,
    NotificationsFilterArgs.read => context.l10n.filterRead,
    _ => context.l10n.filterAll,
  };
}
