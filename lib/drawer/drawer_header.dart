import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state.dart';

class DrawerHeaderr extends StatelessWidget {
  const DrawerHeaderr({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String serverAddress =
        Provider.of<AppState>(context, listen: false).serverAddress ?? "";
    if (serverAddress.isEmpty) {
      serverAddress = "not specified";
    } else {
      int protoEnd = serverAddress.indexOf("//") + 2;
      int endpointStart = serverAddress.indexOf("/api");
      serverAddress = "@${serverAddress.substring(protoEnd, endpointStart)}";
    }
    return SizedBox(
      height: 140,
      child: DrawerHeader(
          decoration: BoxDecoration(color: Theme.of(context).accentColor),
          child: Column(
            children: [
              const Text(
                "Indexer App",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
              Text(
                "${serverAddress}",
                style: const TextStyle(color: Colors.white70),
              )
            ],
          )),
    );
  }
}

/*
SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(SettingsKeys.serverAddress.name, serverAddress);
 */
