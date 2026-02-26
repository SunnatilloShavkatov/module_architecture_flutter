import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:home/src/presentation/main/bloc/home_bloc.dart';
import 'package:home/src/presentation/main/home_page.dart';

final class HomePageFactory implements PageFactory {
  const HomePageFactory();

  @override
  Widget create(Injector di) =>
      BlocProvider<HomeBloc>(create: (_) => di.get<HomeBloc>()..add(const HomeLoadEvent()), child: const HomePage());
}
