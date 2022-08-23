import 'package:flutter/material.dart';

class ItemDueDateInput extends StatefulWidget {
  final TextEditingController controller;

  const ItemDueDateInput({Key? key, required this.controller}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemDueDateInputState(controller: controller);

}

class _ItemDueDateInputState extends State<ItemDueDateInput> {
  final TextEditingController controller;

  _ItemDueDateInputState({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Due date"
      ),
      validator: validate,
      readOnly: true,
      onTap: onTap,
      controller: controller,
    );
  }


  String? validate(String? value) {
    if (value == null) {
      return "You have not selected any due date";
    }
    if (DateTime.parse(value).isBefore(DateTime.now())) {
      return "You are trying to add item which is after its due date";
    }
    return null;
  }

  void onTap() async {
    DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 1000))
    );
    dateTime ??= DateTime.now();
    setState(() {
      controller.text = dateTime!.toIso8601String().toString();
    });
  }
}