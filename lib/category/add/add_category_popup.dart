import 'package:flutter/material.dart';
import 'package:indexer_client/category/add/description_input.dart';
import 'package:indexer_client/category/category_service.dart';

import '../../api/api_spec.swagger.dart';
import '../../common/exceptions/exception_resolver.dart';
import 'name_input.dart';

class AddCategoryPopup extends StatefulWidget {
  final CategoryService categoryService;
  final ExceptionResolver exceptionResolver;
  final bool addNew;
  final CategoryDTO? category;

  const AddCategoryPopup(
      {Key? key,
      required this.categoryService,
      required this.exceptionResolver,
      required this.addNew,
      this.category})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddCategoryPopupState(
      categoryService: categoryService,
      exceptionResolver: exceptionResolver,
      addNew: addNew,
      category: category);
}

class _AddCategoryPopupState extends State<AddCategoryPopup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey(debugLabel: "category");
  final CategoryService categoryService;
  final ExceptionResolver exceptionResolver;
  final bool addNew;
  final CategoryDTO? category;

  _AddCategoryPopupState(
      {Key? key,
      required this.categoryService,
      required this.exceptionResolver,
      required this.addNew,
      this.category});

  @override
  void initState() {
    super.initState();
    if (category != null) {
      nameController.text = category!.name;
      descriptionController.text = category!.description ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Add Category"),
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  CategoryNameTextInput(controller: nameController),
                  CategoryDescriptionInput(controller: descriptionController),
                  ElevatedButton(
                      onPressed: () {
                        onSubmit(context);
                      },
                      child: const Text("Submit"))
                ],
              )),
        )
      ],
    );
  }

  void onSubmit(BuildContext context) {
    if (formKey.currentState!.validate()) {
      num id = -1;
      if (this.category != null) {
        id = this.category!.id!;
      }
      final CategoryDTO category = CategoryDTO(
          id: id,
          name: nameController.text,
          description: descriptionController.text);
      try {
        if (addNew) {
          categoryService
              .save(category)
              .then((value) => Navigator.pop(context, value));
        } else {
          categoryService
              .update(category)
              .then((value) => Navigator.pop(context, value));
        }
      } on Exception catch (e) {
        exceptionResolver.resolveAndShow(e);
        Navigator.pop(context);
      }
    }
  }
}
