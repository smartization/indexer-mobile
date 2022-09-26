part of "item_search_bottom_sheet.dart";

class _CategoryNameSearchBox extends StatelessWidget {
  final List<num> selectedCategories;
  final List<CategoryDTO>? allCategories;
  final Function(CategoryDTO) onNewSelected;

  const _CategoryNameSearchBox(
      {required this.selectedCategories,
      required this.allCategories,
      required this.onNewSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: _generateChildren(),
    );
  }

  List<Widget> _generateChildren() {
    if (allCategories == null) {
      return [const Text("Cannot load categories")];
    } else {
      return allCategories!.map((e) => _createSingleChild(e)).toList();
    }
  }

  Widget _createSingleChild(CategoryDTO v) {
    return ActionChip(
      label: Text(v.name),
      onPressed: () => onNewSelected(v),
      avatar: selectedCategories.contains(v.id)
          ? const Icon(
              Icons.check_circle_outline,
            )
          : Icon(
              Icons.check_circle_outline,
              color: Colors.grey.shade500,
            ),
      backgroundColor: selectedCategories.contains(v.id)
          ? Colors.blue.shade400
          : Colors.grey.shade300,
      // backgroundColor: selectedCategories.contains(v.id!) ? Colors.green : Colors.grey,
    );
  }
}
