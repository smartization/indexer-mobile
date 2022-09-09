import 'package:flutter/material.dart';

import '../../api/api_spec.swagger.dart';

class ItemExpansionPanelHeader extends StatelessWidget {
  final ItemDTO item;
  final bool isExpanded;
  late bool isUnavailable;
  late String headerText;

  ItemExpansionPanelHeader(
      {Key? key, required this.item, required this.isExpanded})
      : super(key: key) {
    isUnavailable = ((item.quantity ?? 1) == 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Text.rich(
        TextSpan(
            text: item.name,
            style: TextStyle(
                overflow: TextOverflow.visible, fontSize: isExpanded ? 20 : 14),
            children: [
              TextSpan(
                  text: isUnavailable ? " (Not Available)" : "",
                  style:
                      TextStyle(color: Colors.redAccent.shade100, fontSize: 14))
            ]),
      ),
    );
  }
}
