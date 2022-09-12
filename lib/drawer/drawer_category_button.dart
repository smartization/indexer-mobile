import 'package:flutter/material.dart';
import 'package:indexer_client/category/category_main.dart';

class DrawerCategoryButton extends StatelessWidget {
  const DrawerCategoryButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: const Text("Categories"),
        subtitle: const Text("Categories of items"),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (ctx) => const CategoryMain()));
        });
  }
}
