part of "body_main.dart";

class _BottomButtons extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _BottomButtons({required this.onDelete, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Ink(
                width: 40,
                height: 40,
                decoration: const ShapeDecoration(
                  color: Colors.redAccent,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                    onPressed: onDelete,
                    iconSize: 20,
                    icon: const Icon(
                      Icons.delete,
                    )),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Ink(
                  width: 40,
                  height: 40,
                  decoration: const ShapeDecoration(
                      shape: CircleBorder(), color: Colors.blue),
                  child: IconButton(
                      onPressed: onEdit, icon: const Icon(Icons.edit)),
                ))
          ],
        ));
  }
}
