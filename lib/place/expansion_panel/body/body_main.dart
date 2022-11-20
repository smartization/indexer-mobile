import 'package:flutter/material.dart';
import 'package:indexer_client/state.dart';
import 'package:provider/provider.dart';

import '../../../api/api_spec.swagger.dart';
import '../../../item/item_expansion_list.dart';

part 'bottom_buttons.dart';

part 'items_list.dart';

part "place_table.dart";

class PlaceExpansionPanelBody extends StatelessWidget {
  final PlaceDTO place;
  final Function(PlaceDTO) onDelete;
  final Function(PlaceDTO) onEdit;

  const PlaceExpansionPanelBody(
      {Key? key,
      required this.place,
      required this.onDelete,
      required this.onEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: [
            _PlaceTable(place: place),
            _ItemsList(place: place),
            _BottomButtons(
              onDelete: () => onDelete(place),
              onEdit: () => onEdit(place),
            )
          ],
        ));
  }
}
