import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:indexer_client/api/api_spec.swagger.dart';
import 'package:indexer_client/common/dto_service.dart';

class BarcodeService extends DTOService {
  BarcodeService({required super.context});

  static BarcodeService getInstance(BuildContext context) {
    return BarcodeService(context: context);
  }

  Future<BarcodeDTO> getSuggestion(String barcode) async {
    Response<BarcodeDTO> response =
        await getApi().barcodesBarcodeGet(barcode: barcode);
    return resolveResponse(response) as BarcodeDTO;
  }
}
