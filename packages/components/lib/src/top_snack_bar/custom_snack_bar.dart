part of 'top_snack_bar.dart';

/// Popup widget that you can use by default to show some information
class CustomSnackBar extends StatelessWidget {
  const new success({
    super.key,
    required this.message,
    this.messagePadding = const EdgeInsets.all(16),
    this.textStyle = const TextStyle(fontSize: 16, color: AppPalette.white, fontWeight: FontWeight.w600),
    this.maxLines = 5,
    this.backgroundColor = AppPalette.shadowSuccessful,
    this.boxShadow = kDefaultBoxShadow,
    this.borderRadius = kDefaultBorderRadius,
    this.textScaler = TextScaler.noScaling,
    this.textAlign = TextAlign.center,
  });

  const new info({
    super.key,
    required this.message,
    this.messagePadding = const EdgeInsets.all(16),
    this.textStyle = const TextStyle(fontSize: 16, color: AppPalette.white, fontWeight: FontWeight.w600),
    this.maxLines = 5,
    this.backgroundColor = AppPalette.primary,
    this.boxShadow = kDefaultBoxShadow,
    this.borderRadius = kDefaultBorderRadius,
    this.textScaler = TextScaler.noScaling,
    this.textAlign = TextAlign.center,
  });

  const new error({
    super.key,
    required this.message,
    this.messagePadding = const EdgeInsets.all(16),
    this.textStyle = const TextStyle(fontSize: 16, color: AppPalette.white, fontWeight: FontWeight.w600),
    this.maxLines = 5,
    this.backgroundColor = AppPalette.error,
    this.boxShadow = kDefaultBoxShadow,
    this.borderRadius = kDefaultBorderRadius,
    this.textScaler = TextScaler.noScaling,
    this.textAlign = TextAlign.center,
  });

  final int maxLines;
  final String message;
  final TextStyle textStyle;
  final Color backgroundColor;
  final List<BoxShadow> boxShadow;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry messagePadding;
  final TextScaler textScaler;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: messagePadding,
      decoration: BoxDecoration(color: backgroundColor, borderRadius: borderRadius, boxShadow: boxShadow),
      child: Text(
        message,
        maxLines: maxLines,
        textAlign: textAlign,
        textScaler: textScaler,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium?.merge(textStyle),
      ),
    );
  }
}

const List<BoxShadow> kDefaultBoxShadow = <BoxShadow>[
  BoxShadow(blurRadius: 30, spreadRadius: 1, offset: Offset(0, 8), color: AppPalette.black26),
];

const BorderRadius kDefaultBorderRadius = BorderRadius.all(Radius.circular(14));
