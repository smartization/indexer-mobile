import 'package:flutter/material.dart';

import '../../api/api_spec.swagger.dart';

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
            _BottomButtons(onDelete: () => onDelete(place))
          ],
        ));
  }
}

class _PlaceTable extends StatelessWidget {
  final PlaceDTO place;

  const _PlaceTable({required this.place});

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          const Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(place.name)
        ]),
      ],
    );
  }
}

class _BottomButtons extends StatelessWidget {
  final VoidCallback onDelete;

  const _BottomButtons({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Ink(
              width: 40,
              height: 40,
              decoration: const ShapeDecoration(
                  color: Colors.redAccent, shape: CircleBorder()),
              child: IconButton(
                  onPressed: onDelete,
                  iconSize: 20,
                  icon: const Icon(
                    Icons.delete,
                  )),
            )
          ],
        ));
  }
}
