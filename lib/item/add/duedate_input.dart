import 'package:flutter/material.dart';

class ItemDueDateInput extends StatefulWidget {
  final TextEditingController controller;
  final bool addNew;

  const ItemDueDateInput(
      {Key? key, required this.controller, required this.addNew})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _ItemDueDateInputState(controller: controller, addNew: addNew);
}

class _ItemDueDateInputState extends State<ItemDueDateInput> {
  final TextEditingController controller;
  final bool addNew;
  late bool _addDueDate;

  _ItemDueDateInputState({required this.controller, required this.addNew}) {
    _addDueDate = addNew;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextFormField(
          enabled: _addDueDate,
          decoration: const InputDecoration(labelText: "Due date"),
          validator: validate,
          readOnly: true,
          onTap: onTap,
          controller: controller,
        )),
        Checkbox(value: _addDueDate, onChanged: addDueDateChanged)
      ],
    );
  }

  String? validate(String? value) {
    if (!_addDueDate) {
      return null;
    }
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
        lastDate: DateTime.now().add(const Duration(days: 1000000)));
    dateTime ??= DateTime.now();
    setState(() {
      controller.text = dateTime!.toIso8601String().toString();
    });
  }

  void addDueDateChanged(bool? value) {
    setState(() => _addDueDate = value!);
  }
}