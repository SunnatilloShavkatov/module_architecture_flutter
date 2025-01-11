// ignore_for_file: discarded_futures, unawaited_futures
import "dart:async";

import "package:base_dependencies/base_dependencies.dart";
import "package:core/core.dart";

/// flutter local notification
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  "high_importance_channel",
  "High Importance Notifications",
  description: "This channel is used for important notifications.",
  importance: Importance.high,
);
const InitializationSettings initializationSettings = InitializationSettings(
  android: AndroidInitializationSettings("@mipmap/ic_launcher"),
  iOS: DarwinInitializationSettings(),
  macOS: DarwinInitializationSettings(),
  linux: LinuxInitializationSettings(defaultActionName: "default"),
);

/// flutter local notification
final FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();
final AndroidFlutterLocalNotificationsPlugin? androidNotification =
    notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

sealed class NotificationService {
  const NotificationService._();

  static Future<void> initialize(FirebaseOptions options) async {
    try {
      await Firebase.initializeApp(options: options);
      FirebaseMessaging.instance.getAPNSToken();
    } on Exception catch (e, s) {
      logMessage("Firebase initialize error: $e $s", stackTrace: s);
    }
    await setupFlutterNotifications();
    await foregroundNotification();
    backgroundNotification();
    await terminateNotification();
    if (androidNotification != null) {
      await androidNotification!.createNotificationChannel(channel);
      await androidNotification!.requestNotificationsPermission();
    }
  }

  static Future<void> setupFlutterNotifications() async {
    try {
      final settings = await firebaseMessaging.requestPermission(provisional: true);
      await firebaseMessaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
      final apnsToken = await firebaseMessaging.getAPNSToken();
      if (apnsToken != null) {
        final result = await firebaseMessaging.getToken();
        logMessage("FCM token :$result");
      }
      logMessage("User granted permission: ${settings.authorizationStatus}");
    } on Exception catch (e, s) {
      logMessage("Notification permission error: $e $s");
    }
  }

  static void showFlutterNotification(RemoteMessage message) {
    if (message.data.containsKey("title") && message.data.containsKey("body")) {
      notifications.show(
        message.hashCode,
        message.data["title"],
        message.data["body"],
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            styleInformation: BigTextStyleInformation(message.data["body"] ?? "", contentTitle: message.data["title"]),
            icon: "@mipmap/ic_launcher",
            priority: Priority.high,
            importance: Importance.high,
            visibility: NotificationVisibility.public,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            sound: "default",
          ),
        ),
        payload: "${message.data["chat_id"]}+${message.data["chat_type"]}",
      );
    }
  }

  static Future<void> foregroundNotification() async {
    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    /// when tapped
    await notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // final List<String> chat = (response.payload ?? "").split("+");
        // if (chat.length == 2) {
        //   final String chatId = chat.first;
        //   if (chat.last == "100") {
        //     if (Routes.personalChat.isCurrentRoute) {
        //       return;
        //     }
        //     router.pushNamed(
        //       Routes.personalChat,
        //       extra: PersonalChatArguments(chatId: int.tryParse(chatId) ?? 0),
        //     );
        //   } else if (chat.last == "200") {
        //     if (Routes.groupChat.isCurrentRoute) {
        //       return;
        //     }
        //     router.pushNamed(
        //       Routes.groupChat,
        //       extra: PersonalChatArguments(chatId: int.tryParse(chatId) ?? 0),
        //     );
        //   } else if (chat.last == "300") {
        //     if (Routes.channelsChat.isCurrentRoute) {
        //       return;
        //     }
        //     router.pushNamed(
        //       Routes.channelsChat,
        //       extra: PersonalChatArguments(chatId: int.tryParse(chatId) ?? 0),
        //     );
        //   }
        // }

        //   router.pushNamed(
        //     Routes.writingResults,
        //     extra: WritingResultsArgument(exerciseId: chatId),
        //   );
        // } else {
        // chuck.showInspector();
        // }
      },
    );
  }

  static void backgroundNotification() {
    FirebaseMessaging.onMessageOpenedApp.listen(showFlutterNotification);
  }

  static Future<void> terminateNotification() async {
    final RemoteMessage? remoteMessage = await firebaseMessaging.getInitialMessage();
    if (remoteMessage == null) {
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    } else {
      showFlutterNotification(remoteMessage);
    }
  }
}

@pragma("vm:entry-point")
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationService.setupFlutterNotifications();

  /// notification data empty enable this line
  if (message.notification?.title == null && message.notification?.body == null) {
    NotificationService.showFlutterNotification(message);
  }
}
