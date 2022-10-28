import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeInput extends StatelessWidget {
  final bool showIcon;
  final String? helperText;
  late ValueChanged? onChanged;
  late TextEditingController? controller;
  late String? initialValue;

  BarcodeInput(
      {Key? key,
      this.helperText,
      this.onChanged,
      this.controller,
      this.showIcon = false,
      this.initialValue})
      : super(key: key) {
    onChanged ??= () {} as ValueChanged?;
    if (controller != null && initialValue != null) {
      throw ArgumentError(
          "Both controller and initialValue set, only one is at a time is valid");
    }
    if (initialValue != null) {
      controller = TextEditingController(text: initialValue!);
    }
    controller?.selection =
        TextSelection.collapsed(offset: initialValue!.length);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
                labelText: "Barcode",
                helperText: helperText ?? "",
                helperMaxLines: 4,
                icon: showIcon ? const Icon(Icons.scanner) : null),
            keyboardType: TextInputType.number,
            onChanged: onChanged,
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
    if (controller != null) {
      controller!.text = barcodeScanRes;
    }
    onChanged!(barcodeScanRes);
  }
}
