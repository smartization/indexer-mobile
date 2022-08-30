part of "body_main.dart";

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
