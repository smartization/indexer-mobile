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
      required this.onChecksumValidChange});

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
            validator: validator,
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
    final bool numbersOnly = validateBarcodeNumbersOnly(value);
    if (!numbersOnly) {
      _helperText = "This barcode should contains only digits";
      onChecksumValidChange(false);
      setState(() {});
      return;
    }
    final bool lengthValid = validateBarcodeLength(value);
    if (!lengthValid) {
      _helperText = "This barcode length is not 13";
      onChecksumValidChange(false);
      setState(() {});
      return;
    }
    final bool checksumValid = validateBarcodeChecksum(value);
    if (!checksumValid) {
      _helperText = "This barcode checksum is invalid";
      onChecksumValidChange(false);
      setState(() {});
      return;
    }
    _helperText = "";
    onChecksumValidChange(true);
    setState(() {});
  }

  bool validateBarcodeChecksum(String barcode) {
    String barcodeWithoutLast = barcode.substring(0, barcode.length - 1);
    List<int> digits =
        barcodeWithoutLast.split("").map((e) => int.parse(e)).toList();
    int evenSum = 0;
    int oddSum = 0;
    for (int i = 0; i < digits.length; i += 2) {
      evenSum += digits[i];
    }
    for (int i = 1; i < digits.length; i += 2) {
      oddSum = digits[i];
    }
    int unit = evenSum + oddSum * 3;
    int check = 10 - (unit % 10);
    int lastBarcodeDigit = int.parse(barcode[barcode.length - 1]);
    return check == lastBarcodeDigit;
  }

  String? validator(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length != 13) {
        return "Barcode should have 13 chars";
      }
    }
    return null;
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