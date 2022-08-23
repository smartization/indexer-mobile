import 'package:flutter/material.dart';

class ItemBarcodeInput extends StatelessWidget {
  final TextEditingController controller;

  const ItemBarcodeInput({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: "Barcode"
      ),
      keyboardType: TextInputType.number,
    );
  }

}