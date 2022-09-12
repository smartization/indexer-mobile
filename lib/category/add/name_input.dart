import 'package:flutter/material.dart';

class CategoryNameTextInput extends StatelessWidget {
  final TextEditingController controller;

  const CategoryNameTextInput({Key? key, required, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Name"),
      controller: controller,
    );
  }
}
