import 'package:flutter/material.dart';
import 'package:indexer_client/category/expansion_panel/category_expansion_panel.dart';

import '../api/api_spec.swagger.dart';

class CategoryExpansionList extends StatelessWidget {
  final List<CategoryDTO> categories;
  final ExpansionPanelCallback? onExpanded;
  final Function(CategoryDTO) onCategoryDelete;
  final Function(CategoryDTO) onCategoryEdit;
  final List<bool> expandedList;

  const CategoryExpansionList(
      {Key? key,
      required categories,
      this.onExpanded,
      expandedList,
      required this.onCategoryDelete,
      required this.onCategoryEdit})
      : expandedList = expandedList ?? const [],
        categories = categories ?? const [],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        children: generateChildren(),
        expansionCallback: onExpanded,
      ),
    );
  }

  List<ExpansionPanel> generateChildren() {
    return categories
        .asMap()
        .entries
        .map((e) => CategoryExpansionPanel.from(
            e.value, expandedList[e.key], onCategoryDelete, onCategoryEdit))
        .toList();
  }
}
