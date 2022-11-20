import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:indexer_client/common/dto_service.dart';
import 'package:indexer_client/common/exceptions/exception_resolver.dart';
import 'package:indexer_client/state.dart';
import 'package:provider/provider.dart';

import '../api/api_spec.swagger.dart';
import '../common/exceptions/ApiException.dart';

class ItemService extends DTOService {
  ExceptionResolver exceptionResolver;

  ItemService({required super.context, required this.exceptionResolver});

  static ItemService getInstance(BuildContext context) {
    ExceptionResolver exceptionResolver = ExceptionResolver(context: context);
    return ItemService(context: context, exceptionResolver: exceptionResolver);
  }

  Future<ItemDTO> getOneItem(int id) async {
    Response<ItemDTO> response = await getApi().itemsIdGet(id: id);
    return resolveResponse(response) as ItemDTO;
  }

  Future<List<ItemDTO>> getAllItems() async {
    Response<List<ItemDTO>> response = await getApi().itemsGet();
    return resolveResponse(response) as List<ItemDTO>;
  }

  Future<ItemDTO> saveItem(ItemDTO item) async {
    Response<ItemDTO> response = await getApi().itemsPost(body: item);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Saving")));
    return resolveResponse(response) as ItemDTO;
  }

  Future<void> delete(ItemDTO item) async {
    Response<dynamic> response = await getApi().itemsIdDelete(id: item.id);
    resolveResponse(response);
    return Future.value();
  }

  Future<ItemDTO> updateItem(ItemDTO item) async {
    Response<ItemDTO> response = await getApi().itemsIdPut(body: item);
    return resolveResponse(response) as ItemDTO;
  }

  Future<List<ItemDTO>> getAllItemsOnPlace(num? placeId) async {
    Response<List<ItemDTO>> response =
        await getApi().itemsOnPlacePlaceIdGet(placeId: placeId);
    return resolveResponse(response) as List<ItemDTO>;
  }

  Future<List<ItemDTO>> getAllItemsOnCategory(num? categoryId) async {
    Response<List<ItemDTO>> respomse =
        await getApi().itemsOnCategoryCategoryIdGet(categoryId: categoryId);
    return resolveResponse(respomse) as List<ItemDTO>;
  }

  Future<void> itemDeleteListener(ItemDTO item) async {
    await delete(item);
    try {
      dropItem(item);
    } on ApiException catch (error) {
      exceptionResolver.resolveAndShow(error);
    }
  }

  Future<void> loadAllItemsToState() async {
    try {
      List<ItemDTO> items = await getAllItems();
      Provider.of<AppState>(context, listen: false).initItems(items);
    } on ApiException catch (e) {
      ExceptionResolver.getInstance(context).resolveAndShow(e);
    }
  }

  void dropItem(ItemDTO item) {
    Provider.of<AppState>(context, listen: false).deleteItem(item);
    Provider.of<AppState>(context, listen: false).deleteExpandForItem(item);
  }

  void dropItemById(int itemId) {
    try {
      List<ItemDTO> items =
          Provider.of<AppState>(context, listen: false).items!;
      ItemDTO item = items.firstWhere((element) => element.id == itemId);
      dropItem(item);
    } on StateError catch (e) {
      // do nothing with it. It can happen if user delete some item, and backend
      // will broadcast this information via FCM
      // in such situation app will try to delete this item once more
      // which is impossible
    }
  }

  Future<void> onItemEditedListener(
      Future<ItemDTO?> editedItem, ItemDTO oldItem,
      {showSaveNotification = true}) async {
    ItemDTO? item = await editedItem;
    try {
      if (item != null) {
        swapItems(item, oldItem);
        if (showSaveNotification) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Saving")));
        }
      } else if (showSaveNotification) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Item was not changed")));
      }
    } on ApiException catch (error) {
      exceptionResolver.resolveAndShow(error);
    }
  }

  void swapItems(ItemDTO item, ItemDTO oldItem) {
    if (item.hashCode != oldItem.hashCode) {
      int idx =
          Provider.of<AppState>(context, listen: false).deleteItem(oldItem);
      Provider.of<AppState>(context, listen: false)
          .addItemAtPosition(item, idx);
      Provider.of<AppState>(context, listen: false)
          .copyExpandedBetweenItems(oldItem, item);
      Provider.of<AppState>(context, listen: false)
          .deleteExpandForItem(oldItem);
    }
  }

  Future<void> saveAndUpdateList(ItemDTO newItem, ItemDTO oldItem) async {
    Future<ItemDTO> futureItem = updateItem(newItem);
    return onItemEditedListener(futureItem, oldItem,
        showSaveNotification: false);
  }

  Future<void> refreshItem(int itemId) async {
    try {
      ItemDTO newItem = await getOneItem(itemId);
      try {
        ItemDTO oldItem =
            Provider.of<AppState>(context, listen: false).getItemById(itemId);
        // Provider.of<AppState>(context, listen: false).addExpandedForItem(newItem);
        swapItems(newItem, oldItem);
      } on StateError {
        Provider.of<AppState>(context, listen: false).addItem(newItem);
        Provider.of<AppState>(context, listen: false)
            .addExpandedForItem(newItem);
      }
    } on ApiException catch (error) {
      exceptionResolver.resolveAndShow(error);
    }
  }
}