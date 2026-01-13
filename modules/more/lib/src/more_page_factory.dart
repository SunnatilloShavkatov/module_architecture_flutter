import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:more/src/presentation/more/bloc/more_bloc.dart';
import 'package:more/src/presentation/more/more_page.dart';

final class MorePageFactory implements PageFactory {
  const MorePageFactory();

  @override
  Widget create(Injector di) =>
      BlocProvider(create: (_) => di.get<MoreBloc>()..add(const GetPackageVersionEvent()), child: const MorePage());
}
