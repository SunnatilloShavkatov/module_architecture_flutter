part of '../home_page.dart';

mixin HomeMixin on State<HomePage> {
  void _stateListener(BuildContext context, HomeState state) {
    if (state is HomeFailureState) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(state.message)));
    }
  }

  void _reloadHome() {
    context.read<HomeBloc>().add(const HomeRefreshEvent());
  }
}
