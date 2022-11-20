import 'package:flutter/material.dart';
import 'package:indexer_client/common/exceptions/exception_resolver.dart';
import 'package:indexer_client/item/add/add_item_popup.dart';
import 'package:indexer_client/item/barcode_service.dart';
import 'package:indexer_client/item/filter/item_order_bottom_sheet.dart';
import 'package:indexer_client/item/filter/orders.dart';
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
  late ItemService _itemService;
  late BarcodeService _barcodeService;
  late ExceptionResolver _exceptionResolver;
  late List<num> _selectedCategories;
  late List<num> _selectedPlaces;
  int? _selectedDueDate;
  List<ItemDTO>? _items;
  String? _searchNamePhrase;
  String? _selectedEan;
  ItemOrderColumn? _selectedOrderColumn;
  ItemSortOrder? _selectedSortOrder;

  _ItemMainState() {
    _selectedCategories = List.empty(growable: true);
    _selectedPlaces = List.empty(growable: true);
    _selectedDueDate = 0;
    _selectedOrderColumn = ItemOrderColumn.NAME;
    _selectedSortOrder = ItemSortOrder.ASCENDING;
  }

  @override
  void initState() {
    super.initState();
    _barcodeService = BarcodeService(context: context);
    _exceptionResolver = ExceptionResolver(context: context);
    _itemService =
        ItemService(context: context, exceptionResolver: _exceptionResolver);
    FirebaseIntegration.initMessageListener(context);
    FirebaseIntegration.startSyncingToken(context);
  }

  @override
  Widget build(BuildContext context) {
    // this token should be synced here as this is first place where
    // application has loaded net stack
    return Scaffold(
      appBar: AppBar(
        title: const Text("Items"),
      ),
      body: Consumer<AppState>(
        builder: bodyBuilder,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: FloatingActionButton(
                onPressed: onAddButtonPressed,
                tooltip: 'Add Item',
                child: const Icon(Icons.add)),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: FloatingActionButton(
              onPressed: onSearchButtonPressed,
              tooltip: "Search item",
              child: const Icon(Icons.search),
            ),
          ),
          FloatingActionButton(
            onPressed: _onOrderButtonPressed,
            tooltip: "Order item",
            child: const Icon(Icons.sort_by_alpha),
          )
        ],
      ),
      drawer:
          const CommonDrawer(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget bodyBuilder(BuildContext context, AppState appState, Widget? widget) {
    _items = appState.items!;
    return ItemExpansionList(
      items: _sortItems(_filterItems(_items)),
      refreshable: true,
    );
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
        if (value != null) {
          Provider.of<AppState>(context, listen: false).addItem(value);
          Provider.of<AppState>(context, listen: false)
              .addExpandedForItem(value);
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Saving")));
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
              onNewSearchPhrase: _searchBoxChanged,
              onNewCategorySelected: _onNewCategorySelected,
              onNewPlaceSelected: _onNewPlaceSelected,
              onNewEan: _onNewEan,
              onNewDueDate: _onNewDueDate,
              selectedCategories: _selectedCategories,
              selectedPlaces: _selectedPlaces,
              selectedSearchPhrase: _searchNamePhrase ?? "",
              selectedEan: _selectedEan ?? "",
              selectedDueDate: _selectedDueDate!,
            ),
          );
        });
  }

  _searchBoxChanged(String value) {
    setState(() => _searchNamePhrase = value);
  }

  _filterItems(List<ItemDTO>? items) {
    List<ItemDTO>? finalItems = items;
    if (_searchNamePhrase != null && _searchNamePhrase!.isNotEmpty) {
      finalItems = finalItems!
          .where((element) => element.name
              .toLowerCase()
              .contains(_searchNamePhrase!.toLowerCase()))
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
          return element.barcode!.contains(_selectedEan!);
        }
      }).toList();
    }
    if (_selectedDueDate! > 0) {
      finalItems = finalItems!.where((element) {
        if (element.dueDate == null) {
          return false;
        } else {
          DateTime dueDate = element.dueDate!;
          DateTime endDate =
          DateTime.now().add(Duration(days: _selectedDueDate!));
          return dueDate.isBefore(endDate);
        }
      }).toList();
    }
    return finalItems;
  }

  _onNewCategorySelected(CategoryDTO category) {
    setState(() {
      if (_selectedCategories.contains(category.id)) {
        _selectedCategories.remove(category.id);
      } else {
        _selectedCategories.add(category.id!);
      }
    });
  }

  _onNewPlaceSelected(PlaceDTO place) {
    setState(() {
      if (_selectedPlaces.contains(place.id)) {
        _selectedPlaces.remove(place.id);
      } else {
        _selectedPlaces.add(place.id!);
      }
    });
  }

  _onNewEan(String newEan) {
    setState(() => _selectedEan = newEan);
  }

  _onNewDueDate(int newDueDate) {
    setState(() => _selectedDueDate = newDueDate);
  }

  _onOrderButtonPressed() {
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
            child: ItemOrderBottomSheet(
              selectedOrderColumn: _selectedOrderColumn ?? ItemOrderColumn.NAME,
              selectedSortOrder: _selectedSortOrder ?? ItemSortOrder.DESCENDING,
              onNewOrderColumn: _onNewOrderColumn,
              onNewSortOrder: _onNewSortOrderColumn,
            ),
          );
        });
  }

  _onNewOrderColumn(ItemOrderColumn? column) {
    setState(() => _selectedOrderColumn = column);
  }

  _onNewSortOrderColumn(ItemSortOrder? sort) {
    setState(() => _selectedSortOrder = sort);
  }

  _sortItems(List<ItemDTO>? items) {
    items!.sort((itemA, itemB) {
      if (_selectedOrderColumn == ItemOrderColumn.NAME) {
        return _sortByName(itemA, itemB);
      } else {
        return _sortByDate(itemA, itemB);
      }
    });
    return items;
  }

  _sortByName(ItemDTO itemA, ItemDTO itemB) {
    String itemAName = itemA.name.toLowerCase();
    String itemBName = itemB.name.toLowerCase();
    if (_selectedSortOrder == ItemSortOrder.DESCENDING) {
      return -itemAName.compareTo(itemBName);
    } else {
      return itemAName.compareTo(itemBName);
    }
  }

  _sortByDate(ItemDTO itemA, ItemDTO itemB) {
    DateTime? itemADate = itemA.dueDate;
    DateTime? itemBDate = itemB.dueDate;
    if (itemADate == null && itemBDate == null) {
      return 0;
    }
    if (_selectedSortOrder == ItemSortOrder.DESCENDING) {
      if (itemADate == null) {
        return 1;
      }
      if (itemBDate == null) {
        return -1;
      }
      return -itemADate.compareTo(itemBDate);
    } else {
      if (itemADate == null) {
        return 1;
      }
      if (itemBDate == null) {
        return -1;
      }
      return itemADate.compareTo(itemBDate);
    }
  }
}