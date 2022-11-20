import 'package:flutter/foundation.dart';
import 'package:indexer_client/api/api_spec.swagger.dart';

class AppState extends ChangeNotifier {
  String? serverAddress;
  List<ItemDTO>? items;
  Map<ItemDTO, bool>? expanded;

  void updateExpanded(Map<ItemDTO, bool> expanded) {
    this.expanded = expanded;
    notifyListeners();
  }

  void deleteExpandForItem(ItemDTO item) {
    expanded!.remove(item);
    notifyListeners();
  }

  void expandItem(ItemDTO item) {
    expanded![item] = !expanded![item]!;
    notifyListeners();
  }

  void addExpandedForItem(ItemDTO item, {bool value = false}) {
    expanded![item] = value;
    notifyListeners();
  }

  void copyExpandedBetweenItems(ItemDTO from, ItemDTO to) {
    expanded![to] = expanded![from]!;
    notifyListeners();
  }

  void updateItems(List<ItemDTO> items) {
    this.items = items;
    notifyListeners();
  }

  void addItemAtPosition(ItemDTO item, int idx) {
    items!.insert(idx, item);
    notifyListeners();
  }

  int deleteItem(ItemDTO item) {
    int idx = items!.indexOf(item);
    items!.remove(item);
    notifyListeners();
    return idx;
  }

  void addItem(ItemDTO itemDTO) {
    items!.add(itemDTO);
    notifyListeners();
  }

  ItemDTO getItemById(int itemId) {
    return items!.firstWhere((element) => element.id == itemId);
  }

  void updateServerAddress(String? serverAddress) {
    this.serverAddress = serverAddress;
    notifyListeners();
  }

  void initItems(List<ItemDTO> items) {
    updateItems(items);
    if (expanded == null) {
      Map<ItemDTO, bool> expanded =
          items.asMap().map((key, value) => MapEntry(value, false));
      this.expanded = expanded;
    }
    notifyListeners();
  }
}