import 'package:flutter/material.dart';
import 'package:indexer_client/state.dart';
import 'package:provider/provider.dart';

import '../../api/api_spec.swagger.dart';
import 'body/body_main.dart';
import 'header.dart';

class ItemExpansionPanel extends ExpansionPanel {
  ItemExpansionPanel(
      {required super.headerBuilder,
      required super.body,
      super.isExpanded,
      super.canTapOnHeader});

  ItemExpansionPanel.from(ItemDTO item, BuildContext context)
      : this(
            headerBuilder: (ctx, isExpanded) => ItemExpansionPanelHeader(
                  item: item,
                  isExpanded: Provider.of<AppState>(context, listen: false)
                      .expanded![item]!,
                ),
            body: ItemExpansionPanelBody(item: item),
            isExpanded:
                Provider.of<AppState>(context, listen: false).expanded![item]!,
            canTapOnHeader: true);
}
