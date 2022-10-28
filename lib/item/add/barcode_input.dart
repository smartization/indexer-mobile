import 'package:flutter/material.dart';
import 'package:indexer_client/common/barcode_input.dart';

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
    return BarcodeInput(
      helperText: _helperText,
      controller: controller,
      onChanged: (ean) => onChanged(ean),
    );
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