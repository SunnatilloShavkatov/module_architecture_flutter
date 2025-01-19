enum AppStatus {
  initial,
  loading,
  success,
  logout,
  failure;

  bool get isInitial => this == AppStatus.initial;

  bool get isLoading => this == AppStatus.loading;

  bool get isSuccess => this == AppStatus.success;

  bool get isFailure => this == AppStatus.failure;

  bool get isLogout => this == AppStatus.logout;
}
