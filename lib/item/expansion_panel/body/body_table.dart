part of "body_main.dart";

class _ItemTable extends StatelessWidget {
  late Map<String, String?> tableValues;

  final ItemDTO item;

  _ItemTable({required this.item}) {
    tableValues = {
      "Name": item.name,
      "Description": item.description,
      "Storage Place":
          item.storagePlace == null ? "Not specified" : item.storagePlace!.name,
      "Due Date": item.dueDate == null
          ? null
          : "${item.dueDate!.day}/${item.dueDate!.month}/${item.dueDate!.year}",
      "Barcode": item.barcode,
    };
    tableValues.removeWhere((key, value) => value == null || value.isEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      border: const TableBorder(
          bottom: BorderSide(color: Colors.grey),
          horizontalInside: BorderSide(color: Colors.grey)),
      children: _generateChildren(),
    );
  }

  List<TableRow> _generateChildren() {
    return tableValues
        .map((key, value) => MapEntry(key, _createTableRow(key, value)))
        .values
        .toList();
  }

  TableRow _createTableRow(String title, String? value) {
    return TableRow(children: [
      Container(
        padding: const EdgeInsets.all(10),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(10),
        child: Text(
          value!,
          style: const TextStyle(
            height: 1,
          ),
        ),
      )
    ]);
  }
}
