part of '../splash_page.dart';

mixin SplashMixin on State<SplashPage> {
  LocalSource get _localSource => AppInjector.instance.get<LocalSource>();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus().ignore();
  }

  Future<void> _checkLoginStatus() async {
    final bool isEmulator = await PlatformMethods.instance.isEmulator();
    if (isEmulator && kReleaseMode) {
      return;
    }
    final bool isLoggedIn = _localSource.hasProfile;
    if (!mounted) {
      return;
    }
    if (isLoggedIn) {
      context.pushReplacementNamed(Routes.mainHome);
    } else {
      context.pushReplacementNamed(Routes.welcome);
    }
  }
}
