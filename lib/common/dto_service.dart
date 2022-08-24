import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api_spec.swagger.dart';
import '../state.dart';
import 'exceptions/ApiException.dart';

class DTOService {
  BuildContext context;

  DTOService({required this.context});

  Object resolveResponse(Response response) {
    if (response.isSuccessful) {
      return response.body ?? "";
    } else {
      throw ApiException(
          reason: response.error.toString(),
          code: response.statusCode.toString());
    }
  }

  ApiSpec getApi() {
    var client = ChopperClient(
        services: [ApiSpec.create()],
        converter: $JsonSerializableConverter(),
        baseUrl:
            Provider.of<AppState>(context, listen: false).serverAddress ?? "");
    return client.getService<ApiSpec>();
  }
}
