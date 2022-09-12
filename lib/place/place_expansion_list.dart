import 'package:flutter/material.dart';

import '../api/api_spec.swagger.dart';
import 'expansion_panel/place_expansion_panel.dart';

class PlaceExpansionList extends StatelessWidget {
  final List<PlaceDTO> places;
  final ExpansionPanelCallback? onExpanded;
  final Function(PlaceDTO) onPlaceDelete;
  final Function(PlaceDTO) onPlaceEdit;
  final List<bool> expandedList;

  const PlaceExpansionList(
      {Key? key,
      required places,
      this.onExpanded,
      expandedList,
      required this.onPlaceDelete,
      required this.onPlaceEdit})
      : expandedList = expandedList ?? const [],
        places = places ?? const [],
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
    return places
        .asMap()
        .entries
        .map((e) => PlaceExpansionPanel.from(
            e.value, expandedList[e.key], onPlaceDelete, onPlaceEdit))
        .toList();
  }
}
