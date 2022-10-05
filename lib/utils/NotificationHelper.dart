import 'dart:async';

import 'package:dandylight/models/JobReminder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final NotificationHelper _singleton = NotificationHelper._SingletonConstructor();

  factory NotificationHelper() {
    return _singleton;
  }

  NotificationHelper._SingletonConstructor();

  FlutterLocalNotificationsPlugin flutterNotificationPlugin;

  Future<void> initNotifications() async {
    flutterNotificationPlugin = FlutterLocalNotificationsPlugin();

    const MethodChannel platform = MethodChannel('dandylight_mobile');

    const String portName = 'notification_send_port';

    String selectedNotificationPayload;

    /// A notification action which triggers a url launch event
    const String urlLaunchActionId = 'id_1';

    /// A notification action which triggers a App navigation event
    const String navigationActionId = 'id_3';

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()));

    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = new DarwinInitializationSettings();

    var initializationSettings = new InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterNotificationPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            print('Notification selected');
            break;
          case NotificationResponseType.selectedNotificationAction:
            print('Notification selected with action');
            if (notificationResponse.actionId == navigationActionId) {

            }
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  Future<String> getNotificationJobId() async {
    String jobId = "";
    final NotificationAppLaunchDetails notificationAppLaunchDetails = await flutterNotificationPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      jobId = notificationAppLaunchDetails.notificationResponse?.payload;
    }
    print("Notification app launch JobId = $jobId");
    return jobId;
  }

  Future<void> turnOffNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> turnOffNotificationById(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      num id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> scheduleNotification(
      int id,
      String title,
      String body,
      DateTime scheduledNotificationDateTime) async {
    await flutterNotificationPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.local,
        ),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<bool> requestIOSPermissions(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    return await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
// ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
// ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}
