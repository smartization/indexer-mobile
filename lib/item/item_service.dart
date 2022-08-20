import 'package:flutter/material.dart';
import 'package:indexer_api_client/api.dart';
import 'package:provider/provider.dart';

import '../state.dart';

class ItemService {
  final BuildContext context;

  ItemService({required this.context});

  Future<List<ItemDTO>> getAllItems() {
    ItemControllerApi api = ItemControllerApi(
        ApiClient(basePath: Provider.of<AppState>(context, listen: false).serverAddress)
    );
    return api.get1();
  }
}