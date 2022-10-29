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
      return _generateText("Item is after due date", Colors.redAccent);
    }
    return const Text("");
  }

  static Text _generateText(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
