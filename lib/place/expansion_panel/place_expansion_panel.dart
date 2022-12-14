import 'package:flutter/material.dart';

import '../../api/api_spec.swagger.dart';
import 'body/body_main.dart';
import 'header.dart';

class PlaceExpansionPanel extends ExpansionPanel {
  PlaceExpansionPanel(
      {required super.headerBuilder,
      required super.body,
      super.isExpanded,
      super.canTapOnHeader});

  PlaceExpansionPanel.from(PlaceDTO place, bool isExpanded,
      Function(PlaceDTO) onPlaceDelete, Function(PlaceDTO) onEdit)
      : this(
            headerBuilder: (ctx, isExpanded) => PlaceExpansionPanelHeader(
                  place: place,
                  isExpanded: isExpanded,
                ),
            body: PlaceExpansionPanelBody(
              place: place,
              onDelete: onPlaceDelete,
                onEdit: onEdit),
            isExpanded: isExpanded,
            canTapOnHeader: true);
}
