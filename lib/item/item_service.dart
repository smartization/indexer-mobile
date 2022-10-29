import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:indexer_client/common/dto_service.dart';
import 'package:indexer_client/common/exceptions/exception_resolver.dart';

import '../api/api_spec.swagger.dart';
import '../common/exceptions/ApiException.dart';

class ItemService extends DTOService {
  ExceptionResolver exceptionResolver;

  ItemService({required super.context, required this.exceptionResolver});

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

  Future<void> itemDeleteListener(
      ItemDTO item, List<ItemDTO> items, Map<ItemDTO, bool> expanded) async {
    await delete(item);
    try {
      int idx = items.indexOf(item);
      if (idx >= 0) {
        items.remove(item);
        expanded.remove(item);
      }
    } on ApiException catch (error) {
      exceptionResolver.resolveAndShow(error);
    }
  }

  Future<void> onItemEditedListener(
      Future<ItemDTO?> editedItem, ItemDTO oldItem, List<ItemDTO> items,
      {showSaveNotification = true}) async {
    ItemDTO? item = await editedItem;
    try {
      if (item != null) {
        int idx = items.indexOf(oldItem);
        items.removeAt(idx);
        items.insert(idx, item);
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

  Future<void> saveAndUpdateList(
      ItemDTO newItem, ItemDTO oldItem, List<ItemDTO> items) async {
    Future<ItemDTO> futureItem = updateItem(newItem);
    return onItemEditedListener(futureItem, oldItem, items,
        showSaveNotification: false);
  }
}