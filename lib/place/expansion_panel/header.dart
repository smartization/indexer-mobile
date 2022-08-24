import 'package:flutter/material.dart';

import '../../api/api_spec.swagger.dart';

class PlaceExpansionPanelHeader extends StatelessWidget {
  final PlaceDTO place;
  final bool isExpanded;

  const PlaceExpansionPanelHeader(
      {required this.place, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Text.rich(TextSpan(
          text: place.name, style: TextStyle(fontSize: isExpanded ? 20 : 14))),
    );
  }
}
