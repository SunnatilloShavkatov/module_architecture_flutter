import 'package:core/core.dart';
import 'package:home/src/presentation/main/bloc/home_bloc.dart';
import 'package:home/src/presentation/main/home_page.dart';
import 'package:material_ui/material_ui.dart';

final class HomePageFactory implements PageFactory {
  const HomePageFactory();

  @override
  Widget create(Injector di) =>
      BlocProvider<HomeBloc>(create: (_) => di.get<HomeBloc>()..add(const HomeLoadEvent()), child: const HomePage());
}
