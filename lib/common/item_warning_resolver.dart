import 'package:flutter/material.dart';
import 'package:indexer_client/api/api_spec.swagger.dart';

class ItemWarningResolver {
  static Widget createIcon(ItemDTO item) {
    if (item.dueDate != null && item.dueDate!.isBefore(DateTime.now())) {
      return const Icon(Icons.warning_amber_rounded, color: Colors.redAccent);
    }
    return Container();
  }

  static Text createReason(ItemDTO item) {
    if (item.dueDate != null && item.dueDate!.isBefore(DateTime.now())) {
      return const Text(
        "Item is after due date",
        style: TextStyle(
          color: Colors.redAccent,
          fontStyle: FontStyle.italic,
        ),
      );
    }
    return const Text("");
  }
}
