part of "item_search_bottom_sheet.dart";

class _ItemNameSearchBox extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String initialValue;

  const _ItemNameSearchBox(
      {Key? key, required this.onChanged, required this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        onChanged: onChanged,
        initialValue: initialValue,
        decoration: const InputDecoration(
          label: Text("Name"),
          icon: Icon(Icons.search),
        ),
      ),
    );
  }
}
