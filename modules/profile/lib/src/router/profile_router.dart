import 'package:core/core.dart';
import 'package:navigation/navigation.dart';
import 'package:profile/src/presentation/choose_theme_mode_sheet/choose_theme_mode_sheet.dart';
import 'package:profile/src/presentation/edit_profile/args/edit_profile_args.dart';
import 'package:profile/src/presentation/edit_profile/edit_profile_page.dart';
import 'package:profile/src/presentation/profile/bloc/profile_bloc.dart';
import 'package:profile/src/presentation/settings/settings_page.dart';

final class ProfileRouter implements AppRouter<RouteBase> {
  const new();

  @override
  List<GoRoute> getRouters(Injector di) => [
    CupertinoRoute(
      path: Routes.editProfile,
      name: Routes.editProfile,
      builder: (_, state) => BlocProvider<ProfileBloc>(
        create: (_) => di.get(),
        child: EditProfilePage(args: EditProfileArgs.parse(state.extra, queryParameters: state.uri.queryParameters)),
      ),
    ),
    CupertinoRoute(path: Routes.settings, name: Routes.settings, builder: (_, _) => const SettingsPage()),
    MaterialSheetRoute(
      path: Routes.chooseThemeModeSheet,
      name: Routes.chooseThemeModeSheet,
      builder: (_, state) => const ChooseThemeModeSheet(),
    ),
  ];
}
