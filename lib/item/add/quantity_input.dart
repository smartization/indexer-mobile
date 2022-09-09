import 'package:flutter/material.dart';

class ItemQuantityInput extends StatefulWidget {
  final TextEditingController controller;

  const ItemQuantityInput({Key? key, required this.controller})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _ItemQuantityInputState(controller: controller);
}

class _ItemQuantityInputState extends State<ItemQuantityInput> {
  final TextEditingController controller;
  late bool _quantityEnabled;

  _ItemQuantityInputState({required this.controller}) {
    _quantityEnabled = controller.text != "";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
            onPressed: onMinusPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(30, 30),
              onPrimary: _quantityEnabled ? Colors.blue : Colors.grey,
            ),
            child: const Icon(Icons.remove)),
        Expanded(
            child: TextFormField(
          decoration: const InputDecoration(labelText: "Quantity"),
          controller: controller,
          validator: validate,
          keyboardType: TextInputType.number,
          enabled: _quantityEnabled,
        )),
        TextButton(
            onPressed: onPlusPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(30, 30),
              onPrimary: _quantityEnabled ? Colors.blue : Colors.grey,
            ),
            child: const Icon(Icons.add)),
        Checkbox(
            value: _quantityEnabled,
            tristate: false,
            onChanged: onQuantityEnableChange),
      ],
    );
  }

  void onMinusPressed() {
    if (_quantityEnabled) {
      if (int.parse(controller.text) > 0) {
        controller.text = (int.parse(controller.text) - 1).toString();
      }
    }
  }

  void onPlusPressed() {
    if (_quantityEnabled) {
      controller.text = (int.parse(controller.text) + 1).toString();
    }
  }

  String? validate(String? value) {
    try {
      if (!_quantityEnabled) {
        return null;
      } else if (value == null) {
        return "Quantity must be provided";
      } else if (int.parse(value) < 0) {
        return "Quantity must be greater than 0";
      }
    } on FormatException catch (e) {
      return e.message;
    }
    return null;
  }

  void onQuantityEnableChange(bool? value) {
    setState(() {
      _quantityEnabled = value!;
      if (!_quantityEnabled) {
        controller.text = "";
      } else {
        controller.text = "0";
      }
    });
  }
}
