import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:more/src/presentation/more/bloc/more_bloc.dart';
import 'package:navigation/navigation.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('More')),
    body: SafeAreaWithMinimum(
      minimum: Dimensions.kPaddingAll16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () async {
              await context.pushNamed(Routes.settings);
            },
            child: Text(context.localizations.settings),
          ),
          CustomLoadingButton(
            child: const Text('Settings'),
            onPressed: () async {
              await context.pushNamed(Routes.settings);
            },
          ),
        ],
      ),
    ),
    bottomNavigationBar: SafeAreaWithMinimum(
      minimum: Dimensions.kPaddingAll16,
      child: BlocBuilder<MoreBloc, MoreState>(
        buildWhen: (prev, curr) => curr is PackageVersionState,
        builder: (_, state) {
          if (state is! PackageVersionState) {
            return const SizedBox.shrink();
          }
          return Text('${state.version.version} (${state.version.buildNumber})', textAlign: TextAlign.center);
        },
      ),
    ),
  );
}
