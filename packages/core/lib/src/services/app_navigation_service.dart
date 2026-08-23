abstract interface class AppNavigationService {
  const new();

  Future<void> navigateToNoInternet();

  void navigateToInitial();

  bool isCurrentPath(String path);
}
