/// Instance names for DI registrations that share a type: `PageFactory`, `WidgetFactory<T>`,
/// `ModuleInteractor<T, P>`. Key string equals the implementation's class name; group by kind.
final class InstanceNameKeys {
  const new _();

  /// page factories
  static const String homeFactory = 'HomePageFactory';
  static const String messageFactory = 'MessagePageFactory';
  static const String dashboardFactory = 'DashboardPageFactory';
  static const String profileFactory = 'ProfilePageFactory';

  /// interactors
  static const String getUnreadNotificationsCountInteractor = 'GetUnreadNotificationsCountInteractor';

  /// widget factories
  static const String notificationItemFactory = 'NotificationItemFactory';
}
