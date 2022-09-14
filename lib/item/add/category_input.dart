import 'package:flutter/material.dart';
import 'package:indexer_client/api/api_spec.swagger.dart';
import 'package:indexer_client/category/category_service.dart';

import '../../common/exceptions/exception_resolver.dart';
import '../../common/loading_indicator.dart';

class ItemCategoryInput extends StatefulWidget {
  final CategoryDTO? value;
  final ExceptionResolver exceptionResolver;
  final Function(CategoryDTO?) onChanged;

  const ItemCategoryInput(
      {Key? key,
      required this.exceptionResolver,
      required this.onChanged,
      this.value})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemCategoryInputState(
      onChanged: onChanged, exceptionResolver: exceptionResolver, value: value);
}

class _ItemCategoryInputState extends State<ItemCategoryInput> {
  CategoryDTO? value;
  Function(CategoryDTO?) onChanged;
  late Future<List<CategoryDTO>> _categories;
  late CategoryService _categoryService;
  final ExceptionResolver exceptionResolver;

  _ItemCategoryInputState(
      {required this.onChanged, required this.exceptionResolver, this.value});

  @override
  void initState() {
    super.initState();
    _categoryService =
        CategoryService(context: context, exceptionResolver: exceptionResolver);
    _categories = _categoryService.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _categories, builder: builder);
  }

  Widget builder(
      BuildContext context, AsyncSnapshot<List<CategoryDTO>> snapshot) {
    if (snapshot.hasData) {
      List<DropdownMenuItem<CategoryDTO>> dropdownItems = snapshot.data!
          .map((e) =>
              DropdownMenuItem<CategoryDTO>(value: e, child: Text(e.name)))
          .toList();
      return DropdownButtonFormField<CategoryDTO?>(
        value: value,
        items: dropdownItems,
        onChanged: onChanged,
        decoration: InputDecoration(labelText: "Category"),
      );
    } else if (snapshot.hasError) {
      return Text("Error: ${snapshot.error}");
    } else {
      return const LoadingIndicator(title: "Downloading categories");
    }
  }
}
