part of "body_main.dart";

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
