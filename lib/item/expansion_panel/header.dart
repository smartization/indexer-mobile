import 'package:flutter/material.dart';

import '../../api/api_spec.swagger.dart';

class ItemExpansionPanelHeader extends StatelessWidget {
  final ItemDTO item;
  final bool isExpanded;

  const ItemExpansionPanelHeader(
      {required this.item, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Text.rich(TextSpan(
          text: item.name, style: TextStyle(fontSize: isExpanded ? 20 : 14))),
    );
  }
}
