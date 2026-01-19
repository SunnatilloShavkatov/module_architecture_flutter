abstract interface class AppNavigationService {
  const AppNavigationService();

  Future<void> navigateToNoInternet();

  void navigateToInitial();

  bool isCurrentPath(String path);
}
