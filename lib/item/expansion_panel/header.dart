import 'package:flutter/material.dart';

import '../../api/api_spec.swagger.dart';
import '../../common/item_warning_resolver.dart';

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
        child: Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                    text: item.name,
                    style: TextStyle(
                        overflow: TextOverflow.visible,
                        fontSize: isExpanded ? 20 : 14),
                    children: [
                      TextSpan(
                          text: isUnavailable ? " (Not Available)" : "",
                          style: TextStyle(
                              color: Colors.redAccent.shade100, fontSize: 14))
                    ]),
              ),
            ),
            Builder(builder: _warningBuilder)
          ],
        ));
  }

  Widget _warningBuilder(BuildContext context) {
    if (isExpanded) {
      return Container();
    }
    return ItemWarningResolver.createIcon(item);
  }
}
