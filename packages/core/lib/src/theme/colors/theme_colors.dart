part of "package:core/src/theme/themes.dart";

/// A set of colors for the entire app.
const ColorScheme colorLightScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF2277F6),
  onPrimary: Colors.white,
  surface: Color(0xFF27292C),
  onSurface: Colors.white,
  secondary: Color(0xFF69D7C7),
  onSecondary: Color(0xFF020000),
  error: Color(0xFFFF6C6C),
  onError: Colors.white,
  surfaceContainerHighest: Color(0xFFF5F5F5),
  secondaryContainer: Color(0xFF343434),
);

///
const ColorScheme colorDarkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF2277F6),
  onPrimary: Colors.white,
  surface: Color(0xFF27292C),
  onSurface: Colors.white,
  secondary: Color(0xFF69D7C7),
  onSecondary: Color(0xFF020000),
  error: Color(0xFFFF6C6C),
  onError: Colors.white,
  surfaceContainerHighest: Color(0xFFF5F5F5),
  secondaryContainer: Color(0xFF343434),
);

class ThemeColors extends ThemeExtension<ThemeColors> {
  const ThemeColors({
    required this.background,
    required this.onBackground,
    required this.main,
    required this.cardColor,
    required this.green,
    required this.whiteOpacity05,
    required this.whiteOpacity5,
  });

  final Color background;
  final Color onBackground;
  final Color main;
  final Color cardColor;
  final Color green;
  final Color whiteOpacity05;
  final Color whiteOpacity5;

  static const ThemeColors light = ThemeColors(
    background: Color(0xFF1C1E21),
    onBackground: Color(0xFF909090),
    main: Color(0xFF27292C),
    green: Color(0xFF32B141),
    cardColor: Colors.white,
    whiteOpacity05: Color.fromRGBO(255, 255, 255, 0.05),
    whiteOpacity5: Color.fromRGBO(255, 255, 255, 0.5),
  );

  static const ThemeColors dark = ThemeColors(
    background: Color(0xFF1C1E21),
    onBackground: Color(0xFF909090),
    main: Color(0xFF27292C),
    green: Color(0xFF32B141),
    cardColor: Color(0xFF1E1E1E),
    whiteOpacity05: Color.fromRGBO(255, 255, 255, 0.05),
    whiteOpacity5: Color.fromRGBO(255, 255, 255, 0.5),
  );

  @override
  ThemeExtension<ThemeColors> copyWith({
    Color? background,
    Color? onBackground,
    Color? cardColor,
    Color? main,
    Color? green,
    Color? whiteOpacity05,
    Color? whiteOpacity5,
  }) =>
      ThemeColors(
        background: background ?? this.background,
        onBackground: onBackground ?? this.onBackground,
        green: green ?? this.green,
        cardColor: cardColor ?? this.cardColor,
        main: main ?? this.main,
        whiteOpacity05: whiteOpacity05 ?? this.whiteOpacity05,
        whiteOpacity5: whiteOpacity5 ?? this.whiteOpacity5,
      );

  @override
  ThemeExtension<ThemeColors> lerp(
    ThemeExtension<ThemeColors>? other,
    double t,
  ) {
    if (other is! ThemeColors) {
      return this;
    }
    return ThemeColors(
      background: Color.lerp(background, other.background, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      whiteOpacity5: Color.lerp(whiteOpacity5, other.whiteOpacity5, t)!,
      green: Color.lerp(green, other.green, t)!,
      main: Color.lerp(main, other.main, t)!,
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
      whiteOpacity05: Color.lerp(whiteOpacity05, other.whiteOpacity05, t)!,
    );
  }
}
