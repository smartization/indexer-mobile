import 'package:flutter/material.dart';
import 'package:indexer_client/common/loading_indicator.dart';
import 'package:indexer_client/item/barcode_service.dart';
import 'package:indexer_client/item/item_service.dart';

import '../../../api/api_spec.swagger.dart';
import '../../../common/exceptions/exception_resolver.dart';
import '../../../item/add/add_item_popup.dart';
import '../../../item/item_expansion_list.dart';

part 'bottom_buttons.dart';

part 'items_list.dart';

part "place_table.dart";

class PlaceExpansionPanelBody extends StatelessWidget {
  final PlaceDTO place;
  final Function(PlaceDTO) onDelete;

  const PlaceExpansionPanelBody(
      {Key? key, required this.place, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: [
            _PlaceTable(place: place),
            _ItemsList(place: place),
            _BottomButtons(onDelete: () => onDelete(place))
          ],
        ));
  }
}
