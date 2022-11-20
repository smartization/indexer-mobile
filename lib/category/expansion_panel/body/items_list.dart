part of 'body_main.dart';

class _ItemsList extends StatelessWidget {
  final CategoryDTO category;

  const _ItemsList({required this.category});

  @override
  Widget build(BuildContext context) {
    List<ItemDTO> items = Provider.of<AppState>(context).items!;
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: ItemExpansionList(
            items: items
                .where((element) => element.category?.id! == category.id)
                .toList()));
  }
}
