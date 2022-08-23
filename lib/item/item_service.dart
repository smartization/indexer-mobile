import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:indexer_client/common/exceptions/ApiException.dart';
import 'package:provider/provider.dart';

import '../api/api_spec.swagger.dart';
import '../state.dart';

class ItemService {
  final BuildContext context;

  ItemService({required this.context});

  Future<List<ItemDTO>> getAllItems() async {
    Response<List<ItemDTO>> response = await _getApi().itemsGet();
    return _resolveResponse(response) as List<ItemDTO>;
  }

  Future<ItemDTO> saveItem(ItemDTO item) async {
    Response<ItemDTO> response = await _getApi().itemsPost(body: item);
    return _resolveResponse(response) as ItemDTO;
  }

  Future<void> delete(ItemDTO item) async {
    Response<dynamic> response = await _getApi().itemsIdDelete(id: item.id);
    _resolveResponse(response);
    return Future.value();
  }

  Object _resolveResponse(Response response) {
    if (response.isSuccessful) {
      return response.body ?? "";
    } else {
      throw ApiException(
          reason: response.error.toString(),
          code: response.statusCode.toString());
    }
  }

  ApiSpec _getApi() {
    var client = ChopperClient(
        services: [ApiSpec.create()],
        converter: $JsonSerializableConverter(),
        baseUrl: Provider.of<AppState>(context, listen: false).serverAddress ?? "");
    return client.getService<ApiSpec>();
  }
}