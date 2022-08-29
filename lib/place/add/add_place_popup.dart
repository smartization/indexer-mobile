import 'package:flutter/material.dart';
import 'package:indexer_client/place/place_service.dart';

import '../../api/api_spec.swagger.dart';
import '../../common/exceptions/exception_resolver.dart';
import 'name_input.dart';

class AddPlacePopup extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  final PlaceService placeService;
  final ExceptionResolver exceptionResolver;

  AddPlacePopup(
      {Key? key, required this.placeService, required this.exceptionResolver})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Add Item"),
      children: [
        Form(
            key: formKey,
            child: Column(
              children: [
                PlaceNameTextInput(controller: nameController),
                ElevatedButton(
                    onPressed: () {
                      onSubmit(context);
                    },
                    child: const Text("Submit"))
              ],
            ))
      ],
    );
  }

  void onSubmit(BuildContext context) {
    if (formKey.currentState!.validate()) {
      final PlaceDTO place = PlaceDTO(name: nameController.text);
      try {
        placeService.save(place).then((value) => Navigator.pop(context, value));
      } on Exception catch (e) {
        exceptionResolver.resolveAndShow(e);
        Navigator.pop(context);
      }
    }
  }
}
