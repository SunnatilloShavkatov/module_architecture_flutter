part of "extension.dart";

extension SizeExtension on BuildContext {
  bool get isMobile => kSize.width < 600 && (Platform.isAndroid || Platform.isIOS);

  bool get isTablet => kSize.width > 600 && (Platform.isAndroid || Platform.isIOS);

  Size get kSize => MediaQuery.sizeOf(this);

  double get width => MediaQuery.sizeOf(this).width;

  double get height => MediaQuery.sizeOf(this).height;

  EdgeInsets get padding => MediaQuery.paddingOf(this);

  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);

  double get devicePixelRatio => MediaQuery.devicePixelRatioOf(this);
}
