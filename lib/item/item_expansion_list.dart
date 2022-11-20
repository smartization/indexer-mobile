import 'package:flutter/material.dart';
import 'package:indexer_client/state.dart';
import 'package:provider/provider.dart';

import '../api/api_spec.swagger.dart';
import 'expansion_panel/item_expansion_panel.dart';
import 'item_service.dart';

class ItemExpansionList extends StatelessWidget {
  final List<ItemDTO> items;
  final bool refreshable;

  const ItemExpansionList(
      {Key? key, required this.items, expandedList, this.refreshable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!refreshable) {
      return getList(context);
    } else {
      return RefreshIndicator(
        onRefresh: () => _onRefresh(context),
        child: getList(context),
      );
    }
  }

  List<ExpansionPanel> generateChildren(BuildContext context) {
    return items.map((e) => ItemExpansionPanel.from(e, context)).toList();
  }

  getList(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ExpansionPanelList(
        children: generateChildren(context),
        expansionCallback: (idx, state) => _onExpanded(idx, state, context),
      ),
    );
  }

  void _onExpanded(int panelIndex, bool isExpanded, BuildContext context) {
    ItemDTO item = items.elementAt(panelIndex);
    Provider.of<AppState>(context, listen: false).expandItem(item);
  }

  _onRefresh(BuildContext context) {
    Future<List<ItemDTO>> items =
        ItemService.getInstance(context).getAllItems();
    items.then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Reloaded")));
      Provider.of<AppState>(context).updateItems(value);
    });
  }
}