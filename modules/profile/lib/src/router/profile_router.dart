import 'package:core/core.dart';
import 'package:navigation/navigation.dart';
import 'package:profile/src/domain/entities/profile_user_entity.dart';
import 'package:profile/src/presentation/edit_profile/edit_profile_page.dart';
import 'package:profile/src/presentation/profile/bloc/profile_bloc.dart';
import 'package:profile/src/presentation/settings/settings_page.dart';
import 'package:profile/src/presentation/settings/sheet/choose_theme_mode_sheet.dart';

final class ProfileRouter implements AppRouter<RouteBase> {
  const ProfileRouter();

  @override
  List<GoRoute> getRouters(Injector di) => [
    GoRoute(
      path: Routes.editProfile,
      name: Routes.editProfile,
      builder: (_, state) {
        final ProfileUserEntity user = state.extra is ProfileUserEntity
            ? state.extra! as ProfileUserEntity
            : const ProfileUserEntity(
                id: 0,
                email: '',
                firstName: '',
                lastName: '',
                role: 'CLIENT',
              );
        return BlocProvider<ProfileBloc>(create: (_) => di.get(), child: EditProfilePage(user: user));
      },
    ),
    GoRoute(path: Routes.settings, name: Routes.settings, builder: (_, _) => const SettingsPage()),
    GoRoute(
      path: Routes.chooseThemeModeSheet,
      name: Routes.chooseThemeModeSheet,
      pageBuilder: (_, state) => MaterialSheetPage(key: state.pageKey, builder: (_) => const ChooseThemeModeSheet()),
    ),
  ];
}
