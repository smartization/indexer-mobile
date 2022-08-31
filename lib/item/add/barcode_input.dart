import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ItemBarcodeInput extends StatelessWidget {
  final TextEditingController controller;

  const ItemBarcodeInput({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(labelText: "Barcode"),
            keyboardType: TextInputType.number,
          ),
        ),
        TextButton(
          onPressed: onCameraButtonPressed,
          child: const Icon(Icons.camera),
        )
      ],
    );
  }

  void onCameraButtonPressed() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    controller.text = barcodeScanRes;
  }
}