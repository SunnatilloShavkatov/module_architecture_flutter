part of 'themes.dart';

/// A set of colors for the entire app.
const ColorScheme colorLightScheme = ColorScheme(
  brightness: Brightness.light,

  /// primary color
  primary: AppPalette.primary,
  onPrimary: Colors.white,
  primaryContainer: AppPalette.primaryContainer,
  onPrimaryContainer: AppPalette.onPrimaryContainer,

  /// secondary color
  secondary: AppPalette.secondary,
  onSecondary: Colors.black,
  secondaryContainer: AppPalette.secondaryContainer,
  onSecondaryContainer: AppPalette.onSecondaryContainer,

  /// error color
  error: AppPalette.error,
  onError: Colors.white,
  onErrorContainer: AppPalette.onErrorContainer,

  /// surface color
  surface: AppPalette.surfaceLight,
  onSurface: AppPalette.onSurfaceLight,
  surfaceContainerHighest: AppPalette.backgroundLight,

  /// outline color
  outline: AppPalette.outline,
  outlineVariant: AppPalette.outlineVariant,
);

///
const ColorScheme colorDarkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: AppPalette.primary,
  onPrimary: Colors.white,
  surface: AppPalette.surfaceDark,
  onSurface: Colors.white,
  secondary: AppPalette.secondary,
  onSecondary: AppPalette.onSecondaryDark,
  error: AppPalette.darkError,
  onError: Colors.white,
  surfaceContainerHighest: AppPalette.surfaceContainerHighestDark,
  secondaryContainer: AppPalette.darkSecondaryContainer,
);

final class ThemeColors extends ThemeExtension<ThemeColors> {
  const ThemeColors({
    required this.primary,
    required this.background,
    required this.onBackground,
    required this.main,
    required this.backgroundSecondary,
    required this.green,
    required this.textPrimary,
    required this.textSecondary,
  });

  final Color primary;
  final Color textPrimary;
  final Color textSecondary;
  final Color background;
  final Color onBackground;
  final Color main;
  final Color backgroundSecondary;
  final Color green;

  static const ThemeColors light = ThemeColors(
    primary: AppPalette.primary,
    background: AppPalette.backgroundLight,
    onBackground: AppPalette.outlineVariant,
    backgroundSecondary: AppPalette.backgroundLight,
    main: AppPalette.surfaceDark,
    green: AppPalette.green,

    /// text
    textPrimary: Color(0xFF000000),
    textSecondary: AppPalette.textSecondary,
  );

  static const ThemeColors dark = ThemeColors(
    primary: AppPalette.primary,
    background: AppPalette.backgroundDark,
    onBackground: AppPalette.outlineVariant,
    backgroundSecondary: AppPalette.backgroundSecondaryDark,

    /// main color
    main: AppPalette.surfaceDark,
    green: AppPalette.green,

    /// text
    textPrimary: AppPalette.textPrimaryDark,
    textSecondary: AppPalette.textSecondary,
  );

  @override
  ThemeExtension<ThemeColors> copyWith({
    Color? primary,
    Color? background,
    Color? onBackground,
    Color? backgroundSecondary,
    Color? main,
    Color? green,
    Color? textPrimary,
    Color? textSecondary,
  }) => ThemeColors(
    primary: primary ?? this.primary,
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
      primary: Color.lerp(primary, other.primary, t)!,
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
