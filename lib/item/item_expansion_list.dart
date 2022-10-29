import 'package:flutter/material.dart';

import '../api/api_spec.swagger.dart';
import 'expansion_panel/item_expansion_panel.dart';

class ItemExpansionList extends StatelessWidget {
  final List<ItemDTO> items;
  final Function(ItemDTO, bool)? onExpanded;
  final Function(ItemDTO) onItemDelete;
  final Function(ItemDTO) onItemEdited;
  final Map<ItemDTO, bool> expanded;
  final Function(int?, ItemDTO) onIncrement;
  final Function(int?, ItemDTO) onDecrement;
  final Future<void> Function()? onRefresh;
  final bool refreshable;

  const ItemExpansionList(
      {Key? key,
      required this.items,
      this.onExpanded,
      expandedList,
      required this.onItemDelete,
      required this.onItemEdited,
      required this.onIncrement,
      required this.onDecrement,
      this.onRefresh,
      this.refreshable = false,
      required this.expanded})
      : super(key: key);

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
        .map((e) => ItemExpansionPanel.from(e, expanded[e]!, onItemDelete,
            onItemEdited, onIncrement, onDecrement))
        .toList();
  }

  getList() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ExpansionPanelList(
        children: generateChildren(),
        expansionCallback: _onExpanded,
      ),
    );
  }

  void _onExpanded(int panelIndex, bool isExpanded) {
    ItemDTO item = items.elementAt(panelIndex);
    if (onExpanded != null) {
      onExpanded!(item, isExpanded);
    }
  }
}