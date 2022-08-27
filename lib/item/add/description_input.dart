import 'package:flutter/material.dart';

class ItemDescriptionInput extends StatelessWidget {
  final TextEditingController controller;

  const ItemDescriptionInput({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Description",
      ),
      minLines: 1,
      maxLines: null,
      controller: controller,
      keyboardType: TextInputType.multiline,
    );
  }

}