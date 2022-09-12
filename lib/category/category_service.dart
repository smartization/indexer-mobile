import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:indexer_client/api/api_spec.swagger.dart';
import 'package:indexer_client/common/dto_service.dart';
import 'package:indexer_client/common/exceptions/exception_resolver.dart';

import '../common/exceptions/ApiException.dart';

class CategoryService extends DTOService {
  final ExceptionResolver exceptionResolver;

  CategoryService({required super.context, required this.exceptionResolver});

  Future<List<CategoryDTO>> getAll() async {
    Response<List<CategoryDTO>> response = await getApi().categoriesGet();
    return resolveResponse(response) as List<CategoryDTO>;
  }

  Future<CategoryDTO> save(CategoryDTO category) async {
    Response<CategoryDTO> response =
        await getApi().categoriesPost(body: category);
    return resolveResponse(response) as CategoryDTO;
  }

  Future<CategoryDTO> update(CategoryDTO categoryDTO) async {
    Response<CategoryDTO> response =
        await getApi().categoriesPut(body: categoryDTO);
    return resolveResponse(response) as CategoryDTO;
  }

  Future<CategoryDTO> delete(CategoryDTO category) async {
    Response<dynamic> response =
        await getApi().categoriesIdDelete(id: category.id);
    resolveResponse(response);
    return Future.value();
  }

  onCategoryEditedListener(Future<CategoryDTO?> editedCategory,
      CategoryDTO oldCategory, List<CategoryDTO> categories,
      {showSaveNotification = true}) async {
    CategoryDTO? value = await editedCategory;
    try {
      if (value != null) {
        int idx = categories.indexOf(oldCategory);
        categories.removeAt(idx);
        categories.insert(idx, value);
        if (showSaveNotification) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Saving")));
        }
      } else if (showSaveNotification) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Category was not changed")));
      }
    } on ApiException catch (error) {
      exceptionResolver.resolveAndShow(error);
    }
  }
}
