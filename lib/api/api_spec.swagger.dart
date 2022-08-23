// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import 'dart:convert';

import 'package:chopper/chopper.dart';

import 'client_mapping.dart';
import 'package:chopper/chopper.dart' as chopper;
import 'api_spec.enums.swagger.dart' as enums;
export 'api_spec.enums.swagger.dart';

part 'api_spec.swagger.chopper.dart';
part 'api_spec.swagger.g.dart';

// **************************************************************************
// SwaggerChopperGenerator
// **************************************************************************

@ChopperApi()
abstract class ApiSpec extends ChopperService {
  static ApiSpec create(
      {ChopperClient? client,
      Authenticator? authenticator,
      String? baseUrl,
      Iterable<dynamic>? interceptors}) {
    if (client != null) {
      return _$ApiSpec(client);
    }

    final newClient = ChopperClient(
        services: [_$ApiSpec()],
        converter: $JsonSerializableConverter(),
        interceptors: interceptors ?? [],
        authenticator: authenticator,
        baseUrl: baseUrl ?? 'http://');
    return _$ApiSpec(newClient);
  }

  ///Get all available places
  Future<chopper.Response<List<PlaceDTO>>> placesGet() {
    generatedMapping.putIfAbsent(PlaceDTO, () => PlaceDTO.fromJsonFactory);

    return _placesGet();
  }

  ///Get all available places
  @Get(path: '/places/')
  Future<chopper.Response<List<PlaceDTO>>> _placesGet();

  ///Add one place
  Future<chopper.Response<PlaceDTO>> placesPost({required PlaceDTO? body}) {
    generatedMapping.putIfAbsent(PlaceDTO, () => PlaceDTO.fromJsonFactory);

    return _placesPost(body: body);
  }

  ///Add one place
  @Post(path: '/places/')
  Future<chopper.Response<PlaceDTO>> _placesPost(
      {@Body() required PlaceDTO? body});

  ///Returns all possible items
  Future<chopper.Response<List<ItemDTO>>> itemsGet() {
    generatedMapping.putIfAbsent(ItemDTO, () => ItemDTO.fromJsonFactory);

    return _itemsGet();
  }

  ///Returns all possible items
  @Get(path: '/items/')
  Future<chopper.Response<List<ItemDTO>>> _itemsGet();

  ///Post single item into indexer
  Future<chopper.Response<ItemDTO>> itemsPost({required ItemDTO? body}) {
    generatedMapping.putIfAbsent(ItemDTO, () => ItemDTO.fromJsonFactory);

    return _itemsPost(body: body);
  }

  ///Post single item into indexer
  @Post(path: '/items/')
  Future<chopper.Response<ItemDTO>> _itemsPost(
      {@Body() required ItemDTO? body});

  ///Delete single item from given place
  ///@param placeId Place from which item will be deleted
  ///@param itemId Item which will be deleted
  Future<chopper.Response<PlaceDTO>> placesPlaceIdDeleteItemItemIdPatch(
      {required num? placeId, required num? itemId}) {
    generatedMapping.putIfAbsent(PlaceDTO, () => PlaceDTO.fromJsonFactory);

    return _placesPlaceIdDeleteItemItemIdPatch(
        placeId: placeId, itemId: itemId);
  }

  ///Delete single item from given place
  ///@param placeId Place from which item will be deleted
  ///@param itemId Item which will be deleted
  @Patch(path: '/places/{placeId}/delete/item/{itemId}', optionalBody: true)
  Future<chopper.Response<PlaceDTO>> _placesPlaceIdDeleteItemItemIdPatch(
      {@Path('placeId') required num? placeId,
      @Path('itemId') required num? itemId});

  ///Add single item into given place
  ///@param placeId Place to which item will be added
  ///@param itemId Item which will be added
  Future<chopper.Response<PlaceDTO>> placesPlaceIdAddItemItemIdPatch(
      {required num? placeId, required num? itemId}) {
    generatedMapping.putIfAbsent(PlaceDTO, () => PlaceDTO.fromJsonFactory);

    return _placesPlaceIdAddItemItemIdPatch(placeId: placeId, itemId: itemId);
  }

  ///Add single item into given place
  ///@param placeId Place to which item will be added
  ///@param itemId Item which will be added
  @Patch(path: '/places/{placeId}/add/item/{itemId}', optionalBody: true)
  Future<chopper.Response<PlaceDTO>> _placesPlaceIdAddItemItemIdPatch(
      {@Path('placeId') required num? placeId,
      @Path('itemId') required num? itemId});

  ///Get one place pointed by id
  ///@param id
  Future<chopper.Response<PlaceDTO>> placesIdGet({required num? id}) {
    generatedMapping.putIfAbsent(PlaceDTO, () => PlaceDTO.fromJsonFactory);

    return _placesIdGet(id: id);
  }

  ///Get one place pointed by id
  ///@param id
  @Get(path: '/places/{id}')
  Future<chopper.Response<PlaceDTO>> _placesIdGet(
      {@Path('id') required num? id});

  ///Delete one place pointed by give id
  ///@param id
  Future<chopper.Response> placesIdDelete({required num? id}) {
    return _placesIdDelete(id: id);
  }

  ///Delete one place pointed by give id
  ///@param id
  @Delete(path: '/places/{id}')
  Future<chopper.Response> _placesIdDelete({@Path('id') required num? id});

  ///Returns single entity pointed by it id
  ///@param id item id to resolve
  Future<chopper.Response<ItemDTO>> itemsIdGet({required num? id}) {
    generatedMapping.putIfAbsent(ItemDTO, () => ItemDTO.fromJsonFactory);

    return _itemsIdGet(id: id);
  }

  ///Returns single entity pointed by it id
  ///@param id item id to resolve
  @Get(path: '/items/{id}')
  Future<chopper.Response<ItemDTO>> _itemsIdGet({@Path('id') required num? id});

  ///Delete single item pointed by its id
  ///@param id item description
  Future<chopper.Response> itemsIdDelete({required num? id}) {
    return _itemsIdDelete(id: id);
  }

  ///Delete single item pointed by its id
  ///@param id item description
  @Delete(path: '/items/{id}')
  Future<chopper.Response> _itemsIdDelete({@Path('id') required num? id});

  ///Resolve single barcode
  ///@param barcode
  Future<chopper.Response<BarcodeDTO>> barcodesBarcodeGet(
      {required String? barcode}) {
    generatedMapping.putIfAbsent(BarcodeDTO, () => BarcodeDTO.fromJsonFactory);

    return _barcodesBarcodeGet(barcode: barcode);
  }

  ///Resolve single barcode
  ///@param barcode
  @Get(path: '/barcodes/{barcode}')
  Future<chopper.Response<BarcodeDTO>> _barcodesBarcodeGet(
      {@Path('barcode') required String? barcode});
}

@JsonSerializable(explicitToJson: true)
class ErrorResponse {
  ErrorResponse({
    this.timestamp,
    this.status,
    this.error,
    this.message,
    this.path,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  @JsonKey(name: 'timestamp')
  final num? timestamp;
  @JsonKey(name: 'status')
  final num? status;
  @JsonKey(name: 'error')
  final String? error;
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'path')
  final String? path;
  static const fromJsonFactory = _$ErrorResponseFromJson;
  static const toJsonFactory = _$ErrorResponseToJson;
  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);

  @override
  String toString() => jsonEncode(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ErrorResponse &&
            (identical(other.timestamp, timestamp) ||
                const DeepCollectionEquality()
                    .equals(other.timestamp, timestamp)) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality()
                    .equals(other.message, message)) &&
            (identical(other.path, path) ||
                const DeepCollectionEquality().equals(other.path, path)));
  }

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(timestamp) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(error) ^
      const DeepCollectionEquality().hash(message) ^
      const DeepCollectionEquality().hash(path) ^
      runtimeType.hashCode;
}

extension $ErrorResponseExtension on ErrorResponse {
  ErrorResponse copyWith(
      {num? timestamp,
      num? status,
      String? error,
      String? message,
      String? path}) {
    return ErrorResponse(
        timestamp: timestamp ?? this.timestamp,
        status: status ?? this.status,
        error: error ?? this.error,
        message: message ?? this.message,
        path: path ?? this.path);
  }
}

extension $ErrorResponseWrappedExtension on ErrorResponse {
  ErrorResponse copyWith(
      {Wrapped<num?>? timestamp,
      Wrapped<num?>? status,
      Wrapped<String?>? error,
      Wrapped<String?>? message,
      Wrapped<String?>? path}) {
    return ErrorResponse(
        timestamp: (timestamp != null ? timestamp.value : this.timestamp),
        status: (status != null ? status.value : this.status),
        error: (error != null ? error.value : this.error),
        message: (message != null ? message.value : this.message),
        path: (path != null ? path.value : this.path));
  }
}

@JsonSerializable(explicitToJson: true)
class PlaceDTO {
  PlaceDTO({
    this.id,
    required this.name,
  });

  factory PlaceDTO.fromJson(Map<String, dynamic> json) =>
      _$PlaceDTOFromJson(json);

  @JsonKey(name: 'id')
  final num? id;
  @JsonKey(name: 'name')
  final String name;
  static const fromJsonFactory = _$PlaceDTOFromJson;
  static const toJsonFactory = _$PlaceDTOToJson;
  Map<String, dynamic> toJson() => _$PlaceDTOToJson(this);

  @override
  String toString() => jsonEncode(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is PlaceDTO &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)));
  }

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      runtimeType.hashCode;
}

extension $PlaceDTOExtension on PlaceDTO {
  PlaceDTO copyWith({num? id, String? name}) {
    return PlaceDTO(id: id ?? this.id, name: name ?? this.name);
  }
}

extension $PlaceDTOWrappedExtension on PlaceDTO {
  PlaceDTO copyWith({Wrapped<num?>? id, Wrapped<String>? name}) {
    return PlaceDTO(
        id: (id != null ? id.value : this.id),
        name: (name != null ? name.value : this.name));
  }
}

@JsonSerializable(explicitToJson: true)
class ItemDTO {
  ItemDTO({
    this.id,
    required this.name,
    this.description,
    this.barcode,
    this.barcodeType,
    this.storagePlace,
    this.dueDate,
  });

  factory ItemDTO.fromJson(Map<String, dynamic> json) =>
      _$ItemDTOFromJson(json);

  @JsonKey(name: 'id')
  final num? id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'barcode')
  final String? barcode;
  @JsonKey(
      name: 'barcodeType',
      toJson: itemDTOBarcodeTypeToJson,
      fromJson: itemDTOBarcodeTypeFromJson)
  final enums.ItemDTOBarcodeType? barcodeType;
  @JsonKey(name: 'storagePlace')
  final PlaceDTO? storagePlace;
  @JsonKey(name: 'dueDate', toJson: _dateToJson)
  final DateTime? dueDate;
  static const fromJsonFactory = _$ItemDTOFromJson;
  static const toJsonFactory = _$ItemDTOToJson;
  Map<String, dynamic> toJson() => _$ItemDTOToJson(this);

  @override
  String toString() => jsonEncode(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ItemDTO &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.barcode, barcode) ||
                const DeepCollectionEquality()
                    .equals(other.barcode, barcode)) &&
            (identical(other.barcodeType, barcodeType) ||
                const DeepCollectionEquality()
                    .equals(other.barcodeType, barcodeType)) &&
            (identical(other.storagePlace, storagePlace) ||
                const DeepCollectionEquality()
                    .equals(other.storagePlace, storagePlace)) &&
            (identical(other.dueDate, dueDate) ||
                const DeepCollectionEquality().equals(other.dueDate, dueDate)));
  }

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(barcode) ^
      const DeepCollectionEquality().hash(barcodeType) ^
      const DeepCollectionEquality().hash(storagePlace) ^
      const DeepCollectionEquality().hash(dueDate) ^
      runtimeType.hashCode;
}

extension $ItemDTOExtension on ItemDTO {
  ItemDTO copyWith(
      {num? id,
      String? name,
      String? description,
      String? barcode,
      enums.ItemDTOBarcodeType? barcodeType,
      PlaceDTO? storagePlace,
      DateTime? dueDate}) {
    return ItemDTO(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        barcode: barcode ?? this.barcode,
        barcodeType: barcodeType ?? this.barcodeType,
        storagePlace: storagePlace ?? this.storagePlace,
        dueDate: dueDate ?? this.dueDate);
  }
}

extension $ItemDTOWrappedExtension on ItemDTO {
  ItemDTO copyWith(
      {Wrapped<num?>? id,
      Wrapped<String>? name,
      Wrapped<String?>? description,
      Wrapped<String?>? barcode,
      Wrapped<enums.ItemDTOBarcodeType?>? barcodeType,
      Wrapped<PlaceDTO?>? storagePlace,
      Wrapped<DateTime?>? dueDate}) {
    return ItemDTO(
        id: (id != null ? id.value : this.id),
        name: (name != null ? name.value : this.name),
        description:
            (description != null ? description.value : this.description),
        barcode: (barcode != null ? barcode.value : this.barcode),
        barcodeType:
            (barcodeType != null ? barcodeType.value : this.barcodeType),
        storagePlace:
            (storagePlace != null ? storagePlace.value : this.storagePlace),
        dueDate: (dueDate != null ? dueDate.value : this.dueDate));
  }
}

@JsonSerializable(explicitToJson: true)
class BarcodeDTO {
  BarcodeDTO({
    this.title,
    this.value,
    this.searchResult,
    this.processingTime,
    this.link,
  });

  factory BarcodeDTO.fromJson(Map<String, dynamic> json) =>
      _$BarcodeDTOFromJson(json);

  @JsonKey(name: 'title')
  final String? title;
  @JsonKey(name: 'value')
  final String? value;
  @JsonKey(name: 'searchResult')
  final String? searchResult;
  @JsonKey(name: 'processingTime')
  final DateTime? processingTime;
  @JsonKey(name: 'link')
  final String? link;
  static const fromJsonFactory = _$BarcodeDTOFromJson;
  static const toJsonFactory = _$BarcodeDTOToJson;
  Map<String, dynamic> toJson() => _$BarcodeDTOToJson(this);

  @override
  String toString() => jsonEncode(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is BarcodeDTO &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)) &&
            (identical(other.searchResult, searchResult) ||
                const DeepCollectionEquality()
                    .equals(other.searchResult, searchResult)) &&
            (identical(other.processingTime, processingTime) ||
                const DeepCollectionEquality()
                    .equals(other.processingTime, processingTime)) &&
            (identical(other.link, link) ||
                const DeepCollectionEquality().equals(other.link, link)));
  }

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(value) ^
      const DeepCollectionEquality().hash(searchResult) ^
      const DeepCollectionEquality().hash(processingTime) ^
      const DeepCollectionEquality().hash(link) ^
      runtimeType.hashCode;
}

extension $BarcodeDTOExtension on BarcodeDTO {
  BarcodeDTO copyWith(
      {String? title,
      String? value,
      String? searchResult,
      DateTime? processingTime,
      String? link}) {
    return BarcodeDTO(
        title: title ?? this.title,
        value: value ?? this.value,
        searchResult: searchResult ?? this.searchResult,
        processingTime: processingTime ?? this.processingTime,
        link: link ?? this.link);
  }
}

extension $BarcodeDTOWrappedExtension on BarcodeDTO {
  BarcodeDTO copyWith(
      {Wrapped<String?>? title,
      Wrapped<String?>? value,
      Wrapped<String?>? searchResult,
      Wrapped<DateTime?>? processingTime,
      Wrapped<String?>? link}) {
    return BarcodeDTO(
        title: (title != null ? title.value : this.title),
        value: (value != null ? value.value : this.value),
        searchResult:
            (searchResult != null ? searchResult.value : this.searchResult),
        processingTime: (processingTime != null
            ? processingTime.value
            : this.processingTime),
        link: (link != null ? link.value : this.link));
  }
}

String? itemDTOBarcodeTypeToJson(enums.ItemDTOBarcodeType? itemDTOBarcodeType) {
  return enums.$ItemDTOBarcodeTypeMap[itemDTOBarcodeType];
}

enums.ItemDTOBarcodeType itemDTOBarcodeTypeFromJson(
  Object? itemDTOBarcodeType, [
  enums.ItemDTOBarcodeType? defaultValue,
]) {
  if (itemDTOBarcodeType is String) {
    return enums.$ItemDTOBarcodeTypeMap.entries
        .firstWhere(
            (element) =>
                element.value.toLowerCase() == itemDTOBarcodeType.toLowerCase(),
            orElse: () => const MapEntry(
                enums.ItemDTOBarcodeType.swaggerGeneratedUnknown, ''))
        .key;
  }

  final parsedResult = defaultValue == null
      ? null
      : enums.$ItemDTOBarcodeTypeMap.entries
          .firstWhereOrNull((element) => element.value == defaultValue)
          ?.key;

  return parsedResult ??
      defaultValue ??
      enums.ItemDTOBarcodeType.swaggerGeneratedUnknown;
}

List<String> itemDTOBarcodeTypeListToJson(
    List<enums.ItemDTOBarcodeType>? itemDTOBarcodeType) {
  if (itemDTOBarcodeType == null) {
    return [];
  }

  return itemDTOBarcodeType
      .map((e) => enums.$ItemDTOBarcodeTypeMap[e]!)
      .toList();
}

List<enums.ItemDTOBarcodeType> itemDTOBarcodeTypeListFromJson(
  List? itemDTOBarcodeType, [
  List<enums.ItemDTOBarcodeType>? defaultValue,
]) {
  if (itemDTOBarcodeType == null) {
    return defaultValue ?? [];
  }

  return itemDTOBarcodeType
      .map((e) => itemDTOBarcodeTypeFromJson(e.toString()))
      .toList();
}

typedef $JsonFactory<T> = T Function(Map<String, dynamic> json);

class $CustomJsonDecoder {
  $CustomJsonDecoder(this.factories);

  final Map<Type, $JsonFactory> factories;

  dynamic decode<T>(dynamic entity) {
    if (entity is Iterable) {
      return _decodeList<T>(entity);
    }

    if (entity is T) {
      return entity;
    }

    if (isTypeOf<T, Map>()) {
      return entity;
    }

    if (isTypeOf<T, Iterable>()) {
      return entity;
    }

    if (entity is Map<String, dynamic>) {
      return _decodeMap<T>(entity);
    }

    return entity;
  }

  T _decodeMap<T>(Map<String, dynamic> values) {
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! $JsonFactory<T>) {
      return throw "Could not find factory for type $T. Is '$T: $T.fromJsonFactory' included in the CustomJsonDecoder instance creation in bootstrapper.dart?";
    }

    return jsonFactory(values);
  }

  List<T> _decodeList<T>(Iterable values) =>
      values.where((v) => v != null).map<T>((v) => decode<T>(v) as T).toList();
}

class $JsonSerializableConverter extends chopper.JsonConverter {
  @override
  chopper.Response<ResultType> convertResponse<ResultType, Item>(
      chopper.Response response) {
    if (response.bodyString.isEmpty) {
      // In rare cases, when let's say 204 (no content) is returned -
      // we cannot decode the missing json with the result type specified
      return chopper.Response(response.base, null, error: response.error);
    }

    final jsonRes = super.convertResponse(response);
    return jsonRes.copyWith<ResultType>(
        body: $jsonDecoder.decode<Item>(jsonRes.body) as ResultType);
  }
}

final $jsonDecoder = $CustomJsonDecoder(generatedMapping);

// ignore: unused_element
String? _dateToJson(DateTime? date) {
  if (date == null) {
    return null;
  }

  final year = date.year.toString();
  final month = date.month < 10 ? '0${date.month}' : date.month.toString();
  final day = date.day < 10 ? '0${date.day}' : date.day.toString();

  return '$year-$month-$day';
}

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}
