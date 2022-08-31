import 'package:flutter/material.dart';

import '../../api/api_spec.swagger.dart';
import 'body/body_main.dart';
import 'header.dart';

class ItemExpansionPanel extends ExpansionPanel {
  ItemExpansionPanel(
      {required super.headerBuilder,
      required super.body,
      super.isExpanded,
      super.canTapOnHeader});

  ItemExpansionPanel.from(ItemDTO item, bool isExpanded,
      Function(ItemDTO) onItemDelete, Function(ItemDTO) onEdit)
      : this(
            headerBuilder: (ctx, isExpanded) => ItemExpansionPanelHeader(
                  item: item,
                  isExpanded: isExpanded,
                ),
            body: ItemExpansionPanelBody(
              item: item,
              onDelete: onItemDelete,
              onEdit: onEdit,
            ),
            isExpanded: isExpanded,
            canTapOnHeader: true);
}
