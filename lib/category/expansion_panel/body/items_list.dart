part of 'body_main.dart';

class _ItemsList extends StatefulWidget {
  final CategoryDTO category;

  const _ItemsList({required this.category});

  @override
  State<StatefulWidget> createState() => _ItemsListState(category: category);
}

class _ItemsListState extends State<_ItemsList> {
  final CategoryDTO category;
  late Future<List<ItemDTO>> _itemsFuture;
  late List<ItemDTO>? _items;
  late ItemService _itemService;
  late BarcodeService _barcodeService;
  late ExceptionResolver _exceptionResolver;
  Map<ItemDTO, bool>? _expanded;

  _ItemsListState({required this.category});

  @override
  initState() {
    _exceptionResolver = ExceptionResolver(context: context);
    _itemService =
        ItemService(context: context, exceptionResolver: _exceptionResolver);
    _barcodeService = BarcodeService(context: context);
    _itemsFuture = _itemService.getAllItemsOnCategory(category.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _itemsFuture, builder: builder);
  }

  Widget builder(BuildContext context, AsyncSnapshot<List<ItemDTO>> snapshot) {
    if (snapshot.hasData) {
      _items = snapshot.data;
      _expanded ??= _items!.asMap().map((key, value) => MapEntry(value, false));
      return Container(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: ItemExpansionList(
            items: _items!,
            onExpanded: onExpanded,
            expanded: _expanded!,
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

  void onExpanded(ItemDTO item, bool isExpanded) {
    setState(() {
      _expanded![item] = !isExpanded;
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
