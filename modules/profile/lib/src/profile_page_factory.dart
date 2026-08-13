import 'package:core/core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:profile/src/presentation/profile/bloc/profile_bloc.dart';
import 'package:profile/src/presentation/profile/profile_page.dart';

final class ProfilePageFactory implements PageFactory {
  const ProfilePageFactory();

  @override
  Widget create(Injector di) => BlocProvider(
    lazy: false,
    create: (_) => di.get<ProfileBloc>()..add(const ProfileInitialEvent()),
    child: const ProfilePage(),
  );
}
