part of 'body_main.dart';

class _ItemsList extends StatelessWidget {
  final PlaceDTO place;

  const _ItemsList({required this.place});

  @override
  Widget build(BuildContext context) {
    List<ItemDTO> items = Provider.of<AppState>(context).items!;
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: ItemExpansionList(items: filter(items)));
  }

  filter(List<ItemDTO> items) {
    return items
        .where((element) => element.storagePlace?.id! == place.id)
        .toList();
  }
}
