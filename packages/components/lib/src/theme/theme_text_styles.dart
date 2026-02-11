part of 'themes.dart';

final class ThemeTextStyles extends ThemeExtension<ThemeTextStyles> {
  const ThemeTextStyles({
    required this.appBarTitle,
    required this.buttonStyle,
    required this.inputTitleStyle,
    required this.inputHintStyle,
    required this.inputLabelStyle,
    required this.errorLabelStyle,
    required this.defaultW700x14,
    required this.defaultW500x14,
    required this.defaultW600x20,
    required this.defaultW700x12,
    required this.defaultW500x12,
    required this.defaultW600x14,
    required this.defaultW600x18,
    required this.defaultW600x16,
    required this.defaultW400x12,
    required this.defaultW500x13,
    required this.defaultW700x18,
    required this.defaultW700x16,
    required this.defaultW400x14,
    required this.defaultW700x24,
    required this.defaultW400x16,
    required this.defaultW500x16,
    required this.defaultW500x18,
    required this.defaultW500x24,
    required this.defaultW600x24,
  });

  final TextStyle appBarTitle;
  final TextStyle buttonStyle;
  final TextStyle inputTitleStyle;
  final TextStyle inputHintStyle;
  final TextStyle inputLabelStyle;
  final TextStyle errorLabelStyle;
  final TextStyle defaultW700x14;
  final TextStyle defaultW500x14;
  final TextStyle defaultW600x20;
  final TextStyle defaultW700x12;
  final TextStyle defaultW500x12;
  final TextStyle defaultW600x14;
  final TextStyle defaultW600x18;
  final TextStyle defaultW400x12;
  final TextStyle defaultW500x13;
  final TextStyle defaultW400x14;
  final TextStyle defaultW400x16;
  final TextStyle defaultW500x16;
  final TextStyle defaultW600x16;
  final TextStyle defaultW700x16;
  final TextStyle defaultW500x18;
  final TextStyle defaultW700x18;
  final TextStyle defaultW500x24;
  final TextStyle defaultW600x24;
  final TextStyle defaultW700x24;

  static const ThemeTextStyles light = ThemeTextStyles(
    appBarTitle: TextStyle(fontSize: 16, color: AppPalette.textPrimaryLight, fontWeight: FontWeight.w600),
    buttonStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    inputHintStyle: TextStyle(fontSize: 14, color: AppPalette.inputHint, fontWeight: FontWeight.w400),
    inputTitleStyle: TextStyle(fontSize: 12, color: AppPalette.textPrimaryLight, fontWeight: FontWeight.w400),
    inputLabelStyle: TextStyle(fontSize: 16, color: AppPalette.textPrimaryLight, fontWeight: FontWeight.w400),
    errorLabelStyle: TextStyle(fontSize: 14, color: AppPalette.errorLabel, fontWeight: FontWeight.w400),
    defaultW400x12: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    defaultW400x14: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    defaultW400x16: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    defaultW500x12: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    defaultW500x13: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
    defaultW500x14: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    defaultW500x16: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    defaultW500x18: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    defaultW500x24: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
    defaultW600x14: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    defaultW600x16: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    defaultW600x18: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    defaultW600x20: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    defaultW600x24: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
    defaultW700x12: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
    defaultW700x14: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
    defaultW700x16: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    defaultW700x18: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    defaultW700x24: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
  );

  static const ThemeTextStyles dark = ThemeTextStyles(
    appBarTitle: TextStyle(fontSize: 16, color: AppPalette.textPrimaryDark, fontWeight: FontWeight.w600),
    buttonStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    inputHintStyle: TextStyle(color: AppPalette.textPrimaryDark, fontSize: 14, fontWeight: FontWeight.w400),
    inputTitleStyle: TextStyle(color: AppPalette.textPrimaryDark, fontSize: 12, fontWeight: FontWeight.w400),
    inputLabelStyle: TextStyle(color: AppPalette.textPrimaryDark, fontSize: 16, fontWeight: FontWeight.w400),
    errorLabelStyle: TextStyle(color: AppPalette.errorLabel, fontSize: 14, fontWeight: FontWeight.w400),
    defaultW400x12: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    defaultW400x14: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    defaultW400x16: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    defaultW500x12: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    defaultW500x13: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
    defaultW500x14: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    defaultW500x16: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    defaultW500x18: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    defaultW500x24: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
    defaultW600x14: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    defaultW600x16: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    defaultW600x18: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    defaultW600x20: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    defaultW600x24: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
    defaultW700x12: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
    defaultW700x14: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
    defaultW700x16: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    defaultW700x18: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    defaultW700x24: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
  );

  @override
  ThemeExtension<ThemeTextStyles> copyWith({
    TextStyle? appBarTitle,
    TextStyle? buttonStyle,
    TextStyle? defaultW500x14,
    TextStyle? defaultW700x14,
    TextStyle? inputHintStyle,
    TextStyle? inputTitleStyle,
    TextStyle? inputLabelStyle,
    TextStyle? errorLabelStyle,
    TextStyle? defaultW600x20,
    TextStyle? defaultW600x18,
    TextStyle? defaultW700x12,
    TextStyle? defaultW500x12,
    TextStyle? defaultW600x14,
    TextStyle? defaultW400x14,
    TextStyle? defaultW700x16,
    TextStyle? defaultW400x12,
    TextStyle? defaultW600x16,
    TextStyle? defaultW500x13,
    TextStyle? defaultW400x16,
    TextStyle? defaultW500x16,
    TextStyle? defaultW500x18,
    TextStyle? defaultW700x18,
    TextStyle? defaultW500x24,
    TextStyle? defaultW600x24,
    TextStyle? defaultW700x24,
  }) => ThemeTextStyles(
    appBarTitle: appBarTitle ?? this.appBarTitle,
    buttonStyle: buttonStyle ?? this.buttonStyle,
    defaultW500x14: defaultW500x14 ?? this.defaultW500x14,
    defaultW700x14: defaultW700x14 ?? this.defaultW700x14,
    inputHintStyle: inputHintStyle ?? this.inputHintStyle,
    inputTitleStyle: inputTitleStyle ?? this.inputTitleStyle,
    inputLabelStyle: inputLabelStyle ?? this.inputLabelStyle,
    errorLabelStyle: errorLabelStyle ?? this.errorLabelStyle,
    defaultW600x20: defaultW600x20 ?? this.defaultW600x20,
    defaultW600x18: defaultW600x18 ?? this.defaultW600x18,
    defaultW700x12: defaultW700x12 ?? this.defaultW700x12,
    defaultW500x12: defaultW500x12 ?? this.defaultW500x12,
    defaultW600x14: defaultW600x14 ?? this.defaultW600x14,
    defaultW400x14: defaultW400x14 ?? this.defaultW400x14,
    defaultW700x16: defaultW700x16 ?? this.defaultW700x16,
    defaultW400x12: defaultW400x12 ?? this.defaultW400x12,
    defaultW600x16: defaultW600x16 ?? this.defaultW600x16,
    defaultW500x13: defaultW500x13 ?? this.defaultW500x13,
    defaultW700x24: defaultW700x24 ?? this.defaultW700x24,
    defaultW600x24: defaultW600x24 ?? this.defaultW600x24,
    defaultW500x18: defaultW500x18 ?? this.defaultW500x18,
    defaultW700x18: defaultW700x18 ?? this.defaultW700x18,
    defaultW400x16: defaultW400x16 ?? this.defaultW400x16,
    defaultW500x16: defaultW500x16 ?? this.defaultW500x16,
    defaultW500x24: defaultW500x24 ?? this.defaultW500x24,
  );

  @override
  ThemeExtension<ThemeTextStyles> lerp(ThemeExtension<ThemeTextStyles>? other, double t) {
    if (other is! ThemeTextStyles) {
      return this;
    }
    return ThemeTextStyles(
      appBarTitle: TextStyle.lerp(appBarTitle, other.appBarTitle, t)!,
      buttonStyle: TextStyle.lerp(buttonStyle, other.buttonStyle, t)!,
      defaultW500x14: TextStyle.lerp(defaultW500x14, other.defaultW500x14, t)!,
      defaultW700x14: TextStyle.lerp(defaultW700x14, other.defaultW700x14, t)!,
      inputHintStyle: TextStyle.lerp(inputHintStyle, other.inputHintStyle, t)!,
      inputTitleStyle: TextStyle.lerp(inputTitleStyle, other.inputTitleStyle, t)!,
      inputLabelStyle: TextStyle.lerp(inputLabelStyle, other.inputLabelStyle, t)!,
      errorLabelStyle: TextStyle.lerp(errorLabelStyle, other.errorLabelStyle, t)!,
      defaultW600x20: TextStyle.lerp(defaultW600x20, other.defaultW600x20, t)!,
      defaultW600x18: TextStyle.lerp(defaultW600x18, other.defaultW600x18, t)!,
      defaultW700x12: TextStyle.lerp(defaultW700x12, other.defaultW700x12, t)!,
      defaultW500x12: TextStyle.lerp(defaultW500x12, other.defaultW500x12, t)!,
      defaultW600x14: TextStyle.lerp(defaultW600x14, other.defaultW600x14, t)!,
      defaultW400x14: TextStyle.lerp(defaultW400x14, other.defaultW400x14, t)!,
      defaultW700x16: TextStyle.lerp(defaultW700x16, other.defaultW700x16, t)!,
      defaultW400x12: TextStyle.lerp(defaultW400x12, other.defaultW400x12, t)!,
      defaultW600x16: TextStyle.lerp(defaultW600x16, other.defaultW600x16, t)!,
      defaultW500x13: TextStyle.lerp(defaultW500x13, other.defaultW500x13, t)!,
      defaultW700x24: TextStyle.lerp(defaultW700x24, other.defaultW700x24, t)!,
      defaultW600x24: TextStyle.lerp(defaultW600x24, other.defaultW600x24, t)!,
      defaultW500x18: TextStyle.lerp(defaultW500x18, other.defaultW500x18, t)!,
      defaultW700x18: TextStyle.lerp(defaultW700x18, other.defaultW700x18, t)!,
      defaultW400x16: TextStyle.lerp(defaultW400x16, other.defaultW400x16, t)!,
      defaultW500x16: TextStyle.lerp(defaultW500x16, other.defaultW500x16, t)!,
      defaultW500x24: TextStyle.lerp(defaultW500x24, other.defaultW500x24, t)!,
    );
  }
}
