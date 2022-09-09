part of 'body_main.dart';

class _ItemsList extends StatefulWidget {
  final PlaceDTO place;

  const _ItemsList({required this.place});

  @override
  State<StatefulWidget> createState() => _ItemsListState(place: place);
}

class _ItemsListState extends State<_ItemsList> {
  final PlaceDTO place;
  late Future<List<ItemDTO>> _itemsFuture;
  late List<ItemDTO>? _items;
  late ItemService _itemService;
  late BarcodeService _barcodeService;
  late ExceptionResolver _exceptionResolver;
  List<bool>? _expanded;

  _ItemsListState({required this.place});

  @override
  initState() {
    _exceptionResolver = ExceptionResolver(context: context);
    _itemService =
        ItemService(context: context, exceptionResolver: _exceptionResolver);
    _barcodeService = BarcodeService(context: context);
    _itemsFuture = _itemService.getAllItemsOnPlace(place.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _itemsFuture, builder: builder);
  }

  Widget builder(BuildContext context, AsyncSnapshot<List<ItemDTO>> snapshot) {
    if (snapshot.hasData) {
      _items = snapshot.data;
      _expanded ??= List.filled(_items!.length, false, growable: true);
      return Container(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: ItemExpansionList(
            items: _items,
            onExpanded: onExpanded,
            expandedList: _expanded,
            onItemDelete: onItemDelete,
            onItemEdited: onItemEdit,
            onIncrement: onDecrementOrIncrement,
            onDecrement: onDecrementOrIncrement,
          ));
    } else if (snapshot.hasError) {
      return Text("Error: ${snapshot.error.toString()}");
    } else {
      return const LoadingIndicator(title: "Getting items for this place");
    }
  }

  void onExpanded(int panelIndex, bool isExpanded) {
    setState(() {
      _expanded![panelIndex] = !isExpanded;
    });
  }

  onItemDelete(ItemDTO item) {
    _itemService
        .itemDeleteListener(item, _items!, _expanded!)
        .then((_) => setState(() {}));
  }

  onItemEdit(ItemDTO item) {
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
        .then((_) => setState(() {}));
  }

  onDecrementOrIncrement(int? value, ItemDTO item) {
    ItemDTO newItem = $ItemDTOExtension(item).copyWith(quantity: value!);
    _itemService
        .saveAndUpdateList(newItem, item, _items!)
        .then((value) => setState(() {}));
  }
}
