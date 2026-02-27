part of 'themes.dart';

const SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  systemNavigationBarColor: Colors.white,
  systemNavigationBarContrastEnforced: false,
  systemNavigationBarDividerColor: Colors.transparent,
  // ios
  statusBarBrightness: Brightness.light,
  // android
  statusBarIconBrightness: Brightness.dark,
  systemNavigationBarIconBrightness: Brightness.dark,
);

const SystemUiOverlayStyle systemDarkUiOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  systemNavigationBarColor: Colors.black,
  systemNavigationBarContrastEnforced: false,
  systemNavigationBarDividerColor: Colors.transparent,
  // ios
  statusBarBrightness: Brightness.dark,
  // android
  statusBarIconBrightness: Brightness.light,
  systemNavigationBarIconBrightness: Brightness.light,
);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  applyElevationOverlayColor: true,
  colorScheme: colorLightScheme,
  cardColor: colorLightScheme.surface,
  visualDensity: VisualDensity.standard,
  canvasColor: colorLightScheme.surface,
  primaryColor: colorLightScheme.primary,
  materialTapTargetSize: MaterialTapTargetSize.padded,
  scaffoldBackgroundColor: ThemeColors.light.background,
  extensions: const [ThemeColors.light, ThemeTextStyles.light],
  splashFactory: Platform.isAndroid ? InkRipple.splashFactory : NoSplash.splashFactory,
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    },
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    linearMinHeight: 3,
    strokeCap: StrokeCap.round,
    color: colorLightScheme.primary,
    linearTrackColor: Colors.transparent,
    circularTrackColor: Colors.transparent,
  ),
  dividerTheme: const DividerThemeData(thickness: 1, color: AppPalette.divider),
  dialogTheme: DialogThemeData(
    backgroundColor: colorLightScheme.surface,
    surfaceTintColor: colorLightScheme.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
  ),
  scrollbarTheme: const ScrollbarThemeData(
    interactive: true,
    radius: Radius.circular(8),
    thickness: WidgetStatePropertyAll(4),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: ThemeColors.light.green,
    foregroundColor: Colors.white,
    elevation: 0,
    focusElevation: 0,
    hoverElevation: 0,
    highlightElevation: 0,
    shape: const CircleBorder(),
  ),
  textButtonTheme: const TextButtonThemeData(style: ButtonStyle(padding: WidgetStatePropertyAll(.zero))),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) => Colors.white),
      backgroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return colorLightScheme.primary.withValues(alpha: 0.4);
        }
        return colorLightScheme.primary;
      }),
      elevation: const WidgetStatePropertyAll(0),
      fixedSize: const WidgetStatePropertyAll(Size.fromHeight(48)),
      textStyle: WidgetStatePropertyAll(ThemeTextStyles.light.buttonStyle),
      shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      elevation: const WidgetStatePropertyAll(0),
      fixedSize: const WidgetStatePropertyAll(Size.fromHeight(48)),
      textStyle: WidgetStatePropertyAll(ThemeTextStyles.light.buttonStyle),
      foregroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) => Colors.black),
      shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    border: const OutlineInputBorder(
      borderRadius: Dimensions.kBorderRadius8,
      borderSide: BorderSide(color: AppPalette.inputBorder),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: Dimensions.kBorderRadius8,
      borderSide: BorderSide(color: AppPalette.inputBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: Dimensions.kBorderRadius8,
      borderSide: BorderSide(color: colorLightScheme.primary),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: Dimensions.kBorderRadius8,
      borderSide: BorderSide(color: colorLightScheme.error),
    ),
    disabledBorder: const OutlineInputBorder(
      borderRadius: Dimensions.kBorderRadius8,
      borderSide: BorderSide(color: AppPalette.inputBorder),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: Dimensions.kBorderRadius8,
      borderSide: BorderSide(color: colorLightScheme.error),
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    elevation: 0,
    showDragHandle: true,
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
    ),
  ),
  bottomAppBarTheme: const BottomAppBarThemeData(
    elevation: 1,
    color: Colors.white,
    surfaceTintColor: Colors.white,
    shadowColor: AppPalette.bottomBarShadow,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    elevation: 0,
    showSelectedLabels: true,
    backgroundColor: AppPalette.bottomNavBgLight,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: colorLightScheme.primary,
    unselectedItemColor: AppPalette.navBarUnselected,
    selectedIconTheme: IconThemeData(color: colorLightScheme.primary, size: 24),
    unselectedIconTheme: const IconThemeData(color: AppPalette.navBarUnselected, size: 24),
    selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
  ),
  tabBarTheme: TabBarThemeData(
    tabAlignment: TabAlignment.start,
    dividerColor: Colors.transparent,
    labelColor: AppPalette.tabLabelLight,
    indicatorColor: colorLightScheme.primary,
    unselectedLabelColor: AppPalette.tabUnselectedLight,
    overlayColor: const WidgetStatePropertyAll(Colors.transparent),
    labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 2.5, color: colorLightScheme.primary)),
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    systemOverlayStyle: systemUiOverlayStyle,
    iconTheme: IconThemeData(color: Colors.black),
    actionsIconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
  ),
  actionIconTheme: ActionIconThemeData(
    backButtonIconBuilder: (context) => IconButton(
      onPressed: () => Navigator.maybePop(context),
      icon: Platform.isAndroid ? const Icon(Icons.arrow_back_rounded) : const Icon(Icons.arrow_back_ios_new_rounded),
    ),
  ),
  listTileTheme: const ListTileThemeData(
    tileColor: Colors.white,
    textColor: Colors.black,
    minVerticalPadding: 0,
    horizontalTitleGap: 10,
    contentPadding: Dimensions.kPaddingHor10,
    style: ListTileStyle.list,
    titleTextStyle: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
  ),
  textTheme: TextTheme(
    /// Display styles
    displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400, color: ThemeColors.light.textPrimary),
    displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400, color: ThemeColors.light.textPrimary),
    displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: ThemeColors.light.textPrimary),

    /// Headline styles
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400, color: ThemeColors.light.textPrimary),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400, color: ThemeColors.light.textPrimary),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: ThemeColors.light.textPrimary),

    /// Title styles (e.g. input field labels and surface headings)
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: ThemeColors.light.textPrimary),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: ThemeColors.light.textPrimary),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: ThemeColors.light.textPrimary),

    /// Body styles for general content and list tiles
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: ThemeColors.light.textPrimary),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: ThemeColors.light.textPrimary),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: ThemeColors.light.textPrimary),

    /// Label styles for chips, buttons, and auxiliary text
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: ThemeColors.light.textPrimary),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: ThemeColors.light.textPrimary),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: ThemeColors.light.textPrimary),
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  applyElevationOverlayColor: true,
  colorScheme: colorDarkScheme,
  cardColor: colorDarkScheme.surface,
  canvasColor: colorDarkScheme.surface,
  shadowColor: AppPalette.divider,
  visualDensity: VisualDensity.standard,
  primaryColor: colorDarkScheme.primary,
  materialTapTargetSize: MaterialTapTargetSize.padded,
  scaffoldBackgroundColor: ThemeColors.dark.background,
  extensions: const [ThemeColors.dark, ThemeTextStyles.dark],
  splashFactory: Platform.isAndroid ? InkRipple.splashFactory : NoSplash.splashFactory,
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    },
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    linearMinHeight: 3,
    strokeCap: StrokeCap.round,
    color: colorDarkScheme.primary,
    linearTrackColor: Colors.transparent,
    circularTrackColor: Colors.transparent,
  ),
  dividerTheme: const DividerThemeData(thickness: 1, color: AppPalette.divider),
  dialogTheme: DialogThemeData(
    backgroundColor: colorDarkScheme.surface,
    surfaceTintColor: colorDarkScheme.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
  ),
  textButtonTheme: const TextButtonThemeData(style: ButtonStyle(padding: WidgetStatePropertyAll(.zero))),
  scrollbarTheme: const ScrollbarThemeData(
    interactive: true,
    radius: Radius.circular(8),
    thickness: WidgetStatePropertyAll(4),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: ThemeColors.dark.green,
    foregroundColor: Colors.white,
    elevation: 0,
    focusElevation: 0,
    hoverElevation: 0,
    highlightElevation: 0,
    shape: const CircleBorder(),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) => Colors.white),
      backgroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return colorDarkScheme.primary.withValues(alpha: 0.4);
        }
        return colorDarkScheme.primary;
      }),
      elevation: const WidgetStatePropertyAll(0),
      fixedSize: const WidgetStatePropertyAll(Size.fromHeight(48)),
      textStyle: WidgetStatePropertyAll(ThemeTextStyles.dark.buttonStyle),
      shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      elevation: const WidgetStatePropertyAll(0),
      fixedSize: const WidgetStatePropertyAll(Size.fromHeight(48)),
      textStyle: WidgetStatePropertyAll(ThemeTextStyles.dark.buttonStyle),
      foregroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) => Colors.white),
      shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    border: const OutlineInputBorder(
      borderRadius: Dimensions.kBorderRadius8,
      borderSide: BorderSide(color: AppPalette.inputBorder),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: Dimensions.kBorderRadius8,
      borderSide: BorderSide(color: AppPalette.inputBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: Dimensions.kBorderRadius8,
      borderSide: BorderSide(color: colorDarkScheme.primary),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: Dimensions.kBorderRadius8,
      borderSide: BorderSide(color: colorDarkScheme.error),
    ),
    disabledBorder: const OutlineInputBorder(
      borderRadius: Dimensions.kBorderRadius8,
      borderSide: BorderSide(color: AppPalette.inputBorder),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: Dimensions.kBorderRadius8,
      borderSide: BorderSide(color: colorDarkScheme.error),
    ),
  ),
  bottomSheetTheme: BottomSheetThemeData(
    elevation: 0,
    showDragHandle: true,
    backgroundColor: ThemeColors.dark.background,
    surfaceTintColor: ThemeColors.dark.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
    ),
  ),
  bottomAppBarTheme: const BottomAppBarThemeData(
    elevation: 1,
    color: AppPalette.surfaceDark,
    surfaceTintColor: AppPalette.surfaceDark,
    shadowColor: AppPalette.divider,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    elevation: 0,
    showSelectedLabels: true,
    backgroundColor: AppPalette.bottomNavBgDark,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: colorDarkScheme.primary,
    unselectedItemColor: AppPalette.navBarUnselected,
    selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
  ),
  tabBarTheme: TabBarThemeData(
    indicatorColor: colorDarkScheme.primary,
    labelColor: Colors.white,
    dividerHeight: 0,
    unselectedLabelColor: AppPalette.tabUnselectedDark,
    tabAlignment: TabAlignment.start,
    labelPadding: Dimensions.kPaddingHor6,
    dividerColor: Colors.transparent,
    overlayColor: const WidgetStatePropertyAll(Colors.transparent),
    labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
    unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
    indicatorSize: TabBarIndicatorSize.label,
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    systemOverlayStyle: systemDarkUiOverlayStyle,
    iconTheme: IconThemeData(color: Colors.white),
    backgroundColor: AppPalette.darkAppBarBg,
    surfaceTintColor: AppPalette.darkAppBarBg,
    titleTextStyle: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
  ),
  actionIconTheme: ActionIconThemeData(
    backButtonIconBuilder: (context) => IconButton(
      onPressed: () => Navigator.maybePop(context),
      icon: Platform.isAndroid ? const Icon(Icons.arrow_back_rounded) : const Icon(Icons.arrow_back_ios_new_rounded),
    ),
  ),
  listTileTheme: ListTileThemeData(
    minVerticalPadding: 0,
    horizontalTitleGap: 10,
    contentPadding: Dimensions.kPaddingHor10,
    tileColor: colorDarkScheme.surface,
    style: ListTileStyle.list,
    titleTextStyle: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
  ),
  textTheme: TextTheme(
    /// Display styles
    displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400, color: ThemeColors.dark.textPrimary),
    displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400, color: ThemeColors.dark.textPrimary),
    displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: ThemeColors.dark.textPrimary),

    /// Headline styles
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400, color: ThemeColors.dark.textPrimary),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400, color: ThemeColors.dark.textPrimary),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: ThemeColors.dark.textPrimary),

    /// Title styles (e.g. input field labels and surface headings)
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: ThemeColors.dark.textPrimary),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: ThemeColors.dark.textPrimary),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: ThemeColors.dark.textPrimary),

    /// Body styles for general content and list tiles
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: ThemeColors.dark.textPrimary),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: ThemeColors.dark.textPrimary),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: ThemeColors.dark.textPrimary),

    /// Label styles for chips, buttons, and auxiliary text
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: ThemeColors.dark.textPrimary),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: ThemeColors.dark.textPrimary),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: ThemeColors.dark.textPrimary),
  ),
);
