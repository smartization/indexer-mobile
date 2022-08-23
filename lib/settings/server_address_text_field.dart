import 'package:flutter/material.dart';

class ServerAddressTextField extends StatelessWidget {
  final TextEditingController controller;

  const ServerAddressTextField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
          labelText: "Server address"
      ),
      validator: validator,
      controller: controller,
    );
  }

  String? validator(String? value) {
    if (value!.isEmpty) {
      return "Address cannot be empty";
    }
    if (!value.startsWith(RegExp(r'^https?://'))) {
      return "Address must start with http:// or https://";
    }
    return null;
  }
}