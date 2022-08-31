import 'package:flutter/material.dart';
import 'package:indexer_client/common/exceptions/exception_resolver.dart';
import 'package:indexer_client/common/loading_indicator.dart';
import 'package:indexer_client/item/add/add_item_popup.dart';
import 'package:indexer_client/item/barcode_service.dart';
import 'package:indexer_client/item/item_service.dart';
import 'package:indexer_client/state.dart';
import 'package:provider/provider.dart';

import '../api/api_spec.swagger.dart';
import '../drawer/drawer.dart';
import 'item_expansion_list.dart';

class ItemMain extends StatefulWidget {
  const ItemMain({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemMainState();
}

class _ItemMainState extends State<ItemMain> {
  List<bool>? _expanded;
  late ItemService _itemService;
  late BarcodeService _barcodeService;
  late Future<List<ItemDTO>> _itemsFuture;
  late ExceptionResolver _exceptionResolver;
  List<ItemDTO>? _items;

  @override
  void initState() {
    super.initState();
    _barcodeService = BarcodeService(context: context);
    _exceptionResolver = ExceptionResolver(context: context);
    _itemService =
        ItemService(context: context, exceptionResolver: _exceptionResolver);
    _itemsFuture = _itemService.getAllItems();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<AppState>(context).addListener(() {
      setState(() {
        _itemsFuture = _itemService.getAllItems();
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
          onItemEdited: onItemEdited,
          expandedList: _expanded);
    } else if (snapshot.hasError) {
      return Text("Error: ${snapshot.error.toString()}");
    }
    else {
      return const LoadingIndicator(title: "Downloading items");
    }
  }

  void onAddButtonPressed() async {
    Future<ItemDTO?> createdItem = showDialog<ItemDTO>(
      context: context,
      builder: (context) {
        return ModifyItemPopup(
          itemService: _itemService,
          barcodeService: _barcodeService,
          exceptionResolver: _exceptionResolver,
          addNew: true,
        );
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
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Saving")));
        }
      });
    });
  }

  void onItemDeleted(ItemDTO item) {
    _itemService
        .itemDeleteListener(item, _items!, _expanded!)
        .then((value) => setState(() {}));
  }

  onItemEdited(ItemDTO item) {
    Future<ItemDTO?> editedItem = showDialog<ItemDTO>(
        context: context,
        builder: (ctx) => ModifyItemPopup(
              itemService: _itemService,
              barcodeService: _barcodeService,
              exceptionResolver: _exceptionResolver,
              addNew: false,
              item: item,
            ));
    _itemService
        .onItemEditedListener(editedItem, item, _items!)
        .then((value) => setState(() {}));
  }
}