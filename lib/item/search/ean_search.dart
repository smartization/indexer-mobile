part of "item_search_bottom_sheet.dart";

class _EanSearch extends StatelessWidget {
  final Function(String) onNewEan;
  final String initialValue;

  const _EanSearch({required this.onNewEan, required this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: BarcodeInput(
        onChanged: (ean) => onNewEan(ean),
        showIcon: true,
        initialValue: initialValue,
      ),
    );
  }
}
