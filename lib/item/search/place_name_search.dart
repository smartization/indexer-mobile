part of "item_search_bottom_sheet.dart";

class _PlaceSearchBox extends StatelessWidget {
  final List<num> selectedPlaces;
  final List<PlaceDTO>? allPlaces;
  final Function(PlaceDTO) onNewSelected;

  const _PlaceSearchBox(
      {required this.selectedPlaces,
      required this.allPlaces,
      required this.onNewSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: _generateChildren(),
    );
  }

  List<Widget> _generateChildren() {
    if (allPlaces == null) {
      return [const Text("Cannot load places")];
    } else {
      return allPlaces!.map((e) => _createSingleChild(e)).toList();
    }
  }

  Widget _createSingleChild(PlaceDTO v) {
    return ActionChip(
      label: Text(v.name),
      onPressed: () => onNewSelected(v),
      avatar: selectedPlaces.contains(v.id)
          ? const Icon(
              Icons.check_circle_outline,
            )
          : Icon(
              Icons.check_circle_outline,
              color: Colors.grey.shade500,
            ),
      backgroundColor: selectedPlaces.contains(v.id)
          ? Colors.blue.shade400
          : Colors.grey.shade300,
    );
  }
}
