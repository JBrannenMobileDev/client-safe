import 'dart:async';
import 'dart:convert';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/JobReminder.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_messaging/firebase_messaging.dart';


class PushNotificationsManager {

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _initialized = false;

  Future<String?> getToken() async {
    try {
      if(!_initialized) {
        await init();
      }
      return await _firebaseMessaging.getToken();
    } catch (e) {
      return null;
    }
  }

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      await _firebaseMessaging.requestPermission();

      // For testing purposes print the Firebase Messaging token
      String? token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");

      _initialized = true;
    }
  }

  final String serverToken = 'AAAACjxm228:APA91bGzc4xnNA_zhCqNK9k_N-i8ZXwtYSdKPSovGGeh89ifF7DlLcC5w3Lzfw-A6seM4Z0Q1SPUIiN5BajUhx-TLVwepCaOuTc4bRzdR4JWsJ8OV5UwBjWe_1U9ZddL-IVLE0RwIc8D';

  Future<Map<String, dynamic>> sendNotification(JobReminder reminder, String jobName) async {
    await _firebaseMessaging.requestPermission();

    for(String deviceId in (await ProfileDao.getAll()).elementAt(0).deviceTokens!) {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': reminder.reminder!.description,
              'title': jobName,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': reminder.id,
              'status': 'done'
            },
            'to': deviceId,
          },
        ),
      );
    }

    final Completer<Map<String, dynamic>> completer =
    Completer<Map<String, dynamic>>();

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        (Map<String, dynamic> message) async {
          completer.complete(message);
        };
      },
    );

    return completer.future;
  }
}