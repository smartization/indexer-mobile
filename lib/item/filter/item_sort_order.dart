part of 'item_order_bottom_sheet.dart';

class _ItemSortOrder extends StatelessWidget {
  final ItemSortOrder value;
  final Function(ItemSortOrder) onChanged;

  const _ItemSortOrder(
      {super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          Text(ItemSortOrder.ASCENDING.name.toLowerCase()),
          Switch(value: _convertSortOrderToBool(), onChanged: _onChanged),
          Text(ItemSortOrder.DESCENDING.name.toLowerCase()),
        ],
      ),
    );
  }

  void _onChanged(bool value) {
    if (value) {
      onChanged(ItemSortOrder.DESCENDING);
    } else {
      onChanged(ItemSortOrder.ASCENDING);
    }
  }

  bool _convertSortOrderToBool() {
    return value == ItemSortOrder.DESCENDING;
  }
}
