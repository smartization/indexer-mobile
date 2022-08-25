import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:indexer_client/common/dto_service.dart';

import '../api/api_spec.swagger.dart';

class ItemService extends DTOService {
  ItemService({required super.context});

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
}