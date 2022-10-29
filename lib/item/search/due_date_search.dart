part of "item_search_bottom_sheet.dart";

class _DueDateSearch extends StatelessWidget {
  final Function(int) onChanged;
  int initialValue;

  _DueDateSearch(
      {super.key, required this.onChanged, required this.initialValue});

  @override
  Widget build(BuildContext context) {
    String text = initialValue <= 0 ? "" : initialValue.toString();
    TextEditingController controller = TextEditingController();
    controller
      ..text = text
      ..selection = TextSelection.collapsed(offset: text.length);
    return Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                enabled: initialValue > 0,
                onChanged: _onNumberChanged,
                controller: controller,
                decoration: InputDecoration(
                  label: const Text("Due date in (days)"),
                  icon: const Icon(Icons.calendar_today),
                  helperText: _generateDate(initialValue),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Checkbox(
              value: initialValue > 0,
              onChanged: _onCheckboxChanged,
            )
          ],
        ));
  }

  void _onNumberChanged(String value) {
    if (value.isNotEmpty) {
      onChanged(int.parse(value));
    }
  }

  void _onCheckboxChanged(bool? value) {
    if (value!) {
      onChanged(5);
    } else {
      onChanged(0);
    }
  }

  String _generateDate(int initialValue) {
    DateTime dateTime = DateTime.now().add(Duration(days: initialValue));
    return "${dateTime.day}-${dateTime.month}-${dateTime.year}";
  }
}
