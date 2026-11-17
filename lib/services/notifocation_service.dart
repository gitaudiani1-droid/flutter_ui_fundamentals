import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../screens/course_detail_page.dart';
import '../app_navigator.dart';

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

  Future<void> setupInteractedMessage() async {
    debugPrint('=== SETUP NOTIFICATION TAP ===');

    final initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      debugPrint('=== INITIAL MESSAGE FOUND ===');
      _handleNotificationTap(initialMessage);
    } else {
      debugPrint('Tidak ada initial message');
    }

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('=== NOTIFICATION OPENED FROM BACKGROUND ===');
      _handleNotificationTap(message);
    });
  }

  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('=== NOTIFICATION TAPPED ===');
    debugPrint('Notification data: ${message.data}');
    debugPrint('Course ID: ${message.data['course_id']}');
    final courseId = int.tryParse(
      message.data['course_id']?.toString() ?? '',
    );

    if (courseId == null) {
      debugPrint('Course ID tidak valid.');
      return;
    }

    final context = navigatorKey.currentContext;

    if (context == null) {
      debugPrint('Navigator belum siap.');
      return;
    }

    final courseProvider = Provider.of<CourseProvider>(
      context,
      listen: false,
    );

    final matchingCourses = courseProvider.courses.where(
          (course) => course.id == courseId,
    );

    if (matchingCourses.isEmpty) {
      debugPrint('Kursus dengan ID $courseId tidak ditemukan.');
      return;
    }

    final course = matchingCourses.first;

    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => CourseDetailPage(course: course),
      ),
    );
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
