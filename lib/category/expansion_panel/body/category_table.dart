part of "body_main.dart";

class _CategoryTable extends StatelessWidget {
  final CategoryDTO category;
  late Map<String, String?> tableValues;

  _CategoryTable({required this.category}) {
    tableValues = {
      "Name": category.name,
      "Description": category.description,
    };
    tableValues.removeWhere((key, value) => value == null || value.isEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Table(
        border: const TableBorder(
            // bottom: BorderSide(color: Colors.grey),
            horizontalInside: BorderSide(color: Colors.grey)),
        children: _generateChildren());
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
          style: TextStyle(
              fontWeight: FontWeight.bold,
              height: 1,
              color: Colors.grey.shade800),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(10),
        child: Text(
          value!,
          style: TextStyle(height: 1, color: Colors.grey.shade800),
        ),
      )
    ]);
  }
}
