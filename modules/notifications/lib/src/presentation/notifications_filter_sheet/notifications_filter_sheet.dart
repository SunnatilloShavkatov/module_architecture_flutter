import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:material_ui/material_ui.dart';

class NotificationsFilterSheet extends StatelessWidget {
  const new({required this.selectedFilter, required this.onFilterSelected, super.key});

  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

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
          for (final filter in ['All', 'Unread', 'Read'])
            ListTile(
              title: Text(filter, style: context.textStyle.defaultW400x16),
              trailing: selectedFilter == filter ? Icon(Icons.check, color: context.color.primary) : null,
              onTap: () {
                onFilterSelected(filter);
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    ),
  );
}
