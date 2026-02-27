import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:profile/src/presentation/profile/bloc/profile_bloc.dart';
import 'package:profile/src/presentation/profile/profile_page.dart';

final class ProfilePageFactory implements PageFactory {
  const ProfilePageFactory();

  @override
  Widget create(Injector di) => BlocProvider(
    lazy: false,
    create: (_) => di.get<ProfileBloc>()..add(const GetPackageVersionEvent()),
    child: const ProfilePage(),
  );
}
