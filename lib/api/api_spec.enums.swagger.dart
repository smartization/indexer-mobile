import 'package:json_annotation/json_annotation.dart';

enum ItemDTOBarcodeType {
  @JsonValue('swaggerGeneratedUnknown')
  swaggerGeneratedUnknown,
  ean
}

const $ItemDTOBarcodeTypeMap = {ItemDTOBarcodeType.ean: 'EAN'};
