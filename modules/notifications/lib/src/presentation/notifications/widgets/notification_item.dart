import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:material_ui/material_ui.dart';

class NotificationItem extends StatelessWidget {
  const new({required this.args, super.key});

  final NotificationItemArgs args;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: args.onTap,
    borderRadius: Dimensions.kBorderRadius12,
    child: Container(
      padding: Dimensions.kPaddingAll16,
      decoration: BoxDecoration(
        color: args.isRead ? context.color.background : context.color.backgroundSecondary,
        borderRadius: Dimensions.kBorderRadius12,
        border: Border.all(color: context.color.onBackground),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Text(
            args.title,
            style: context.textStyle.defaultW600x16.copyWith(
              fontWeight: args.isRead ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          Text(args.message, style: context.textStyle.defaultW400x14.copyWith(color: context.color.textSecondary)),
        ],
      ),
    ),
  );
}
