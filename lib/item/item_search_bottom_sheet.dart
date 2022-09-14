import 'package:flutter/material.dart';
import 'package:indexer_client/category/category_service.dart';
import 'package:indexer_client/common/exceptions/exception_resolver.dart';

import '../api/api_spec.swagger.dart';
import '../common/exceptions/ApiException.dart';
import '../place/place_service.dart';

class ItemSearchBottomSheet extends StatefulWidget {
  final ValueChanged<String> onNewSearchPhrase;
  final List<num> selectedCategories;
  final List<num> selectedPlaces;
  final Function(CategoryDTO) onNewCategorySelected;
  final Function(PlaceDTO) onNewPlaceSelected;

  const ItemSearchBottomSheet(
      {Key? key,
      required this.onNewSearchPhrase,
      required this.selectedCategories,
      required this.onNewCategorySelected,
      required this.onNewPlaceSelected,
      required this.selectedPlaces})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemSearchBottomSheetState(
      onNewSearchPhrase: onNewSearchPhrase,
      selectedCategories: selectedCategories,
      onNewCategorySelected: onNewCategorySelected,
      onNewPlaceSelected: onNewPlaceSelected,
      selectedPlaces: selectedPlaces);
}

class _ItemSearchBottomSheetState extends State<ItemSearchBottomSheet> {
  final ValueChanged<String> onNewSearchPhrase;
  final List<num> selectedCategories;
  final List<num> selectedPlaces;
  final Function(CategoryDTO) onNewCategorySelected;
  final Function(PlaceDTO) onNewPlaceSelected;
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
      required this.selectedPlaces}) {
    _categories = List.empty(growable: true);
    _places = List.empty(growable: true);
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
          _ItemNameSearchBox(onChanged: onNewSearchPhrase),
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

class _ItemNameSearchBox extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _ItemNameSearchBox({Key? key, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        onChanged: onChanged,
        decoration: const InputDecoration(
          label: Text("Name"),
          icon: Icon(Icons.search),
        ),
      ),
    );
  }
}

class _CategoryNameSearchBox extends StatelessWidget {
  final List<num> selectedCategories;
  final List<CategoryDTO>? allCategories;
  final Function(CategoryDTO) onNewSelected;

  const _CategoryNameSearchBox(
      {required this.selectedCategories,
      required this.allCategories,
      required this.onNewSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: _generateChildren(),
    );
  }

  List<Widget> _generateChildren() {
    if (allCategories == null) {
      return [const Text("Cannot load categories")];
    } else {
      return allCategories!.map((e) => _createSingleChild(e)).toList();
    }
  }

  Widget _createSingleChild(CategoryDTO v) {
    return ActionChip(
      label: Text(v.name),
      onPressed: () => onNewSelected(v),
      avatar: selectedCategories.contains(v.id)
          ? const Icon(
              Icons.check_circle_outline,
            )
          : Icon(
              Icons.check_circle_outline,
              color: Colors.grey.shade500,
            ),
      backgroundColor: selectedCategories.contains(v.id)
          ? Colors.blue.shade400
          : Colors.grey.shade300,
      // backgroundColor: selectedCategories.contains(v.id!) ? Colors.green : Colors.grey,
    );
  }
}

class _PlaceSearchBox extends StatelessWidget {
  final List<num> selectedPlaces;
  final List<PlaceDTO>? allPlaces;
  final Function(PlaceDTO) onNewSelected;

  const _PlaceSearchBox(
      {required this.selectedPlaces,
      required this.allPlaces,
      required this.onNewSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: _generateChildren(),
    );
  }

  List<Widget> _generateChildren() {
    if (allPlaces == null) {
      return [const Text("Cannot load places")];
    } else {
      return allPlaces!.map((e) => _createSingleChild(e)).toList();
    }
  }

  Widget _createSingleChild(PlaceDTO v) {
    return ActionChip(
      label: Text(v.name),
      onPressed: () => onNewSelected(v),
      avatar: selectedPlaces.contains(v.id)
          ? const Icon(
              Icons.check_circle_outline,
            )
          : Icon(
              Icons.check_circle_outline,
              color: Colors.grey.shade500,
            ),
      backgroundColor: selectedPlaces.contains(v.id)
          ? Colors.blue.shade400
          : Colors.grey.shade300,
    );
  }
}
