import 'package:flutter/material.dart';
import 'package:indexer_client/item/filter/orders.dart';

part 'item_order_column.dart';

part 'item_sort_order.dart';

class ItemOrderBottomSheet extends StatefulWidget {
  final Function(ItemOrderColumn?) onNewOrderColumn;
  final Function(ItemSortOrder?) onNewSortOrder;
  final ItemOrderColumn selectedOrderColumn;
  final ItemSortOrder selectedSortOrder;

  const ItemOrderBottomSheet(
      {super.key,
      required this.selectedOrderColumn,
      required this.selectedSortOrder,
      required this.onNewOrderColumn,
      required this.onNewSortOrder});

  @override
  State<StatefulWidget> createState() => _ItemOrderBottomSheetState(
      selectedOrderColumn: selectedOrderColumn,
      selectedSortOrder: selectedSortOrder,
      onNewSortOrder: onNewSortOrder,
      onNewOrderColumn: onNewOrderColumn);
}

class _ItemOrderBottomSheetState extends State<ItemOrderBottomSheet> {
  final Function(ItemOrderColumn?) onNewOrderColumn;
  final Function(ItemSortOrder?) onNewSortOrder;
  ItemOrderColumn selectedOrderColumn;
  ItemSortOrder selectedSortOrder;

  _ItemOrderBottomSheetState(
      {required this.selectedOrderColumn,
      required this.selectedSortOrder,
      required this.onNewOrderColumn,
      required this.onNewSortOrder});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Sort",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: _ItemOrderColumn(
            selectedColumn: selectedOrderColumn,
            onChange: onNewOrderColumn,
          ),
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: _ItemSortOrder(
                value: selectedSortOrder,
                onChanged: (sortOrder) {
                  setState(() => selectedSortOrder = sortOrder);
                  onNewSortOrder(sortOrder);
                }),
          ),
        )
      ],
    );
  }
}
