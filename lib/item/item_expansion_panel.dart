import 'package:flutter/material.dart';
import 'package:indexer_api_client/api.dart';

class ItemExpansionPanel extends ExpansionPanel {
  ItemExpansionPanel({required super.headerBuilder, required super.body, super.isExpanded, super.canTapOnHeader});

  ItemExpansionPanel.from(ItemDTO item, bool isExpanded) :
        this(
          headerBuilder: (ctx, isExpanded) => ItemExpansionPanelHeader(item: item, isExpanded: isExpanded,),
          body:  ItemExpansionPanelBody(item: item),
          isExpanded: isExpanded,
          canTapOnHeader: true
      );
}

class ItemExpansionPanelHeader extends StatelessWidget {
  final ItemDTO item;
  final bool isExpanded;

  const ItemExpansionPanelHeader({required this.item, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Text.rich(
        TextSpan(
            text: item.name,
            style: TextStyle(
              fontSize: isExpanded ? 20 : 14
            )
        )
      ),
    );
  }

}

class ItemExpansionPanelBody extends StatelessWidget {
  final ItemDTO item;

  const ItemExpansionPanelBody({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
     child: Table(
       children: [
         TableRow(
             children: [
               const Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
               Text(item.name)
             ]
         ),
         TableRow(
             children: [
               const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
               Text(item.description ?? "N/A")
             ]
         ),
         TableRow(
             children: [
               const Text("Storage Place", style: TextStyle(fontWeight: FontWeight.bold)),
               Text(item.storagePlace.name ?? "N/A")
             ]
         ),
         TableRow(
             children: [
               const Text("Due Date", style: TextStyle(fontWeight: FontWeight.bold)),
               Text(item.dueDate.toString())
             ]
         ),
         TableRow(
             children: [
               const Text("Barcode", style: TextStyle(fontWeight: FontWeight.bold)),
               Text(item.barcode ?? "N/A")
             ]
         )
       ],
     ),
    );
  }
}