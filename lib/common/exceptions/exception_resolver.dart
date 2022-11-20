import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:indexer_client/api/api_spec.swagger.dart';
import 'package:indexer_client/common/exceptions/ApiException.dart';

class ExceptionResolver {
  final BuildContext context;

  ExceptionResolver({required this.context});

  static ExceptionResolver getInstance(BuildContext context) {
    return ExceptionResolver(context: context);
  }

  void resolveAndShow(Object exception) {
    if (exception is ApiException) {
      ApiException e = exception;
      ErrorResponse errorResponse =
          ErrorResponse.fromJson(jsonDecode(e.reason));
      ScaffoldMessenger.of(context).showSnackBar(createSnackbar(errorResponse));
    } else if (exception is Exception) {
      ScaffoldMessenger.of(context).showSnackBar(createSnackbar2(exception));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(unhandableException(exception));
    }
  }

  SnackBar createSnackbar(ErrorResponse errorResponse) {
    return SnackBar(
        content: Text("${errorResponse.status} - ${errorResponse.message}"));
  }

  SnackBar createSnackbar2(Exception exception) {
    return SnackBar(content: Text("Exception: ${exception.toString()}"));
  }

  SnackBar unhandableException(Object exception) {
    return SnackBar(
        content: Text(
            "Unhandable exception of type: ${exception.runtimeType} was throw, its content was ${exception.toString()}"));
  }
}
