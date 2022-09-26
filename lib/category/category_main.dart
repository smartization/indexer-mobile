import 'package:flutter/material.dart';
import 'package:indexer_client/category/add/add_category_popup.dart';
import 'package:indexer_client/category/category_expansion_list.dart';
import 'package:indexer_client/category/category_service.dart';
import 'package:provider/provider.dart';

import '../api/api_spec.swagger.dart';
import '../common/exceptions/ApiException.dart';
import '../common/exceptions/exception_resolver.dart';
import '../common/loading_indicator.dart';
import '../drawer/drawer.dart';
import '../state.dart';

class CategoryMain extends StatefulWidget {
  const CategoryMain({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CategoryMainState();
}

class _CategoryMainState extends State<CategoryMain> {
  late Future<List<CategoryDTO>> _categoriesFuture;
  late CategoryService _categoryService;
  late ExceptionResolver _exceptionResolver;
  List<bool>? _expanded;
  List<CategoryDTO>? _categories;

  void initState() {
    super.initState();
    _exceptionResolver = ExceptionResolver(context: context);
    _categoryService = CategoryService(
        context: context, exceptionResolver: _exceptionResolver);
    _categoriesFuture = _categoryService.getAll();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<AppState>(context).addListener(() {
      setState(() {
        _categoriesFuture = _categoryService.getAll();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
      ),
      body: FutureBuilder(
        future: _categoriesFuture,
        builder: futureBuilder,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddButtonPressed,
        tooltip: 'Add Category',
        child: const Icon(Icons.add),
      ),
      drawer: const CommonDrawer(),
    );
  }

  Widget futureBuilder(
      BuildContext context, AsyncSnapshot<List<CategoryDTO>> snapshot) {
    if (snapshot.hasData) {
      _categories = snapshot.data!;
      _expanded ??= List.filled(_categories!.length, false, growable: true);
      return CategoryExpansionList(
        categories: _categories,
        onCategoryDelete: onPlaceDelete,
        onCategoryEdit: onCategoryEdit,
        onExpanded: onExpanded,
        expandedList: _expanded,
        onRefresh: onCategoryListRefresh,
        refreshable: true,
      );
    } else if (snapshot.hasError) {
      return Text("Error: ${snapshot.error.toString()}");
    } else {
      return const LoadingIndicator(title: "Loading categories");
    }
  }

  void onExpanded(int panelIndex, bool isExpanded) {
    setState(() => {_expanded![panelIndex] = !isExpanded});
  }

  void onAddButtonPressed() async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Saving")));
    Future<CategoryDTO?> createdCategory = showDialog<CategoryDTO>(
      context: context,
      builder: (context) {
        return AddCategoryPopup(
          categoryService: _categoryService,
          exceptionResolver: _exceptionResolver,
          addNew: true,
        );
      },
    );
    createdCategory.then((value) {
      setState(() {
        if (value != null) _categories!.add(value);
        // this will be processed by FutureBuilder so UI can be drawn
        _categoriesFuture = Future.value(_categories);
        // if some new item was added then it is as last item on list
        // add it to _expanded register
        if (_expanded!.length != _categories!.length) {
          _expanded!.addAll(List.filled(
              (_categories!.length - _expanded!.length).abs(), false));
        }
      });
    });
  }

  onPlaceDelete(CategoryDTO category) {
    _categoryService.delete(category).then((value) {
      int idx = _categories!.indexOf(category);
      if (idx >= 0) {
        setState(() {
          _categories!.remove(category);
          _expanded!.removeAt(idx);
          _categoriesFuture = Future(() => _categories!);
        });
      }
    }).catchError((error, stackTrace) {
      _exceptionResolver.resolveAndShow(error);
    }, test: (o) => o is ApiException);
  }

  onCategoryEdit(CategoryDTO category) {
    Future<CategoryDTO?> editedCategory = showDialog<CategoryDTO>(
        context: context,
        builder: (ctx) => AddCategoryPopup(
              categoryService: _categoryService,
              exceptionResolver: _exceptionResolver,
              addNew: false,
              category: category,
            ));
    _categoryService
        .onCategoryEditedListener(editedCategory, category, _categories!)
        .then((value) => setState(() {}));
  }

  Future<void> onCategoryListRefresh() async {
    _categoriesFuture = _categoryService.getAll();
    _categoriesFuture.then((value) => ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Reloaded"))));
    setState(() {});
  }
}
