import 'package:flutter/material.dart';
import 'package:indexer_client/drawer/drawer_header.dart';
import 'package:indexer_client/drawer/drawer_settings_button.dart';

import 'drawer_home_button.dart';

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeaderr(),
          DrawerHomeButton(),
          DrawerSettingsButton()
        ],
      ),
    );
  }
}