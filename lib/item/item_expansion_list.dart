import 'package:flutter/material.dart';

import '../api/api_spec.swagger.dart';
import 'expansion_panel/item_expansion_panel.dart';

class ItemExpansionList extends StatelessWidget {
  final List<ItemDTO> items;
  final ExpansionPanelCallback? onExpanded;
  final Function(ItemDTO) onItemDelete;
  final Function(ItemDTO) onItemEdited;
  final List<bool> expandedList;
  final Function(int?, ItemDTO) onIncrement;
  final Function(int?, ItemDTO) onDecrement;
  final Future<void> Function()? onRefresh;
  final bool refreshable;

  const ItemExpansionList(
      {Key? key,
      required items,
      this.onExpanded,
      expandedList,
      required this.onItemDelete,
      required this.onItemEdited,
      required this.onIncrement,
      required this.onDecrement,
      this.onRefresh,
      this.refreshable = false})
      : expandedList = expandedList ?? const [],
        items = items ?? const [],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!refreshable) {
      return getList();
    } else {
      return RefreshIndicator(
        onRefresh: onRefresh ?? () async {},
        child: getList(),
      );
    }
  }

  List<ExpansionPanel> generateChildren() {
    return items
        .asMap()
        .entries
        .map((e) => ItemExpansionPanel.from(e.value, expandedList[e.key],
            onItemDelete, onItemEdited, onIncrement, onDecrement))
        .toList();
  }

  getList() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ExpansionPanelList(
        children: generateChildren(),
        expansionCallback: onExpanded,
      ),
    );
  }
}