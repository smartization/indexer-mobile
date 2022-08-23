// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_spec.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) =>
    ErrorResponse(
      timestamp: json['timestamp'] as num?,
      status: json['status'] as num?,
      error: json['error'] as String?,
      message: json['message'] as String?,
      path: json['path'] as String?,
    );

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'status': instance.status,
      'error': instance.error,
      'message': instance.message,
      'path': instance.path,
    };

PlaceDTO _$PlaceDTOFromJson(Map<String, dynamic> json) => PlaceDTO(
      id: json['id'] as num?,
      name: json['name'] as String,
    );

Map<String, dynamic> _$PlaceDTOToJson(PlaceDTO instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

ItemDTO _$ItemDTOFromJson(Map<String, dynamic> json) => ItemDTO(
      id: json['id'] as num?,
      name: json['name'] as String,
      description: json['description'] as String?,
      barcode: json['barcode'] as String?,
      barcodeType: itemDTOBarcodeTypeFromJson(json['barcodeType']),
      storagePlace: json['storagePlace'] == null
          ? null
          : PlaceDTO.fromJson(json['storagePlace'] as Map<String, dynamic>),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
    );

Map<String, dynamic> _$ItemDTOToJson(ItemDTO instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'barcode': instance.barcode,
      'barcodeType': itemDTOBarcodeTypeToJson(instance.barcodeType),
      'storagePlace': instance.storagePlace?.toJson(),
      'dueDate': _dateToJson(instance.dueDate),
    };

BarcodeDTO _$BarcodeDTOFromJson(Map<String, dynamic> json) => BarcodeDTO(
      title: json['title'] as String?,
      value: json['value'] as String?,
      searchResult: json['searchResult'] as String?,
      processingTime: json['processingTime'] == null
          ? null
          : DateTime.parse(json['processingTime'] as String),
      link: json['link'] as String?,
    );

Map<String, dynamic> _$BarcodeDTOToJson(BarcodeDTO instance) =>
    <String, dynamic>{
      'title': instance.title,
      'value': instance.value,
      'searchResult': instance.searchResult,
      'processingTime': instance.processingTime?.toIso8601String(),
      'link': instance.link,
    };
