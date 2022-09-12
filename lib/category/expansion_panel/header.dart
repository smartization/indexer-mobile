import 'package:flutter/material.dart';

import '../../api/api_spec.swagger.dart';

class CategoryExpansionPanelHeader extends StatelessWidget {
  final CategoryDTO category;
  final bool isExpanded;

  const CategoryExpansionPanelHeader(
      {required this.category, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Text.rich(TextSpan(
          text: category.name,
          style: TextStyle(fontSize: isExpanded ? 20 : 14))),
    );
  }
}
