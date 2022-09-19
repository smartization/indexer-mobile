import 'package:flutter/material.dart';
import 'package:indexer_client/common/exceptions/exception_resolver.dart';
import 'package:indexer_client/item/item_service.dart';

import '../../api/api_spec.swagger.dart';
import '../../common/exceptions/ApiException.dart';

class PlaceExpansionPanelHeader extends StatefulWidget {
  final PlaceDTO place;
  final bool isExpanded;

  const PlaceExpansionPanelHeader(
      {Key? key, required this.place, required this.isExpanded})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _PlaceExpansionPanelState(place: place, isExpanded: isExpanded);
}

class _PlaceExpansionPanelState extends State<PlaceExpansionPanelHeader> {
  final PlaceDTO place;
  final bool isExpanded;
  late ItemService _itemService;
  late ExceptionResolver _exceptionResolver;
  String itemsText = "";

  _PlaceExpansionPanelState({required this.place, required this.isExpanded});

  @override
  void initState() {
    super.initState();
    _exceptionResolver = ExceptionResolver(context: context);
    _itemService =
        ItemService(context: context, exceptionResolver: _exceptionResolver);
    _itemService.getAllItemsOnPlace(place.id).then((value) {
      if (value.isEmpty) {
        itemsText = "empty";
      } else if (value.length == 1) {
        itemsText = "1 item";
      } else {
        itemsText = "${value.length} items";
      }
      setState(() {});
    }).catchError((error, stackTrace) {
      _exceptionResolver.resolveAndShow(error);
    }, test: (o) => o is ApiException);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
              child: Text.rich(TextSpan(
                  text: place.name,
                  style: TextStyle(fontSize: isExpanded ? 20 : 14)))),
          Text(
            itemsText,
            style: TextStyle(color: Colors.grey.shade500),
          )
        ],
      ),
    );
  }
}
