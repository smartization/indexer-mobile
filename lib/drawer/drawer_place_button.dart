import 'package:flutter/material.dart';
import 'package:indexer_client/place/place_main.dart';

class DrawerPlaceButton extends StatelessWidget {
  const DrawerPlaceButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Places"),
      subtitle: const Text("Manage storage places"),
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (ctx) => PlaceMain())),
    );
  }
}
