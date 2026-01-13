abstract interface class AppNavigationService {
  const AppNavigationService();

  void navigateToNoInternet();

  void navigateToInitial();

  bool isCurrentPath(String path);
}
