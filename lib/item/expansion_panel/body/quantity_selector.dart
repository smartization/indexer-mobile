part of "body_main.dart";

class _QuantitySelector extends StatelessWidget {
  final Function(int) onIncrement;
  final Function(int) onDecrement;
  final int? value;
  final bool _isEnabled;

  const _QuantitySelector(
      {Key? key,
      required this.onIncrement,
      required this.onDecrement,
      required this.value})
      : _isEnabled = value != null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_isEnabled) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
        child: Column(children: [
          const Text(
            "Total Items",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: onMinusPressed, child: const Icon(Icons.remove)),
              Text(value.toString()),
              TextButton(onPressed: onAddPressed, child: const Icon(Icons.add))
            ],
          )
        ]),
      );
    } else {
      return const SizedBox(
        width: 1,
        height: 1,
      );
    }
  }

  void onAddPressed() {
    onIncrement(value! + 1);
  }

  void onMinusPressed() {
    if (value! > 0) {
      onDecrement(value! - 1);
    }
  }
}
