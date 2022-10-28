import 'package:flutter/material.dart';
import 'package:indexer_client/common/exceptions/exception_resolver.dart';
import 'package:indexer_client/common/loading_indicator.dart';
import 'package:indexer_client/item/add/add_item_popup.dart';
import 'package:indexer_client/item/barcode_service.dart';
import 'package:indexer_client/item/item_service.dart';
import 'package:indexer_client/item/search/item_search_bottom_sheet.dart';
import 'package:indexer_client/state.dart';
import 'package:provider/provider.dart';

import '../api/api_spec.swagger.dart';
import '../common/firebase.dart';
import '../drawer/drawer.dart';
import 'item_expansion_list.dart';

class ItemMain extends StatefulWidget {
  const ItemMain({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemMainState();
}

class _ItemMainState extends State<ItemMain> with TickerProviderStateMixin {
  List<bool>? _expanded;
  late ItemService _itemService;
  late BarcodeService _barcodeService;
  late Future<List<ItemDTO>> _itemsFuture;
  late ExceptionResolver _exceptionResolver;
  late List<num> _selectedCategories;
  late List<num> _selectedPlaces;
  List<ItemDTO>? _items;
  String? _searchNamePhrase;
  String? _selectedEan;

  _ItemMainState() {
    _selectedCategories = List.empty(growable: true);
    _selectedPlaces = List.empty(growable: true);
  }

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
    // this token should be synced here as this is first place where
    // application has loaded net stack
    FirebaseIntegration.syncToken(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Items"),
      ),
      body: FutureBuilder(
        future: _itemsFuture,
        builder: futureBuilder,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: FloatingActionButton(
                onPressed: onAddButtonPressed,
                tooltip: 'Add Item',
                child: const Icon(Icons.add)),
          ),
          FloatingActionButton(
            onPressed: onSearchButtonPressed,
            tooltip: "Search item",
            child: const Icon(Icons.search),
          )
        ],
      ),
      drawer:
      const CommonDrawer(), // This trailing comma makes auto-formatting nicer for build methods.
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
        items: filterItems(_items),
        onExpanded: onExpanded,
        onItemDelete: onItemDeleted,
        onItemEdited: onItemEdited,
        expandedList: _expanded,
        onDecrement: onDecrementOrIncrement,
        onIncrement: onDecrementOrIncrement,
        onRefresh: onItemListRefresh,
        refreshable: true,
      );
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

  void onSearchButtonPressed() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (ctx) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: ItemSearchBottomSheet(
              onNewSearchPhrase: searchBoxChanged,
              onNewCategorySelected: onNewCategorySelected,
              onNewPlaceSelected: onNewPlaceSelected,
              onNewEan: onNewEan,
              selectedCategories: _selectedCategories,
              selectedPlaces: _selectedPlaces,
              selectedSearchPhrase: _searchNamePhrase ?? "",
              selectedEan: _selectedEan ?? "",
            ),
          );
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

  onDecrementOrIncrement(int? value, ItemDTO item) {
    ItemDTO newItem = $ItemDTOExtension(item).copyWith(quantity: value!);
    _itemService
        .saveAndUpdateList(newItem, item, _items!)
        .then((value) => setState(() {}));
  }

  void searchBoxChanged(String value) {
    setState(() => _searchNamePhrase = value);
  }

  filterItems(List<ItemDTO>? items) {
    List<ItemDTO>? finalItems = items;
    if (_searchNamePhrase != null && _searchNamePhrase!.isNotEmpty) {
      finalItems = finalItems!
          .where((element) => element.name.contains(_searchNamePhrase!))
          .toList(growable: true);
    }
    if (_selectedCategories.isNotEmpty) {
      finalItems = finalItems!.where((element) {
        if (element.category == null) {
          return false;
        } else {
          return _selectedCategories.contains(element.category!.id!);
        }
      }).toList();
    }
    if (_selectedPlaces.isNotEmpty) {
      finalItems = finalItems!.where((element) {
        if (element.storagePlace == null) {
          return false;
        } else {
          return _selectedPlaces.contains(element.storagePlace!.id!);
        }
      }).toList();
    }
    if (_selectedEan != null && _selectedEan!.isNotEmpty) {
      finalItems = finalItems!.where((element) {
        if (element.barcode == null) {
          return false;
        } else {
          return element.barcode == _selectedEan;
        }
      }).toList();
    }
    return finalItems;
  }

  onNewCategorySelected(CategoryDTO category) {
    setState(() {
      if (_selectedCategories.contains(category.id)) {
        _selectedCategories.remove(category.id);
      } else {
        _selectedCategories.add(category.id!);
      }
    });
  }

  onNewPlaceSelected(PlaceDTO place) {
    setState(() {
      if (_selectedPlaces.contains(place.id)) {
        _selectedPlaces.remove(place.id);
      } else {
        _selectedPlaces.add(place.id!);
      }
    });
  }

  Future<void> onItemListRefresh() async {
    _itemsFuture = _itemService.getAllItems();
    _itemsFuture.then((value) => ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Reloaded"))));
    setState(() {});
  }

  onNewEan(String newEan) {
    setState(() => _selectedEan = newEan);
  }
}