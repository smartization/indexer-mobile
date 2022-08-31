import 'package:flutter/material.dart';

import '../../../api/api_spec.swagger.dart';

part "body_table.dart";

part "bottom_buttons.dart";

class ItemExpansionPanelBody extends StatelessWidget {
  final ItemDTO item;
  final Function(ItemDTO) onDelete;
  final Function(ItemDTO) onEdit;

  const ItemExpansionPanelBody(
      {Key? key,
      required this.item,
      required this.onDelete,
      required this.onEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: [
            _ItemTable(item: item),
            _BottomButtons(
              onDelete: () => onDelete(item),
              onEdit: () => onEdit(item),
            )
          ],
        )
    );
  }
}