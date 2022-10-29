part of 'item_order_bottom_sheet.dart';

class _ItemOrderColumn extends StatelessWidget {
  final ItemOrderColumn selectedColumn;
  final Function(ItemOrderColumn?) onChange;

  const _ItemOrderColumn(
      {super.key, required this.selectedColumn, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ItemOrderColumn>(
      value: selectedColumn,
      items: _generateItems(),
      onChanged: onChange,
      decoration: const InputDecoration(labelText: "Sorting column"),
    );
  }

  _generateItems() {
    return ItemOrderColumn.values
        .map((e) => DropdownMenuItem(
              value: e,
              child: Text(_generateItemName(e)),
            ))
        .toList();
  }

  String _generateItemName(ItemOrderColumn e) {
    String rawName = e.name;
    String withoutUnderscores = rawName.replaceAll("_", " ");
    String lowercase = withoutUnderscores.toLowerCase();
    return lowercase;
  }
}
