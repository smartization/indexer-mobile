import 'package:flutter/material.dart';

import '../../api/api_spec.swagger.dart';

class ItemExpansionPanelBody extends StatelessWidget {
  final ItemDTO item;
  final Function(ItemDTO) onDelete;
  final Function(ItemDTO) onEdit;

  const ItemExpansionPanelBody(
      {Key? key,
      required this.item,
      required this.onDelete,
      required this.onEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: [
            _ItemTable(item: item),
            _BottomButtons(
              onDelete: () => onDelete(item),
              onEdit: () => onEdit(item),
            )
          ],
        )
    );
  }
}

class _ItemTable extends StatelessWidget {
  final ItemDTO item;

  const _ItemTable({required this.item});

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(
            children: [
              const Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(item.name)
            ]
        ),
        TableRow(
            children: [
              const Text(
                  "Description", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(item.description ?? "N/A")
            ]
        ),
        TableRow(
            children: [
              const Text("Storage Place",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(item.storagePlace!.name)
            ]
        ),
        TableRow(
            children: [
              const Text(
                  "Due Date", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(item.dueDate.toString())
            ]
        ),
        TableRow(
            children: [
              const Text(
                  "Barcode", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(item.barcode ?? "N/A")
            ]
        )
      ],
    );
  }
}

class _BottomButtons extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _BottomButtons({required this.onDelete, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
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
      )
    );
  }}