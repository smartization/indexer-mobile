import 'package:flutter/material.dart';

class CategoryDescriptionInput extends StatelessWidget {
  final TextEditingController controller;

  const CategoryDescriptionInput({Key? key, required, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Description"),
      controller: controller,
    );
  }
}
