import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class FirebaseIntegration {
  static void init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static void subscribeToTopic(String topic, BuildContext context) async {
    try {
      await FirebaseMessaging.instance.subscribeToTopic('due-date');
      FirebaseMessaging.onMessage.listen((event) {
        if (event.notification != null) {
          final String notificationText =
              "${event.notification!.title}: ${event.notification!.body}";
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(notificationText)));
        }
      });
      print('subscribed to topic');
    } catch (e) {
      print('error is $e');
    }
  }
}
