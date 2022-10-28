import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:indexer_client/common/dto_service.dart';
import 'package:indexer_client/settings/settings_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase_options.dart';

class FirebaseIntegration {
  static void init() async {
    var firebase = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    var messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static void syncToken(BuildContext context) async {
    final String fcmToken =
        await FirebaseMessaging.instance.getToken() ?? "missing-new-token";
    DTOService dtoService = DTOService(context: context);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String oldToken =
        sharedPreferences.getString(SettingsKeys.fcmToken.toString()) ??
            "missing-old-token";
    if (oldToken != fcmToken) {
      sharedPreferences.setString(SettingsKeys.fcmToken.toString(), fcmToken);
      dtoService.getApi().firebaseTokenOldTokenUpdateNewTokenPatch(
          oldToken: oldToken, newToken: fcmToken);
    }
  }
}
