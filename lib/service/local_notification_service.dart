import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initNotifications(BuildContext context) async {
    if (_isInitialized) return;

    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // const DarwinInitializationSettings initSettingsIOS =
    //     DarwinInitializationSettings(
    //   requestAlertPermission: true,
    //   requestBadgePermission: true,
    //   requestSoundPermission: true,
    // );

    const InitializationSettings initSettings = InitializationSettings(
        android: initSettingsAndroid,
        // iOS: initSettingsIOS
    );

    await notificationsPlugin.initialize(initSettings, onDidReceiveNotificationResponse: (NotificationResponse response) {
      _onNotificationTap(response.payload, context);
    },);

    _isInitialized = true;
  }

  void _onNotificationTap(String? payload, BuildContext context) {
    if (payload != null) {
      Navigator.of(context).pushNamed('/sport_detail', arguments: payload);
    }
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_chanel_id',
        'Daily Notifications',
        channelDescription: 'Daily notifications channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
      // iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotifications({
    int id = 0,
    String? title,
    String? body,
    String? eventId,
  }) async {

    return notificationsPlugin.show(id, title, body, notificationDetails(), payload: eventId);
  }
}
