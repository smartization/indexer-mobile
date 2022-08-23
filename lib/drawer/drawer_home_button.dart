import 'package:flutter/material.dart';
import 'package:indexer_client/item/item_main.dart';
import 'package:indexer_client/main.dart';
import 'package:indexer_client/settings/settings_main.dart';

class DrawerHomeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Items"),
      subtitle: const Text("List of all items"),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const ItemMain()));
      }
    );
  }

}