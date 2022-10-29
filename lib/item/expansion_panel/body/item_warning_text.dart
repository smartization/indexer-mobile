part of 'body_main.dart';

class _ItemWarningText extends StatelessWidget {
  final ItemDTO item;

  const _ItemWarningText({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: ItemWarningResolver.createReason(item),
    );
  }
}
