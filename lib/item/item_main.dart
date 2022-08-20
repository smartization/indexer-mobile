import 'package:flutter/material.dart';
import 'package:indexer_api_client/api.dart';
import 'package:indexer_client/common/loading_indicator.dart';
import 'package:indexer_client/item/item_service.dart';
import 'package:indexer_client/state.dart';
import 'package:provider/provider.dart';

import '../drawer/drawer.dart';
import 'item_expansion_list.dart';

class ItemMain extends StatefulWidget {
  const ItemMain({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemMainState();
}

class _ItemMainState extends State<ItemMain> {
  final List<bool> _expanded = List.filled(4, false);
  ItemService? itemService;
  String serverAddress = "";
  late Future<List<ItemDTO>> _items;

  @override
  void initState() {
    super.initState();
    itemService = ItemService(context: context);
    _items = itemService!.getAllItems();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<AppState>(context).addListener(() {
      setState(() {
        _items = itemService!.getAllItems();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Items"),
      ),
      body: FutureBuilder(
        future: _items,
        builder: builder,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      drawer: const CommonDrawer(),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void onExpanded(int panelIndex, bool isExpanded) {
    setState(() => {
      _expanded[panelIndex] = !isExpanded
    });
  }

  Widget builder(BuildContext context, AsyncSnapshot<List<ItemDTO>> snapshot) {
    if (snapshot.hasData) {
      return ItemExpansionList(items: snapshot.data, onExpanded: onExpanded, expandedList: _expanded);
    } else if (snapshot.hasError) {
      return Text("Error: ${snapshot.error}");
    }
    else {
      return const LoadingIndicator(title: "Downloading items");
    }
  }
}