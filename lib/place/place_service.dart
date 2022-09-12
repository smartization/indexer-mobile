import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:indexer_client/api/api_spec.swagger.dart';
import 'package:indexer_client/common/dto_service.dart';

import '../common/exceptions/ApiException.dart';
import '../common/exceptions/exception_resolver.dart';

class PlaceService extends DTOService {
  final ExceptionResolver exceptionResolver;

  PlaceService({required super.context, required this.exceptionResolver});

  Future<List<PlaceDTO>> getAll() async {
    Response<List<PlaceDTO>> response = await getApi().placesGet();
    return resolveResponse(response) as List<PlaceDTO>;
  }

  Future<PlaceDTO> save(PlaceDTO place) async {
    Response<PlaceDTO> response = await getApi().placesPost(body: place);
    return resolveResponse(response) as PlaceDTO;
  }

  Future<PlaceDTO> update(PlaceDTO place) async {
    Response<PlaceDTO> response = await getApi().placesPut(body: place);
    return resolveResponse(response) as PlaceDTO;
  }

  Future<PlaceDTO> delete(PlaceDTO place) async {
    Response<dynamic> response = await getApi().placesIdDelete(id: place.id);
    resolveResponse(response);
    return Future.value();
  }

  onPlaceEditedListener(
      Future<PlaceDTO?> editedPlace, PlaceDTO oldPlace, List<PlaceDTO> places,
      {showSaveNotification = true}) async {
    PlaceDTO? place = await editedPlace;
    try {
      if (place != null) {
        int idx = places.indexOf(oldPlace);
        places.removeAt(idx);
        places.insert(idx, place);
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
}
