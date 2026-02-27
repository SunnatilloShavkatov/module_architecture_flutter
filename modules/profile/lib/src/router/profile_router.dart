import 'package:core/core.dart';
import 'package:navigation/navigation.dart';
import 'package:profile/src/presentation/settings/settings_page.dart';
import 'package:profile/src/presentation/settings/sheet/choose_theme_mode_sheet.dart';

final class ProfileRouter implements AppRouter<RouteBase> {
  const ProfileRouter();

  @override
  List<GoRoute> getRouters(Injector di) => [
    GoRoute(path: Routes.settings, name: Routes.settings, builder: (_, _) => const SettingsPage()),
    GoRoute(
      path: Routes.chooseThemeModeSheet,
      name: Routes.chooseThemeModeSheet,
      pageBuilder: (_, state) => MaterialSheetPage(key: state.pageKey, builder: (_) => const ChooseThemeModeSheet()),
    ),
  ];
}
