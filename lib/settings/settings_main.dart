import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:indexer_client/settings/server_address_text_field.dart';
import 'package:indexer_client/state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/submit_button.dart';
import '../drawer/drawer.dart';

enum SettingsKeys {
  serverAddress,
  fcmToken;
}

class SettingsMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsMainState();
}

class _SettingsMainState extends State<SettingsMain> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _serverAddressEditorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Consumer<AppState>(
        builder: (ctx, appState, child) {
          _serverAddressEditorController.text = appState.serverAddress ?? "";
          return Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    ServerAddressTextField(
                        controller: _serverAddressEditorController
                    ),
                    SubmitButton(onPressed: onSubmit)
                  ],
                ),
              )
          );
        },
      ),
      drawer: const CommonDrawer(),
    );
  }

  onSubmit() {
    if (_key.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings Saved')),
      );
      final String serverAddress = _serverAddressEditorController.value.text;
      updateAppState(serverAddress);
      savePreferences(serverAddress);
      // this is do to create new token for new server
      // this is done for legacy token to server submitting method
      _invalidateFcmToken();
    }
  }

  Future<void> savePreferences(String serverAddress) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(SettingsKeys.serverAddress.name, serverAddress);
  }

  void updateAppState(String serverAddress) {
    setState(() {
      Provider.of<AppState>(context, listen: false)
          .updateServerAddress(serverAddress);
    });
  }

  void _invalidateFcmToken() {
    FirebaseMessaging.instance.deleteToken();
  }
}