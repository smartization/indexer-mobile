import 'package:flutter/material.dart';

class ItemNameTextInput extends StatelessWidget {
  final TextEditingController controller;

  const ItemNameTextInput({Key? key, required, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Name"),
      minLines: 1,
      maxLines: null,
      controller: controller,
      validator: validator,
    );
  }

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return "Name is required";
    }
    return null;
  }
}