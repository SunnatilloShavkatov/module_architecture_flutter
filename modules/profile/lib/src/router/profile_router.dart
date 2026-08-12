import 'package:core/core.dart';
import 'package:navigation/navigation.dart';
import 'package:profile/src/presentation/choose_theme_mode_sheet/choose_theme_mode_sheet.dart';
import 'package:profile/src/presentation/edit_profile/args/edit_profile_args.dart';
import 'package:profile/src/presentation/edit_profile/edit_profile_page.dart';
import 'package:profile/src/presentation/profile/bloc/profile_bloc.dart';
import 'package:profile/src/presentation/settings/settings_page.dart';

final class ProfileRouter implements AppRouter<RouteBase> {
  const ProfileRouter();

  @override
  List<GoRoute> getRouters(Injector di) => [
    GoRoute(
      path: Routes.editProfile,
      name: Routes.editProfile,
      builder: (_, state) => BlocProvider<ProfileBloc>(
        create: (_) => di.get(),
        child: EditProfilePage(args: state.extra! as EditProfileArgs),
      ),
    ),
    GoRoute(path: Routes.settings, name: Routes.settings, builder: (_, _) => const SettingsPage()),
    GoRoute(
      path: Routes.chooseThemeModeSheet,
      name: Routes.chooseThemeModeSheet,
      pageBuilder: (_, state) => MaterialSheetPage(key: state.pageKey, builder: (_) => const ChooseThemeModeSheet()),
    ),
  ];
}
