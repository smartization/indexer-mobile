import 'package:chopper/chopper.dart';
import 'package:indexer_client/api/api_spec.swagger.dart';
import 'package:indexer_client/common/dto_service.dart';

class PlaceService extends DTOService {
  PlaceService({required super.context});

  Future<List<PlaceDTO>> getAll() async {
    Response<List<PlaceDTO>> response = await getApi().placesGet();
    return resolveResponse(response) as List<PlaceDTO>;
  }

  Future<PlaceDTO> save(PlaceDTO place) async {
    Response<PlaceDTO> response = await getApi().placesPost(body: place);
    return resolveResponse(response) as PlaceDTO;
  }

  Future<PlaceDTO> delete(PlaceDTO place) async {
    Response<dynamic> response = await getApi().placesIdDelete(id: place.id);
    resolveResponse(response);
    return Future.value();
  }
}
