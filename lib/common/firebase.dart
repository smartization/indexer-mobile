import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:indexer_client/api/api_spec.swagger.dart';
import 'package:indexer_client/common/dto_service.dart';
import 'package:indexer_client/common/exceptions/exception_resolver.dart';
import 'package:indexer_client/item/item_service.dart';
import 'package:indexer_client/settings/settings_main.dart';
import 'package:indexer_client/state.dart';
import 'package:provider/provider.dart';
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

  static void startSyncingToken(BuildContext context) async {
    final String fcmToken =
        await FirebaseMessaging.instance.getToken() ?? "missing-new-token";
    DTOService dtoService = DTOService(context: context);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String oldToken =
        sharedPreferences.getString(SettingsKeys.fcmToken.toString()) ??
            "missing-old-token";
    sharedPreferences.setString(SettingsKeys.fcmToken.toString(), fcmToken);
    print("Syncing FCM token old: ${oldToken}, new token: ${fcmToken}");
    dtoService.getApi().firebaseTokenOldTokenUpdateNewTokenPatch(
        oldToken: oldToken, newToken: fcmToken);
  }

  static void initMessageListener(BuildContext context) {
    FirebaseMessaging.onMessage
        .listen((message) => _messageListener(message, context));
  }

  static void _messageListener(RemoteMessage event, BuildContext context) {
    ExceptionResolver exceptionResolver = ExceptionResolver(context: context);
    ItemService itemService =
        ItemService(context: context, exceptionResolver: exceptionResolver);
    Map<String, dynamic> data = event.data;
    List<ItemDTO>? items = Provider.of<AppState>(context, listen: false).items;
    Map<ItemDTO, bool>? expanded =
        Provider.of<AppState>(context, listen: false).expanded;
    print(data);
    String type = data["type"];
    int itemId = int.parse(data["id"]);
    if (type == "update" || type == "save") {
      itemService.refreshItem(itemId);
    } else if (type == "delete") {
      itemService.dropItemById(itemId);
    }
  }
}
