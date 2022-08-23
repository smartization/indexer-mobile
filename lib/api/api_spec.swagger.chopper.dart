// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_spec.swagger.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$ApiSpec extends ApiSpec {
  _$ApiSpec([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ApiSpec;

  @override
  Future<Response<List<PlaceDTO>>> _placesGet() {
    final $url = '/places/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<List<PlaceDTO>, PlaceDTO>($request);
  }

  @override
  Future<Response<PlaceDTO>> _placesPost({required PlaceDTO? body}) {
    final $url = '/places/';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<PlaceDTO, PlaceDTO>($request);
  }

  @override
  Future<Response<List<ItemDTO>>> _itemsGet() {
    final $url = '/items/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<List<ItemDTO>, ItemDTO>($request);
  }

  @override
  Future<Response<ItemDTO>> _itemsPost({required ItemDTO? body}) {
    final $url = '/items/';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ItemDTO, ItemDTO>($request);
  }

  @override
  Future<Response<PlaceDTO>> _placesPlaceIdDeleteItemItemIdPatch(
      {required num? placeId, required num? itemId}) {
    final $url = '/places/${placeId}/delete/item/${itemId}';
    final $request = Request('PATCH', $url, client.baseUrl);
    return client.send<PlaceDTO, PlaceDTO>($request);
  }

  @override
  Future<Response<PlaceDTO>> _placesPlaceIdAddItemItemIdPatch(
      {required num? placeId, required num? itemId}) {
    final $url = '/places/${placeId}/add/item/${itemId}';
    final $request = Request('PATCH', $url, client.baseUrl);
    return client.send<PlaceDTO, PlaceDTO>($request);
  }

  @override
  Future<Response<PlaceDTO>> _placesIdGet({required num? id}) {
    final $url = '/places/${id}';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<PlaceDTO, PlaceDTO>($request);
  }

  @override
  Future<Response<dynamic>> _placesIdDelete({required num? id}) {
    final $url = '/places/${id}';
    final $request = Request('DELETE', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<ItemDTO>> _itemsIdGet({required num? id}) {
    final $url = '/items/${id}';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<ItemDTO, ItemDTO>($request);
  }

  @override
  Future<Response<dynamic>> _itemsIdDelete({required num? id}) {
    final $url = '/items/${id}';
    final $request = Request('DELETE', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<BarcodeDTO>> _barcodesBarcodeGet({required String? barcode}) {
    final $url = '/barcodes/${barcode}';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BarcodeDTO, BarcodeDTO>($request);
  }
}
