import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsManager {

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<String> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure();

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");

      _initialized = true;
    }
  }

  final String serverToken = 'AAAACjxm228:APA91bGzc4xnNA_zhCqNK9k_N-i8ZXwtYSdKPSovGGeh89ifF7DlLcC5w3Lzfw-A6seM4Z0Q1SPUIiN5BajUhx-TLVwepCaOuTc4bRzdR4JWsJ8OV5UwBjWe_1U9ZddL-IVLE0RwIc8D';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    );

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'Booty call!',
            'title': 'Show me your sweet booty thang!!'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': 'f5EVhN36jEQBnLrnxgp82e:APA91bFXBd-KaaqgSlCtQhzApBCpTyWO1RearRRqmpIr_9YEZtP-z6Vj2nVZfrOSY9rj8YPfD-uV6GlrTEgzxkW3B7kt0H7U2NTy_VbHkzYshKctDrv6wQKRZBD8OaB5WTlnSP1qPoVk',
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
    Completer<Map<String, dynamic>>();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
  }
}