part of 'package:core/src/theme/themes.dart';

/// A set of colors for the entire app.
const ColorScheme colorLightScheme = ColorScheme(
  brightness: Brightness.light,

  /// primary color
  primary: Color(0xFFE21E25),
  onPrimary: Colors.white,
  primaryContainer: Color(0xFF3700B3),
  onPrimaryContainer: Color.fromRGBO(15, 184, 211, 0.1),

  /// secondary color
  secondary: Color(0xFF69D7C7),
  onSecondary: Colors.black,
  secondaryContainer: Color(0xFF018786),
  onSecondaryContainer: Color.fromRGBO(105, 215, 199, 0.1),

  /// error color
  error: Color(0xFFD93F2F),
  onError: Colors.white,
  onErrorContainer: Color.fromRGBO(217, 63, 47, 0.1),

  /// surface color
  surface: Colors.white,
  onSurface: Color(0xFF101828),
  surfaceContainerHighest: Color(0xFFF5F5F5),

  /// outline color
  outline: Color(0xFFE0E0E0),
  outlineVariant: Color(0xFF909090),
);

///
const ColorScheme colorDarkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFE21E25),
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

final class ThemeColors extends ThemeExtension<ThemeColors> {
  const ThemeColors({
    required this.background,
    required this.onBackground,
    required this.main,
    required this.backgroundSecondary,
    required this.green,
    required this.textPrimary,
    required this.textSecondary,
  });

  final Color textPrimary;
  final Color textSecondary;
  final Color background;
  final Color onBackground;
  final Color main;
  final Color backgroundSecondary;
  final Color green;

  static const ThemeColors light = ThemeColors(
    background: Color(0xFFF5F5F5),
    onBackground: Color(0xFF909090),
    backgroundSecondary: Color(0xFFF5F5F5),
    main: Color(0xFF27292C),
    green: Color(0xFF32B141),

    /// text
    textPrimary: Color(0xFF000000),
    textSecondary: Color(0xFF909090),
  );

  static const ThemeColors dark = ThemeColors(
    background: Color(0xFF1C1E21),
    onBackground: Color(0xFF909090),
    backgroundSecondary: Color(0xFF1E1E1E),

    /// main color
    main: Color(0xFF27292C),
    green: Color(0xFF32B141),

    /// text
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF909090),
  );

  @override
  ThemeExtension<ThemeColors> copyWith({
    Color? background,
    Color? onBackground,
    Color? backgroundSecondary,
    Color? main,
    Color? green,
    Color? textPrimary,
    Color? textSecondary,
  }) => ThemeColors(
    background: background ?? this.background,
    onBackground: onBackground ?? this.onBackground,
    backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
    main: main ?? this.main,
    green: green ?? this.green,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
  );

  @override
  ThemeExtension<ThemeColors> lerp(ThemeExtension<ThemeColors>? other, double t) {
    if (other is! ThemeColors) {
      return this;
    }
    return ThemeColors(
      background: Color.lerp(background, other.background, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      backgroundSecondary: Color.lerp(backgroundSecondary, other.backgroundSecondary, t)!,
      main: Color.lerp(main, other.main, t)!,
      green: Color.lerp(green, other.green, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
    );
  }
}
