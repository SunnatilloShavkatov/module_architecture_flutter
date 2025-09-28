// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:async';
import 'dart:convert';

import 'package:base_dependencies/base_dependencies.dart';
import 'package:core/src/extension/extension.dart';
import 'package:core/src/utils/utils.dart';
import 'package:flutter/services.dart';

/// flutter local notification
const AndroidNotificationChannel _channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);
const InitializationSettings _initializationSettings = InitializationSettings(
  iOS: DarwinInitializationSettings(),
  macOS: DarwinInitializationSettings(),
  android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  linux: LinuxInitializationSettings(defaultActionName: 'default'),
);

/// flutter local notification
final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

final class NotificationService {
  const NotificationService._();

  static NotificationService get instance => _instance;

  static const NotificationService _instance = NotificationService._();

  Future<void> initialize(FirebaseOptions options) async {
    try {
      await Firebase.initializeApp(options: options);
    } on Exception catch (error, stackTrace) {
      logMessage('Firebase initialize error: $error $stackTrace', stackTrace: stackTrace, error: error);
    }

    /// initialize local notifications and handle tap events
    await _notifications.initialize(_initializationSettings, onDidReceiveNotificationResponse: _handleNotificationTap);

    /// handle foreground messages
    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    /// handle messages when app is terminated/background
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      await _handleNotificationTap(
        NotificationResponse(
          notificationResponseType: NotificationResponseType.selectedNotification,
          payload: jsonEncode({'chat_id': message.data['chat_id'], 'chat_type': message.data['chat_type']}),
        ),
      );
    });
  }

  Future<void> requestNotificationPermissions() async {
    if (isAndroid) {
      final aN = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (aN != null) {
        await aN.createNotificationChannel(_channel);
        await aN.requestNotificationsPermission();
      }
    }
  }

  Future<void> setupFlutterNotifications() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission();
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      logMessage('User granted permission: ${settings.authorizationStatus}');
    } on FirebaseException catch (error, stackTrace) {
      logMessage('Firebase error: $error', stackTrace: stackTrace, error: error);
    } on PlatformException catch (error, stackTrace) {
      logMessage('Platform error: $error', stackTrace: stackTrace, error: error);
    } catch (error, stackTrace) {
      logMessage('FCM token error: $error $stackTrace', stackTrace: stackTrace, error: error);
    }
  }

  Future<String?> getFCMToken() async {
    try {
      if (isIOS) {
        final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken != null) {
          final fcmToken = await FirebaseMessaging.instance.getToken();
          logMessage('FCM token: $fcmToken');
          return fcmToken;
        }
      } else if (isAndroid) {
        final fcmToken = await FirebaseMessaging.instance.getToken();
        logMessage('FCM token: $fcmToken');
        return fcmToken;
      }
    } on FirebaseException catch (error, stackTrace) {
      logMessage('Firebase error: $error', stackTrace: stackTrace, error: error);
    } on PlatformException catch (error, stackTrace) {
      logMessage('Platform error: $error', stackTrace: stackTrace, error: error);
    } catch (error, stackTrace) {
      logMessage('FCM token error: $error $stackTrace', stackTrace: stackTrace, error: error);
    }
    return null;
  }

  Future<void> showFlutterNotification(RemoteMessage message) async {
    if (isIOS) {
      return;
    }
    if (message.data.containsKey('title') && message.data.containsKey('body')) {
      await _notifications.show(
        message.hashCode,
        message.data['title'],
        message.data['body'],
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            priority: Priority.high,
            importance: Importance.high,
            icon: '@mipmap/ic_launcher',
            channelDescription: _channel.description,
            visibility: NotificationVisibility.public,
            styleInformation: BigTextStyleInformation(message.data['body'] ?? '', contentTitle: message.data['title']),
          ),
          iOS: const DarwinNotificationDetails(
            sound: 'default',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode({'chat_id': message.data['chat_id'], 'chat_type': message.data['chat_type']}),
      );
    }
  }

  Future<void> _handleNotificationTap(NotificationResponse response) async {
    if (response.payload == null || response.payload!.isEmpty) {
      // chuck.showInspector();
      return;
    }
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  await NotificationService.instance.setupFlutterNotifications();

  /// if the remote message has title and text, a notification will be displayed.
  if (message.notification?.title == null && message.notification?.body == null) {
    await NotificationService.instance.showFlutterNotification(message);
  }
}
