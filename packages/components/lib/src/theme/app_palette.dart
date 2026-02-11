part of 'themes.dart';

/// Single source of truth for all color constants in the app.
///
/// All raw color values are defined here once. [ThemeColors], [ColorScheme],
/// and [ThemeData] component themes must reference these constants
/// instead of using inline `Color(0x...)` literals.
final class AppPalette {
  const AppPalette._();

  // ─── Brand ────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFFE21E25);
  static const Color secondary = Color(0xFF69D7C7);
  static const Color green = Color(0xFF32B141);

  // ─── Primary variants ─────────────────────────────────────────────────
  static const Color primaryContainer = Color(0xFF3700B3);
  static const Color onPrimaryContainer = Color.fromRGBO(15, 184, 211, 0.1);

  // ─── Secondary variants ───────────────────────────────────────────────
  static const Color secondaryContainer = Color(0xFF018786);
  static const Color onSecondaryContainer = Color.fromRGBO(105, 215, 199, 0.1);
  static const Color darkSecondaryContainer = Color(0xFF343434);

  // ─── Error ─────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFD93F2F);
  static const Color darkError = Color(0xFFFF6C6C);
  static const Color onErrorContainer = Color.fromRGBO(217, 63, 47, 0.1);
  static const Color errorLabel = Color(0xFF9F2B44);

  // ─── Surface / Background ─────────────────────────────────────────────
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF27292C);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF1C1E21);
  static const Color backgroundSecondaryDark = Color(0xFF1E1E1E);
  static const Color surfaceContainerHighestDark = Color(0xFF3A3A3A);

  // ─── On‑Surface / Text ────────────────────────────────────────────────
  static const Color onSurfaceLight = Color(0xFF101828);
  static const Color textPrimaryLight = Color(0xFF0A0A0A);
  static const Color black = Color(0xFF000000);
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondary = Color(0xFF909090);
  static const Color onSecondaryDark = Color(0xFF020000);

  // ─── Outline / Border ─────────────────────────────────────────────────
  static const Color outline = Color(0xFFE0E0E0);
  static const Color outlineVariant = Color(0xFF909090);
  static const Color inputBorder = Color(0xFFEEF0F2);

  // ─── Component‑specific ───────────────────────────────────────────────
  static const Color divider = Color(0xFF343434);
  static const Color bottomBarShadow = Color(0xFFE6E9EF);
  static const Color navBarUnselected = Color(0xFF667085);
  static const Color tabLabelLight = Color(0xFF17171C);
  static const Color tabUnselectedLight = Color(0xFFB3BBCD);
  static const Color tabUnselectedDark = Color(0xFFBFBFBF);
  static const Color inputHint = Color(0xFF8C929F);
  static const Color darkAppBarBg = Color.fromRGBO(28, 30, 33, 0.95);
}
