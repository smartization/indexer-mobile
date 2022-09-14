import 'package:flutter/material.dart';

import '../../api/api_spec.swagger.dart';
import 'body/body_main.dart';
import 'header.dart';

class CategoryExpansionPanel extends ExpansionPanel {
  CategoryExpansionPanel(
      {required super.headerBuilder,
      required super.body,
      super.isExpanded,
      super.canTapOnHeader});

  CategoryExpansionPanel.from(CategoryDTO category, bool isExpanded,
      Function(CategoryDTO) onCategoryDelete, Function(CategoryDTO) onEdit)
      : this(
            headerBuilder: (ctx, isExpanded) => CategoryExpansionPanelHeader(
                  category: category,
                  isExpanded: isExpanded,
                ),
            body: CategoryExpansionPanelBody(
              category: category,
              onDelete: onCategoryDelete,
              onEdit: onEdit,
            ),
            isExpanded: isExpanded,
            canTapOnHeader: true);
}
