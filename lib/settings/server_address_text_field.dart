import 'package:flutter/material.dart';

class ServerAddressTextField extends StatefulWidget {
  final TextEditingController controller;

  const ServerAddressTextField({Key? key, required this.controller})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ServerAddressTextField(controller);
}

class _ServerAddressTextField extends State<ServerAddressTextField> {
  final TextEditingController controller;
  String _helperText = "";

  _ServerAddressTextField(this.controller);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Server address",
        helperText: _helperText,
      ),
      validator: validator,
      controller: controller,
    );
  }

  String? validator(String? value) {
    if (value!.isEmpty) {
      return "Address cannot be empty";
    }
    if (!value.startsWith(RegExp(r'^https?://'))) {
      return "Address must start with http:// or https://";
    }
    setState(() {
      if (value.startsWith("http://")) {
        _helperText =
            "Your data will not be safe during transfer, use https instead";
      } else {
        _helperText = "";
      }
    });
    return null;
  }
}
