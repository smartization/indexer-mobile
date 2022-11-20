import 'package:flutter/material.dart';
import 'package:indexer_client/state.dart';
import 'package:provider/provider.dart';

import '../../../api/api_spec.swagger.dart';
import '../../../item/item_expansion_list.dart';

part 'bottom_buttons.dart';

part "category_table.dart";

part 'items_list.dart';

class CategoryExpansionPanelBody extends StatelessWidget {
  final CategoryDTO category;
  final Function(CategoryDTO) onDelete;
  final Function(CategoryDTO) onEdit;

  const CategoryExpansionPanelBody(
      {Key? key,
      required this.category,
      required this.onDelete,
      required this.onEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: [
            _CategoryTable(category: category),
            _ItemsList(category: category),
            _BottomButtons(
              onDelete: () => onDelete(category),
              onEdit: () => onEdit(category),
            )
          ],
        ));
  }
}
