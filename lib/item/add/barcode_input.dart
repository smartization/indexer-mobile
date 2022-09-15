import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ItemBarcodeInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(bool) onChecksumValidChange;

  const ItemBarcodeInput(
      {Key? key, required this.controller, required this.onChecksumValidChange})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemBarcodeInputState(
      controller: controller, onChecksumValidChange: onChecksumValidChange);
}

class _ItemBarcodeInputState extends State<ItemBarcodeInput> {
  final TextEditingController controller;
  final Function(bool) onChecksumValidChange;
  String _helperText = "";

  _ItemBarcodeInputState(
      {Key? key,
      required this.controller,
      required this.onChecksumValidChange}) {
    validate(controller.text);
  }

  @override
  void initState() {
    super.initState();
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
                helperText: _helperText,
                helperMaxLines: 4),
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
    controller.text = barcodeScanRes;
  }

  void onChanged(String value) {
    onChecksumValidChange(validate(value));
    setState(() {});
  }

  bool validate(String value) {
    final bool numbersOnly = validateBarcodeNumbersOnly(value);
    if (!numbersOnly) {
      _helperText = "This barcode should contains only digits";
      return false;
    }
    _helperText = "";
    return true;
  }

  bool validateBarcodeLength(String value) {
    if (value.length != 13) {
      return false;
    }
    return true;
  }

  bool validateBarcodeNumbersOnly(String value) {
    return int.tryParse(value) != null;
  }
}