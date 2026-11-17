import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> messengerKey =
  GlobalKey<ScaffoldMessengerState>();
class NotificationService {
  NotificationService._();

  static final NotificationService instance =
  NotificationService._();

  final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  Future<AuthorizationStatus> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint(
      'Notification permission: '
          '${settings.authorizationStatus.name}',
    );

    return settings.authorizationStatus;
  }

  Future<String?> getToken() async {
    final token = await _messaging.getToken();

    debugPrint('FCM Token: $token');

    return token;
  }

  Future<void> init() async {
    await requestPermission();

    final token = await getToken();

    debugPrint('FCM Token saat init: $token');

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('[FOREGROUND] Notification received');
      debugPrint('title: ${message.notification?.title}');
      debugPrint('body: ${message.notification?.body}');
      debugPrint('data: ${message.data}');

      final title = message.notification?.title ?? 'Notifikasi';
      final body = message.notification?.body ?? '';

      messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('$title\n$body'),
        ),
      );
    });
  }


  void listenTokenRefresh(
      void Function(String token) onRefresh,
      ) {
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token diperbarui');

      onRefresh(newToken);
    });
  }
}
