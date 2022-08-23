import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final Function()? onPressed;

  const SubmitButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text("Submit"),
    );
  }
}