part of "themes.dart";

const SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  systemNavigationBarColor: Colors.white,
  // ios
  statusBarBrightness: Brightness.light,
  // android
  statusBarIconBrightness: Brightness.dark,
  systemNavigationBarIconBrightness: Brightness.dark,
);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  applyElevationOverlayColor: true,
  extensions: const <ThemeExtension<dynamic>>[
    ThemeColors.light,
    ThemeGradients.light,
    ThemeTextStyles.light,
    ThemeCustomShapes.light,
  ],
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  colorScheme: colorLightScheme,
  cardColor: colorLightScheme.surface,
  visualDensity: VisualDensity.standard,
  canvasColor: colorLightScheme.surface,
  primaryColor: colorLightScheme.primary,
  dialogBackgroundColor: colorLightScheme.surface,
  materialTapTargetSize: MaterialTapTargetSize.padded,
  scaffoldBackgroundColor: ThemeColors.light.background,
  splashFactory: Platform.isAndroid ? InkRipple.splashFactory : NoSplash.splashFactory,
  progressIndicatorTheme: ProgressIndicatorThemeData(
    linearMinHeight: 3,
    color: colorLightScheme.primary,
    circularTrackColor: Colors.white,
  ),
  dividerTheme: const DividerThemeData(
    thickness: 1,
    color: Color(0xFF343434),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: colorLightScheme.surface,
    surfaceTintColor: colorLightScheme.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
  ),
  scrollbarTheme: const ScrollbarThemeData(
    interactive: true,
    thickness: WidgetStatePropertyAll<double>(5),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    elevation: 1,
    color: Colors.white,
    surfaceTintColor: Colors.white,
    shadowColor: Color(0xFFE6E9EF),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF32B141),
    foregroundColor: Colors.white,
    elevation: 0,
    focusElevation: 0,
    hoverElevation: 0,
    highlightElevation: 0,
    shape: CircleBorder(),
  ),
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.zero)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) => Colors.white,
      ),
      backgroundColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return colorLightScheme.primary.withOpacity(0.4);
          }
          return colorLightScheme.primary;
        },
      ),
      textStyle: WidgetStatePropertyAll<TextStyle>(
        ThemeTextStyles.light.buttonStyle,
      ),
      elevation: const WidgetStatePropertyAll<double>(0),
      shape: const WidgetStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      fixedSize: const WidgetStatePropertyAll<Size>(Size.fromHeight(48)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) => Colors.black,
      ),
      textStyle: WidgetStatePropertyAll<TextStyle>(
        ThemeTextStyles.light.buttonStyle,
      ),
      elevation: const WidgetStatePropertyAll<double>(0),
      shape: const WidgetStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      fixedSize: const WidgetStatePropertyAll<Size>(Size.fromHeight(48)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    border: const OutlineInputBorder(
      borderRadius: Dimensions.kBorderRadius8,
      borderSide: BorderSide(color: Color(0xFFEEF0F2)),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: Dimensions.kBorderRadius8,
      borderSide: BorderSide(color: Color(0xFFEEF0F2)),
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
      borderSide: BorderSide(color: Color(0xFFEEF0F2)),
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
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    elevation: 0,
    showSelectedLabels: true,
    backgroundColor: Colors.white,
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
    unselectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
    selectedItemColor: Colors.white,
    unselectedItemColor: Color(0xFF69D7C7),
  ),
  tabBarTheme: TabBarTheme(
    tabAlignment: TabAlignment.start,
    indicatorColor: colorLightScheme.primary,
    labelColor: const Color(0xFF17171C),
    unselectedLabelColor: const Color(0xFFB3BBCD),
    dividerColor: Colors.transparent,
    overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
    labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 2.5, color: colorLightScheme.primary)),
  ),
  navigationBarTheme: NavigationBarThemeData(
    elevation: 0,
    backgroundColor: Colors.white,
    height: kToolbarHeight,
    iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
      (Set<WidgetState> states) => const IconThemeData(
        color: Colors.black,
      ),
    ),
    labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
      (Set<WidgetState> states) => ThemeTextStyles.light.appBarTitle,
    ),
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    systemOverlayStyle: systemUiOverlayStyle,
    iconTheme: const IconThemeData(color: Colors.black),
    actionsIconTheme: const IconThemeData(color: Colors.black),
    titleTextStyle: const TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.w500,
    ),
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    toolbarTextStyle: ThemeTextStyles.light.appBarTitle,
  ),
  actionIconTheme: ActionIconThemeData(
    backButtonIconBuilder: (BuildContext context) => IconButton(
      onPressed: () => Navigator.maybePop(context),
      icon: Platform.isAndroid ? const Icon(Icons.arrow_back_rounded) : const Icon(Icons.arrow_back_ios_new_rounded),
    ),
  ),
  listTileTheme: const ListTileThemeData(
    tileColor: Colors.white,
    textColor: Colors.black,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 34,
      color: Colors.black,
      fontWeight: FontWeight.w400,
    ),

    /// text field title style
    titleMedium: TextStyle(
      fontSize: 17,
      color: Colors.black,
      fontWeight: FontWeight.w400,
    ),
    titleSmall: TextStyle(
      fontSize: 17,
      color: Colors.black,
      fontWeight: FontWeight.w400,
    ),

    /// list tile title style
    bodyLarge: TextStyle(
      fontSize: 20,
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),

    /// list tile subtitle style
    bodyMedium: TextStyle(
      fontSize: 17,
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    bodySmall: TextStyle(
      fontSize: 15,
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    displayLarge: TextStyle(
      color: Colors.black,
    ),
    displayMedium: TextStyle(
      fontSize: 17,
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    displaySmall: TextStyle(color: Colors.black),

    /// label style
    labelLarge: TextStyle(
      fontSize: 34,
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  applyElevationOverlayColor: true,
  extensions: const <ThemeExtension<dynamic>>[
    ThemeColors.dark,
    ThemeGradients.dark,
    ThemeTextStyles.dark,
    ThemeCustomShapes.dark,
  ],
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  splashFactory: Platform.isAndroid ? InkRipple.splashFactory : NoSplash.splashFactory,
  visualDensity: VisualDensity.standard,
  materialTapTargetSize: MaterialTapTargetSize.padded,
  primaryColor: colorDarkScheme.primary,
  colorScheme: colorDarkScheme,
  dialogBackgroundColor: colorDarkScheme.surface,
  scaffoldBackgroundColor: ThemeColors.dark.background,
  cardColor: colorDarkScheme.surface,
  canvasColor: colorDarkScheme.surface,
  shadowColor: const Color(0xFF343434),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Colors.white,
    linearMinHeight: 2,
    linearTrackColor: Colors.transparent,
    circularTrackColor: Colors.transparent,
  ),
  dividerTheme: const DividerThemeData(
    thickness: 1,
    color: Color(0xFF343434),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: colorDarkScheme.surface,
    surfaceTintColor: colorDarkScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  ),
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.zero),
    ),
  ),
  scrollbarTheme: ScrollbarThemeData(
    interactive: true,
    thumbColor: WidgetStatePropertyAll<Color>(
      ThemeColors.light.main,
    ),
    thickness: const WidgetStatePropertyAll<double>(5),
    minThumbLength: 100,
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    elevation: 1,
    color: Colors.white,
    surfaceTintColor: Colors.white,
    shadowColor: Color(0xFFE6E9EF),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF32B141),
    foregroundColor: Colors.white,
    elevation: 0,
    focusElevation: 0,
    hoverElevation: 0,
    highlightElevation: 0,
    shape: CircleBorder(),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) => Colors.white,
      ),
      backgroundColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return colorDarkScheme.primary.withOpacity(0.4);
          }
          return colorDarkScheme.primary;
        },
      ),
      textStyle: WidgetStatePropertyAll<TextStyle>(ThemeTextStyles.dark.buttonStyle),
      elevation: const WidgetStatePropertyAll<double>(0),
      shape: const WidgetStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      fixedSize: const WidgetStatePropertyAll<Size>(Size.fromHeight(48)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) => Colors.black,
      ),
      textStyle: WidgetStatePropertyAll<TextStyle>(
        ThemeTextStyles.dark.buttonStyle,
      ),
      elevation: const WidgetStatePropertyAll<double>(0),
      shape: const WidgetStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      fixedSize: const WidgetStatePropertyAll<Size>(Size.fromHeight(48)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    border: const OutlineInputBorder(
      borderRadius: Dimensions.kBorderRadius8,
      borderSide: BorderSide(color: Color(0xFFEEF0F2)),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: Dimensions.kBorderRadius8,
      borderSide: BorderSide(color: Color(0xFFEEF0F2)),
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
      borderSide: BorderSide(color: Color(0xFFEEF0F2)),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: Dimensions.kBorderRadius8,
      borderSide: BorderSide(color: colorDarkScheme.error),
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    elevation: 0,
    showDragHandle: true,
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    elevation: 0,
    backgroundColor: const Color.fromRGBO(28, 30, 33, 0.95),
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: true,
    selectedLabelStyle: const TextStyle(
      fontSize: 12,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
    unselectedLabelStyle: const TextStyle(
      fontSize: 12,
      color: Color(0xFF909090),
      fontWeight: FontWeight.w500,
    ),
    unselectedItemColor: const Color(0xFF909090),
    selectedItemColor: colorDarkScheme.onPrimary,
    selectedIconTheme: IconThemeData(color: colorDarkScheme.primary),
  ),
  tabBarTheme: TabBarTheme(
    indicatorColor: colorDarkScheme.primary,
    labelColor: Colors.white,
    dividerHeight: 0,
    unselectedLabelColor: const Color(0xFFBFBFBF),
    tabAlignment: TabAlignment.start,
    labelPadding: Dimensions.kPaddingHor6,
    dividerColor: Colors.transparent,
    overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
    labelStyle: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
    unselectedLabelStyle: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
    indicatorSize: TabBarIndicatorSize.label,
  ),
  navigationBarTheme: NavigationBarThemeData(
    elevation: 0,
    backgroundColor: Colors.white,
    height: kToolbarHeight,
    iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
      (Set<WidgetState> states) => const IconThemeData(
        color: Colors.black,
      ),
    ),
    labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
      (Set<WidgetState> states) => ThemeTextStyles.dark.appBarTitle,
    ),
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    systemOverlayStyle: systemUiOverlayStyle,
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: const TextStyle(
      fontSize: 15,
      height: 20 / 15,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
    toolbarTextStyle: ThemeTextStyles.dark.appBarTitle,
    backgroundColor: const Color.fromRGBO(28, 30, 33, 0.95),
    surfaceTintColor: const Color.fromRGBO(28, 30, 33, 0.95),
  ),
  actionIconTheme: ActionIconThemeData(
    backButtonIconBuilder: (BuildContext context) => IconButton(
      onPressed: () => Navigator.maybePop(context),
      icon: Platform.isAndroid ? const Icon(Icons.arrow_back) : const Icon(Icons.arrow_back_ios_new_rounded),
    ),
  ),
  listTileTheme: const ListTileThemeData(
    minVerticalPadding: 0,
    horizontalTitleGap: 10,
    contentPadding: Dimensions.kPaddingHor10,
    tileColor: Color(0xFF27292C),
    style: ListTileStyle.list,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    titleTextStyle: TextStyle(
      fontSize: 14,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 34,
    ),

    /// text field title style
    titleMedium: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 17,
    ),
    titleSmall: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 17,
    ),

    /// list tile title style
    bodyLarge: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),

    /// list tile subtitle style
    bodyMedium: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 17,
    ),
    bodySmall: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 15,
    ),
    displayLarge: TextStyle(
      color: Colors.white,
    ),
    displayMedium: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 17,
    ),
    displaySmall: TextStyle(
      color: Colors.white,
    ),
  ),
);
