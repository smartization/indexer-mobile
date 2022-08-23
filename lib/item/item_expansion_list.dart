import 'package:flutter/material.dart';

import '../api/api_spec.swagger.dart';
import 'expansion_panel/item_expansion_panel.dart';

class ItemExpansionList extends StatelessWidget {
  final List<ItemDTO> items;
  final ExpansionPanelCallback? onExpanded;
  final Function(ItemDTO) onItemDelete;
  final List<bool> expandedList;

  const ItemExpansionList(
      {Key? key,
      required items,
      this.onExpanded,
      expandedList,
      required this.onItemDelete})
      : expandedList = expandedList ?? const [],
        items = items ?? const [],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        children: generateChildren(),
        expansionCallback: onExpanded,
      ),
    );
  }

  List<ExpansionPanel> generateChildren() {
    return items.asMap().entries.map((e) =>
            ItemExpansionPanel.from(e.value, expandedList[e.key], onItemDelete))
        .toList();
  }
}