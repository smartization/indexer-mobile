import 'package:flutter/material.dart';
import 'package:indexer_client/common/loading_indicator.dart';
import 'package:indexer_client/item/add/add_item_popup.dart';
import 'package:indexer_client/item/item_service.dart';
import 'package:indexer_client/state.dart';
import 'package:provider/provider.dart';

import '../api/api_spec.swagger.dart';
import '../common/exceptions/ApiException.dart';
import '../drawer/drawer.dart';
import 'item_expansion_list.dart';

class ItemMain extends StatefulWidget {
  const ItemMain({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemMainState();
}

class _ItemMainState extends State<ItemMain> {
  List<bool>? _expanded;
  late ItemService itemService;
  late Future<List<ItemDTO>> _itemsFuture;
  List<ItemDTO>? _items;

  @override
  void initState() {
    super.initState();
    itemService = ItemService(context: context);
    _itemsFuture = itemService.getAllItems();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<AppState>(context).addListener(() {
      setState(() {
        _itemsFuture = itemService.getAllItems();
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
        future: _itemsFuture,
        builder: futureBuilder,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddButtonPressed,
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
      drawer: const CommonDrawer(),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void onExpanded(int panelIndex, bool isExpanded) {
    setState(() => {
      _expanded![panelIndex] = !isExpanded
    });
  }

  Widget futureBuilder(BuildContext context, AsyncSnapshot<List<ItemDTO>> snapshot) {
    if (snapshot.hasData) {
      _items = snapshot.data!;
      // sets _expanded only for first data fetch from api
      _expanded ??= List.filled(_items!.length, false, growable: true);
      return ItemExpansionList(
          items: _items,
          onExpanded: onExpanded,
          onItemDelete: onItemDeleted,
          expandedList: _expanded);
    } else if (snapshot.hasError) {
      return Text("Error: ${snapshot.error}");
    }
    else {
      return const LoadingIndicator(title: "Downloading items");
    }
  }

  void onAddButtonPressed() async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Saving")));
    Future<ItemDTO?> createdItem = showDialog<ItemDTO>(
      context: context,
      builder: (context) {
        return AddItemPopup(itemService: itemService);
      },
    );
    createdItem.then((value) {
      setState(() {
        if (value != null) _items!.add(value);
        // this will be processed by FutureBuilder so UI can be drawn
        _itemsFuture = Future.value(_items);
        // if some new item was added then it is as last item on list
        // add it to _expanded register
        if (_expanded!.length != _items!.length) {
          _expanded!.addAll(
              List.filled((_items!.length - _expanded!.length).abs(), false));
        }
      });
    });
  }

  void onItemDeleted(ItemDTO item) {
    itemService.delete(item).then((value) {
      int idx = _items!.indexOf(item);
      if (idx >= 0) {
        setState(() {
          _items!.remove(item);
          _expanded!.removeAt(idx);
        });
      }
    }).catchError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text((error as ApiException).reason)));
    }, test: (o) => o is ApiException);
  }
}