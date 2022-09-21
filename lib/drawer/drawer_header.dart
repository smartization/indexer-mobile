import 'package:flutter/material.dart';

class DrawerHeaderr extends StatelessWidget {
  const DrawerHeaderr({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: DrawerHeader(
          decoration: BoxDecoration(color: Theme.of(context).accentColor),
          child: Column(
            children: const [
              Text(
                "Indexer App",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
              Text(
                "@test.com",
                style: TextStyle(color: Colors.white70),
              )
            ],
          )
      ),
    );
  }

}