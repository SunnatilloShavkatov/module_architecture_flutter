abstract interface class AppNavigationService {
  Future<void> navigateToNoInternet();

  void navigateToInitial();

  bool isCurrentPath(String path);
}
