import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:navigation/navigation.dart';

class ClearNotificationsDialog extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog(
    shape: const RoundedRectangleBorder(borderRadius: Dimensions.kBorderRadius16),
    title: Text(context.l10n.notificationsTitle, style: context.textStyle.defaultW600x20),
    content: Text(
      context.l10n.clearAllNotificationsConfirm,
      style: context.textStyle.defaultW400x14.copyWith(color: context.color.textSecondary),
    ),
    actions: [
      TextButton(
        onPressed: () => context.pop(false),
        child: Text(context.l10n.cancel, style: context.textStyle.defaultW500x14),
      ),
      TextButton(
        onPressed: () => context.pop(true),
        child: Text(
          context.l10n.clearAll,
          style: context.textStyle.defaultW500x14.copyWith(color: context.colorScheme.error),
        ),
      ),
    ],
  );
}
