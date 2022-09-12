import 'package:flutter/material.dart';
import 'package:indexer_client/item/item_main.dart';

class DrawerHomeButton extends StatelessWidget {
  const DrawerHomeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: const Text("Items"),
        subtitle: const Text("List of all items"),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => const ItemMain()));
        });
  }

}