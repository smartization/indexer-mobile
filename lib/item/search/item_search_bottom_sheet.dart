import 'package:flutter/material.dart';
import 'package:indexer_client/category/category_service.dart';
import 'package:indexer_client/common/barcode_input.dart';
import 'package:indexer_client/common/exceptions/exception_resolver.dart';

import '../../api/api_spec.swagger.dart';
import '../../common/exceptions/ApiException.dart';
import '../../place/place_service.dart';

part "category_name_search.dart";

part "ean_search.dart";

part "item_name_search.dart";

part "place_name_search.dart";

class ItemSearchBottomSheet extends StatefulWidget {
  final ValueChanged<String> onNewSearchPhrase;
  final List<num> selectedCategories;
  final List<num> selectedPlaces;
  final Function(CategoryDTO) onNewCategorySelected;
  final Function(PlaceDTO) onNewPlaceSelected;
  final Function(String) onNewEan;
  final String selectedSearchPhrase;
  final String selectedEan;

  const ItemSearchBottomSheet(
      {Key? key,
      required this.onNewSearchPhrase,
      required this.selectedCategories,
      required this.onNewCategorySelected,
      required this.onNewPlaceSelected,
      required this.selectedPlaces,
      required this.selectedSearchPhrase,
      required this.selectedEan,
      required this.onNewEan})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemSearchBottomSheetState(
      onNewSearchPhrase: onNewSearchPhrase,
      selectedCategories: selectedCategories,
      onNewCategorySelected: onNewCategorySelected,
      onNewPlaceSelected: onNewPlaceSelected,
      selectedPlaces: selectedPlaces,
      selectedSearchPhrase: selectedSearchPhrase,
      selectedEan: selectedEan,
      onNewEan: onNewEan);
}

class _ItemSearchBottomSheetState extends State<ItemSearchBottomSheet> {
  final ValueChanged<String> onNewSearchPhrase;
  final List<num> selectedCategories;
  final List<num> selectedPlaces;
  final Function(CategoryDTO) onNewCategorySelected;
  final Function(PlaceDTO) onNewPlaceSelected;
  final Function(String) onNewEan;
  final String selectedSearchPhrase;
  final String selectedEan;
  final TextEditingController eanController = TextEditingController();
  late List<CategoryDTO>? _categories;
  late List<PlaceDTO>? _places;
  late ExceptionResolver _exceptionResolver;
  late CategoryService _categoryService;
  late PlaceService _placeService;

  _ItemSearchBottomSheetState(
      {Key? key,
      required this.onNewSearchPhrase,
      required this.selectedCategories,
      required this.onNewCategorySelected,
      required this.onNewPlaceSelected,
      required this.selectedPlaces,
      required this.selectedSearchPhrase,
      required this.selectedEan,
      required this.onNewEan}) {
    _categories = List.empty(growable: true);
    _places = List.empty(growable: true);
    eanController.text = selectedEan;
  }

  @override
  void initState() {
    super.initState();
    _exceptionResolver = ExceptionResolver(context: context);
    _categoryService = CategoryService(
        context: context, exceptionResolver: _exceptionResolver);
    _categoryService.getAll().then((value) {
      setState(() => _categories = value);
    }).catchError((e) {
      _categories = null;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${e.code} - ${e.reason}")));
    }, test: (e) => e is ApiException);
    _placeService =
        PlaceService(context: context, exceptionResolver: _exceptionResolver);
    _placeService.getAll().then((value) {
      setState(() => _places = value);
    }).catchError((e) {
      _categories = null;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${e.code} - ${e.reason}")));
    }, test: (e) => e is ApiException);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text(
            "Search",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          _ItemNameSearchBox(
            onChanged: onNewSearchPhrase,
            initialValue: selectedSearchPhrase,
          ),
          _EanSearch(initialValue: selectedEan, onNewEan: onNewEan),
          createLabel("Categories"),
          _CategoryNameSearchBox(
              selectedCategories: selectedCategories,
              allCategories: _categories,
              onNewSelected: (category) {
                onNewCategorySelected(category);
                setState(() {});
              }),
          createDivider(),
          createLabel("Places"),
          _PlaceSearchBox(
              selectedPlaces: selectedPlaces,
              allPlaces: _places,
              onNewSelected: (place) {
                onNewPlaceSelected(place);
                setState(() {});
              })
        ],
      ),
    );
  }

  Widget createLabel(String s) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        s,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  createDivider() {
    return Divider(
      color: Colors.grey.shade300,
      indent: 30,
      endIndent: 30,
    );
  }
}
