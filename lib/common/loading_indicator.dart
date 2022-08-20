import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final String title;

  const LoadingIndicator({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: const [
          CircularProgressIndicator(),
          Text("Loading settings"),
        ],
      ),
    );
  }
}