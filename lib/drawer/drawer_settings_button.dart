import 'package:flutter/material.dart';

import '../settings/settings_main.dart';

class DrawerSettingsButton extends StatelessWidget {
  const DrawerSettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: const Text("Settings"),
        subtitle: const Text("Application settings"),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => SettingsMain()));
        });
  }

}